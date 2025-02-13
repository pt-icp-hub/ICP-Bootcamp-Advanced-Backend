import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Map "mo:map/Map";
import { phash; nhash } "mo:map/Map";
import Vector "mo:vector";
import Result "mo:base/Result";
import Float "mo:base/Float";
import { JSON } "mo:serde";
import Debug "mo:base/Debug";

// import the custom types we have in Types.mo
import Types "types";

actor {
  stable var nextId : Nat = 0;
  stable var userIdMap : Map.Map<Principal, Nat> = Map.new<Principal, Nat>();
  stable var userResultsMap : Map.Map<Nat, Vector.Vector<Text>> = Map.new<Nat, Vector.Vector<Text>>();

  public shared ({ caller }) func setUserId() : async Result.Result<Nat, Text> {
    // guardian clause to check if the user already exists
    switch (Map.get(userIdMap, phash, caller)) {
      case (?idFound) return #err("User already has id: " # Nat.toText(idFound));
      case (_) {};
    };

    Map.set(userIdMap, phash, caller, nextId);
    nextId += 1;
    return #ok(nextId - 1);
  };

  public shared ({ caller }) func addUserResult(result : Text) : async Result.Result<{ id : Nat; results : [Text] }, Text> {
    let userId = switch (Map.get(userIdMap, phash, caller)) {
      case (?found) found;
      case (_) return #err("User not found");
    };

    let results = switch (Map.get(userResultsMap, nhash, userId)) {
      case (?found) found;
      case (_) Vector.new<Text>();
    };

    Vector.add(results, result);
    Map.set(userResultsMap, nhash, userId, results);

    return #ok({ id = userId; results = Vector.toArray(results) });
  };

  public query ({ caller }) func getUserResults() : async Result.Result<{ id : Nat; results : [Text] }, Text> {
    let userId = switch (Map.get(userIdMap, phash, caller)) {
      case (?found) found;
      case (_) return #err("User not found");
    };

    let results = switch (Map.get(userResultsMap, nhash, userId)) {
      case (?found) found;
      case (_) return #ok({ id = userId; results = [] });
    };

    return #ok({ id = userId; results = Vector.toArray(results) });
  };

  // This function is not exposed to the frontend
  // function to transform the response
  public query func transform(raw : Types.TransformArgs) : async Types.CanisterHttpResponsePayload {
    let transformed : Types.CanisterHttpResponsePayload = {
      status = raw.response.status;
      body = raw.response.body;
      headers = [
        {
          name = "Content-Security-Policy";
          value = "default-src 'self'";
        },
        { name = "Referrer-Policy"; value = "strict-origin" },
        { name = "Permissions-Policy"; value = "geolocation=(self)" },
        {
          name = "Strict-Transport-Security";
          value = "max-age=63072000";
        },
        { name = "X-Frame-Options"; value = "DENY" },
        { name = "X-Content-Type-Options"; value = "nosniff" },
      ];
    };
    transformed;
  };

  public func outcall_ai_model_for_sentiment_analysis(paragraph : Text) : async Result.Result<{ paragraph : Text; result : Text }, Text> {

    //1. DECLARE IC MANAGEMENT CANISTER
    //We need this so we can use it to make the HTTP request
    let ic : Types.IC = actor ("aaaaa-aa");

    //2. SETUP ARGUMENTS FOR HTTP GET request
    // 2.1 Setup the URL and its query parameters
    let ONE_MINUTE : Nat64 = 60;
    let start_timestamp : Types.Timestamp = 1682978460; // May 1, 2023 22:01:00 GMT
    let host : Text = "api-inference.huggingface.co";
    let url = "https://" # host # "/models/cardiffnlp/twitter-roberta-base-sentiment-latest";

    // 2.2 prepare headers for the system http_request call
    let request_headers = [
      { name = "Host"; value = host # ":443" },
      { name = "User-Agent"; value = "cool_canister" },
      {
        name = "Authorization";
        value = "Bearer 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";
      },
      { name = "Content-Type"; value = "application/json" },
    ];

    // 2.2.1 Transform context
    let transform_context : Types.TransformContext = {
      function = transform;
      context = Blob.fromArray([]);
    };

    // The request body is an array of [Nat8] (see Types.mo) so do the following:
    // 1. Write a JSON string
    // 2. Convert ?Text optional into a Blob, which is an intermediate representation before you cast it as an array of [Nat8]
    // 3. Convert the Blob into an array [Nat8]
    let request_body_json : Text = "{ \"inputs\" : \" " # paragraph # "\" }";
    let request_body_as_Blob : Blob = Text.encodeUtf8(request_body_json);
    let request_body_as_nat8 : [Nat8] = Blob.toArray(request_body_as_Blob);

    // 2.3 The HTTP request
    let http_request : Types.HttpRequestArgs = {
      url = url;
      max_response_bytes = null; //optional for request
      headers = request_headers;
      // note: type of `body` is ?[Nat8] so it is passed here as "?request_body_as_nat8" instead of "request_body_as_nat8"
      body = ?request_body_as_nat8;
      method = #post;
      transform = ?transform_context;
    };

    //3. ADD CYCLES TO PAY FOR HTTP REQUEST

    //The IC specification spec says, "Cycles to pay for the call must be explicitly transferred with the call"
    //IC management canister will make the HTTP request so it needs cycles
    //See: https://internetcomputer.org/docs/current/motoko/main/cycles

    //The way Cycles.add() works is that it adds those cycles to the next asynchronous call
    //"Function add(amount) indicates the additional amount of cycles to be transferred in the next remote call"
    //See: https://internetcomputer.org/docs/current/references/ic-interface-spec/#ic-http_request
    Cycles.add<system>(230_949_972_000);

    //4. MAKE HTTPS REQUEST AND WAIT FOR RESPONSE
    //Since the cycles were added above, we can just call the IC management canister with HTTPS outcalls below
    let http_response : Types.HttpResponsePayload = await ic.http_request(http_request);

    //5. DECODE THE RESPONSE

    //As per the type declarations in `src/Types.mo`, the BODY in the HTTP response
    //comes back as [Nat8s] (e.g. [2, 5, 12, 11, 23]). Type signature:

    //public type HttpResponsePayload = {
    //     status : Nat;
    //     headers : [HttpHeader];
    //     body : [Nat8];
    // };

    //We need to decode that [Nat8] array that is the body into readable text.
    //To do this, we:
    //  1. Convert the [Nat8] into a Blob
    //  2. Use Blob.decodeUtf8() method to convert the Blob to a ?Text optional
    //  3. We use a switch to explicitly call out both cases of decoding the Blob into ?Text
    let response_body : Blob = Blob.fromArray(http_response.body);
    let decoded_text : Text = switch (Text.decodeUtf8(response_body)) {
      case (null) { "No value returned" };
      case (?y) { y };
    };

    // 6. RETURN RESPONSE OF THE BODY
    // decode from JSON to Motoko
    let blob = switch (JSON.fromText(decoded_text, null)) {
      case (#ok(b)) { b };
      case (_) { return #err("Error decoding JSON: " # decoded_text) };
    };

    let results : ?[[{ label_ : Text; score : Float }]] = from_candid (blob);
    let parsed_results = switch (results) {
      case (null) { return #err("Error parsing JSON: " # decoded_text) };
      case (?x) { x[0] };
    };

    var best_score : Float = 0.0;
    var best_result : Text = "";
    for (result in parsed_results.vals()) {
      if (result.score > best_score) {
        best_score := result.score;
        best_result := result.label_;
      };
    };

    return #ok({
      paragraph = paragraph;
      result = best_result # " (confidence: " # Float.toText(best_score) # ")";
    });
  };
};
