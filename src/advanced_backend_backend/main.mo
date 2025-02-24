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
import Serde "mo:serde";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Array "mo:base/Array";
import Bool "mo:base/Bool";
import IC "ic:aaaaa-aa";
import IC_EXP "mo:base/ExperimentalInternetComputer";
import Types "types";
import Other "canister:other_backend";

actor {

  // ==== CHALLENGE 1 ====
  stable let adminsMap = Vector.init<Principal>(1, Principal.fromText("skdcz-xid3o-nsvrx-gogyf-ix6jh-enkm6-44l25-2njsd-7d5zq-agste-jqe"));

  private func isAdmin(principal : Principal) : Bool {
    return Vector.contains(adminsMap, principal, Principal.equal);
  };

  public shared query func getAdmins() : async [Principal] {
    return Vector.toArray(adminsMap);
  };

  public shared ({ caller }) func addAdmin(principal : Principal) : async Result.Result<Text, Text> {

    if (not isAdmin(caller)) {
      return #err("Caller " # debug_show caller # " is not an admin");
    };

    if (isAdmin(principal)) {
      return #err("Principal " # debug_show principal # " is already an admin");
    };

    Vector.add(adminsMap, principal);

    return #ok("Admin " # debug_show principal # " added");
  };

  public shared query ({ caller }) func callProtectedMethod() : async Result.Result<Text, Text> {

    if (not isAdmin(caller)) {
      return #err("Caller " # debug_show caller # " is not an admin");
    };

    return #ok("Ups, this was meant to be protected");
  };

  // ==== CHALLENGE 2 ====

  private type Sentiment = {
    name : Text;
    score : Float;
  };

  public query func transform({
    context : Blob;
    response : IC.http_request_result;
  }) : async IC.http_request_result {
    {
      response with headers = [];
    };
  };

  private func sendRequest(
    headers : [Types.HttpHeader],
    body_json : Text,
    url : Text) : async IC.http_request_result {
    
    let http_request : IC.http_request_args = {
      url = url;
      max_response_bytes = null;
      headers = headers;
      body = ?Text.encodeUtf8(body_json);
      method = #post;
      transform = ?{
        function = transform;
        context = Blob.fromArray([]);
      };
    };

    Cycles.add<system>(230_850_258_000); // Necessary cycles for http outcall

    return await IC.http_request(http_request);
  };

  public func outcall_ai_model_for_sentiment_analysis(paragraph : Text) : async Result.Result<{ paragraph : Text; result : Text }, Text> {
    
    let host : Text = "api-inference.huggingface.co";
    let url = "https://" # host # "/models/cardiffnlp/twitter-roberta-base-sentiment-latest";
    
    let request_headers = [
      { name = "Authorization"; value = "Bearer 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" },
      { name = "Content-Type"; value = "application/json" }
    ];

    let request_body_json : Text = "{ \"inputs\" : \"" # paragraph # "\" }";

    var response = await sendRequest(request_headers, request_body_json, url);

    if (response.status == 503) {
      Debug.print("Retry with \"x-wait-for-model\" header, due to 503 response");
      let request_headers_with_wait = Array.append(request_headers, [{ name = "x-wait-for-model"; value = "true" }]);
      response := await sendRequest(request_headers_with_wait, request_body_json, url);
    };
    
    switch (Text.decodeUtf8(response.body)) {
      case (?decodedText) { 
        let options: Serde.Options = {
          blob_contains_only_values = true;
          use_icrc_3_value_type = false;
          renameKeys = [("label", "name")];
          types = null;
        };
        switch (Serde.JSON.fromText(decodedText, ?options)) {
          case (#ok(blob)) {
            var sentiments : ?[[Sentiment]] = from_candid(blob);
            var highestSentiment : ?Sentiment = null;
            switch (sentiments) {
              case (?sentimentArray) {
                if (sentimentArray.size() > 0) {
                  for (sentiment in sentimentArray[0].vals()) {
                    switch (highestSentiment) {
                      case (?currentHighest) {
                        if (sentiment.score > currentHighest.score) {
                          highestSentiment := ?sentiment;
                        };
                      };
                      case (_) {
                        highestSentiment := ?sentiment;
                      };
                    };
                  };
                }
              };
              case (_) {
                return #err("Failed to parse response: " # decodedText);
              };
            };
            return #ok({
              paragraph = paragraph;
              result = switch (highestSentiment) {
                case (?sentiment) {
                  "Sentiment is " # sentiment.name # ", with score " # debug_show sentiment.score;
                };
                case (_) {
                  "No sentiment";
                };
              };
            });
          };
          case (#err(error)) {
            return #err("Failed to parse JSON: " # error);
          };
        };
       };
       case (_) { 
        return #err("Failed to decode HTTP outcall response");
      };
    };
  };

  // ==== CHALLENGE 3 ====

  public func callOtherCanister(shouldFail : Bool) : async Result.Result<Text, Text> {
    try {
      let response = await Other.doNothingSpecial(shouldFail);
      return #ok(response);
    } catch (error) {
      return #err("Error calling Other.doNothingSpecial: code=" # debug_show(Error.code(error)) # " message=" # Error.message(error));
    };
  };

  public func callOutsideCanister(canisterId : Principal) : async Result.Result<Text, Text> {
    let functionName = "icrc1_name";
    try {
      let encodedValue = await IC_EXP.call(canisterId, functionName, to_candid(()));
      let value : ?Text = from_candid(encodedValue);
      switch (value) {
        case (?icrc1_name) {
          return #ok(icrc1_name);
        };
        case (_) {
          throw Error.reject("Failed to decode response " # debug_show(encodedValue));
        };
      }
    } catch (error) {
      return #err("Error calling " # functionName # " on canister " # debug_show(canisterId) # ": code=" # debug_show(Error.code(error)) # " message=" # Error.message(error));
    };
  };

  public func callManagementCanister() : async Result.Result<Text, Text> {
    return #ok("Not Implemented");
  };

  // ==== CHALLENGE 4 ====

  // - create a "job" method (meant to be called by the Timer);
  // - create a "cron" job that runs "every 1h".
  // - create a "queued" job that you set to run in "1 min".

  // ==== CHALLENGE 5 ====

  // - Add **tests** to your repo (suggest Mops Test with PocketIC as param)
  // - Run tests, format lint and audits on **github workflow (Action)**
  // - Deploy on mainnet (ask Tiago for Faucet Coupon) and:
  // - Implement monitoring with CycleOps
  // - Cause a trap and then see it in the logs (and also query stats)

};
