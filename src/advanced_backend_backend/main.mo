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
import Char "mo:base/Char";
import Nat32 "mo:base/Nat32";
import Int64 "mo:base/Int64";
import Type "mo:candid/Type";
import Types "types";
import Other "canister:other_backend";
import { n64hash } "mo:map/Map";

actor Advanced {

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
    body_json : ?Text,
    method: Types.HttpMethod,
    url : Text) : async IC.http_request_result {
    
    let http_request : IC.http_request_args = {
      url = url;
      max_response_bytes = null;
      headers = headers;
      body = switch (body_json) { case (?json) { ?Text.encodeUtf8(json) }; case(_) { null }; };
      method = method;
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

    var response = await sendRequest(request_headers, ?request_body_json, #post, url);

    if (response.status == 503) {
      Debug.print("Retry with \"x-wait-for-model\" header, due to 503 response");
      let request_headers_with_wait = Array.append(request_headers, [{ name = "x-wait-for-model"; value = "true" }]);
      response := await sendRequest(request_headers_with_wait, ?request_body_json, #post, url);
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

  public composite query func callOtherCanister(shouldFail : Bool) : async Result.Result<Text, Text> {
    try {
      let response = await Other.doNothingSpecial(shouldFail);
      return #ok(response);
    } catch (error) {
      return #err("Error calling Other.doNothingSpecial: code=" # debug_show(Error.code(error)) # " message=" # Error.message(error));
    };
  };

  public func callOutsideCanister() : async Result.Result<Text, Text> {
    try {
      let outSideCanister = actor("bw4dl-smaaa-aaaaa-qaacq-cai"): actor { greet(name : Text) : async Text };
      let response = await outSideCanister.greet("Alice");
      return #ok(response);
    } catch (error) {
      return #err("Error calling outSideCanister.greet: code=" # debug_show(Error.code(error)) # " message=" # Error.message(error));
    };
  };

  /**
   * Calls the "icrc1_name" function on an external canister.
   * Can only work on Playground or Mainnet.
   *
   * @param {Principal} canisterId - The principal ID of the ICRC1 canister to call.
   * @return {async Result.Result<Text, Text>} - A Result containing either the ICRC1 name or an error.
   */
  public func callOutsideCanisterWithId(canisterId : Principal) : async Result.Result<Text, Text> {
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

  public func callManagementCanister() : async Result.Result<{
    controllers : [Principal];
    status : {
      #stopped;
      #stopping;
      #running;
    };
    memory_size : Nat;
    cycles : Nat
  }, Text> {
    try {
      let canisterInfo : IC.canister_info_result = await IC.canister_info({
        canister_id = Principal.fromActor(Advanced);
        num_requested_changes = ?1;
      });
      let canisterStatus : IC.canister_status_result = await IC.canister_status({
        canister_id = Principal.fromActor(Advanced);
      });
      return #ok({
        controllers = canisterInfo.controllers;
        status = canisterStatus.status;
        memory_size = canisterStatus.memory_size;
        cycles = canisterStatus.cycles;
      });
    } catch (error) {
      return #err("Error calling management canister: code=" # debug_show(Error.code(error)) # " message=" # Error.message(error));
    };
  };

  // ==== CHALLENGE 4 ====

  stable let btcHourlyCandles = Map.new<Nat64, Types.Candle>();

  /**
   * Converts a given text to a floating-point number.
   *
   * @param {Text} t - The text to be converted to a float.
   * @return {async Float} - The floating-point number representation of the input text.
   */
  private func textToFloat(t : Text) : async Float {

    var i : Float = 1;
    var f : Float = 0;
    var isDecimal : Bool = false;

    for (c in t.chars()) {
      if (Char.isDigit(c)) {
        let charToNat : Nat64 = Nat64.fromNat(Nat32.toNat(Char.toNat32(c) -48));
        let natToFloat : Float = Float.fromInt64(Int64.fromNat64(charToNat));
        if (isDecimal) {
          let n : Float = natToFloat / Float.pow(10, i);
          f := f + n;
        } else {
          f := f * 10 + natToFloat;
        };
        i := i + 1;
      } else {
        if (Char.equal(c, '.') or Char.equal(c, ',')) {
          f := f / Float.pow(10, i); // Force decimal
          f := f * Float.pow(10, i); // Correction
          isDecimal := true;
          i := 1;
        } else {
          throw Error.reject("NaN");
        };
      };
    };

    return f;
  };

  public func getBtcHourlyCandles() : async [Types.Candle] {
    return Map.toArrayMap<Nat64, Types.Candle, Types.Candle>(
      btcHourlyCandles,
      func (key : Nat64, value: Types.Candle) {
        return ?value;
      }
    );
  };

  // - create a "job" method (meant to be called by the Timer);
  public func job() : async () {
    
    let url = "https://api.bitget.com/api/v2/spot/market/candles?symbol=BTCUSDT&granularity=1h";
    let request_headers = [];

    var response = await sendRequest(request_headers, null, #get, url);
    
    switch (Text.decodeUtf8(response.body)) {
      case (?decodedText) {
        switch (Serde.JSON.fromText(decodedText, null)) {
          case (#ok(blob)) {
            var response : ?Types.BitGetMarketCandlesResponse = from_candid(blob);
            switch (response) {
              case (?parsedResponse) {
                let candleArray = parsedResponse.data;
                let size = candleArray.size();
                if (size > 1) {
                  // Last candle is incomplete so we want the previous candle from the last candle
                  let responseCandle = candleArray[size - 2];
                  let timestampFloat = await textToFloat(responseCandle[0]);
                  let timestampInt64 = Float.toInt64(timestampFloat);
                  let timestampNat64 = Int64.toNat64(timestampInt64);
                  let candle : Types.Candle = {
                    timestamp = timestampNat64;
                    open = await textToFloat(responseCandle[1]);
                    high = await textToFloat(responseCandle[2]);
                    low = await textToFloat(responseCandle[3]);
                    close = await textToFloat(responseCandle[4]);
                    volume = await textToFloat(responseCandle[5]);
                  };
                  Map.set(btcHourlyCandles, n64hash, timestampNat64, candle);
                }
              };
              case (_) {
                throw Error.reject("Failed to parse response: " # decodedText);
              };
            };
          };
          case (#err(error)) {
            throw Error.reject("Failed to parse JSON: " # error);
          };
        };
       };
       case (_) { 
        throw Error.reject("Failed to decode HTTP outcall response");
      };
    };
  };

  // - create a "cron" job that runs "every 1h".
  // - create a "queued" job that you set to run in "1 min".

  // ==== CHALLENGE 5 ====

  // - Add **tests** to your repo (suggest Mops Test with PocketIC as param)
  // - Run tests, format lint and audits on **github workflow (Action)**
  // - Deploy on mainnet (ask Tiago for Faucet Coupon) and:
  // - Implement monitoring with CycleOps
  // - Cause a trap and then see it in the logs (and also query stats)

};
