import { test; suite } "mo:test/async";
import { expect } "mo:test";
import Result "mo:base/Result";
import Cycles "mo:base/ExperimentalCycles";
import Bool "mo:base/Bool";
import Principal "mo:base/Principal";
import Advanced "../src/advanced_backend_backend/main";
import Types "../src/advanced_backend_backend/types";

actor {

    type CallManagementCanisterResult = Result.Result<Types.CanisterStatusResult, Text>;   
    
    func show(result : CallManagementCanisterResult) : Text {
        return debug_show(result);
    };
    
    func equal(result1 : CallManagementCanisterResult, result2 : CallManagementCanisterResult) : Bool {
        return result1 == result2;
    };
    
    public func runTests() : async () {
        
        Cycles.add<system>(1_000_000_000_000);
        
        let myCanister = await Advanced.Advanced();

        await suite("callManagementCanister", func() : async () {
            
            await test("should return #ok result", func() : async () {
                
                let result = await myCanister.callManagementCanister();
                expect.result(result, show, equal).isOk();

            });

            await test("should return a valid result", func() : async () {
                
                let result = await myCanister.callManagementCanister();
                switch (result) {
                    case (#ok(canisterStatus)) {
                        expect.array(canisterStatus.controllers, Principal.toText, Principal.equal).size(1);
                        expect.principal(canisterStatus.controllers[0]).notAnonymous();
                    };
                    case (#err(_)) {
                        assert false;
                    };
                };

            });

        });
        
    };

};