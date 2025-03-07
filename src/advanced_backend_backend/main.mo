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

  // ==== CHALLENGE 1 ====
  stable let adminsMap = Vector.init<Principal>(1, Principal.fromText("2vxsx-fae")); // feel free to change to your own principal instead of the anonymous one

  public shared ({ caller }) func getAdmins() : async [Principal] {
    return Vector.toArray(adminsMap);
  };

  public shared ({ caller }) func addAdmin(principal : Principal) : async Result.Result<Text, Text> {

    return #ok("Admin " # debug_show principal # " added");
  };

  public shared ({ caller }) func callProtectedMethod() : async Result.Result<Text, Text> {

    return #ok("Ups, this was meant to be protected");
  };

  // ==== CHALLENGE 2 ====

  public func outcall_ai_model_for_sentiment_analysis(paragraph : Text) : async Result.Result<{ paragraph : Text; result : Text }, Text> {
    // important vars and credentials
    // let host : Text = "api-inference.huggingface.co";
    // let url = "https://" # host # "/models/cardiffnlp/twitter-roberta-base-sentiment-latest";
    // important headers:
    // {
    //    name = "Authorization";
    //    value = "Bearer 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";
    // }
    // { name = "Content-Type"; value = "application/json" }

    // let request_body_json : Text = "{ \"inputs\" : \" " # paragraph # "\" }";
    // let request_body_as_Blob : Blob = Text.encodeUtf8(request_body_json);
    // let request_body_as_nat8 : [Nat8] = Blob.toArray(request_body_as_Blob);

    // use Serde package to decode the JSON response

    let api_result : Text = "maybe positive, unless it's negative";

    return #ok({
      paragraph = paragraph;
      result = api_result;
    });
  };

  // ==== CHALLENGE 3 ====

  public func callOtherCanister() : async Result.Result<Text, Text> {
    return #ok("Not Implemented");
  };

  public func callOutsideCanister() : async Result.Result<Text, Text> {
    return #ok("Not Implemented");
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
