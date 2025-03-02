import { test } "mo:test/async";
import Cycles "mo:base/ExperimentalCycles";
import Advanced "../src/advanced_backend_backend/main";

actor {
    // add cycles to deploy your canister
    Cycles.add<system>(1_000_000_000_000);

    // deploy your canister
    let myCanister = await Advanced.Advanced();
    
    public func runTests() : async () {
        
        await test("test name", func() : async () {
            let res = await myCanister.callManagementCanister();
            assert res == 123;
        });
        
    };

};