import Error "mo:base/Error";

actor Other {
    
    public shared query func doNothingSpecial(shouldFail : Bool) : async Text {
        if (shouldFail) {
            throw Error.reject("Nothing special failed");
        };
        return "This is nothing special";
    };

};