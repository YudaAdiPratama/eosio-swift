//
//  EosioAbiProviderTests.swift
//  EosioSwiftTests
//
//  Created by Todd Bowden on 2/25/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation
import XCTest
import EosioSwift

class EosioAbiProviderTests: XCTestCase {

    var rpcProvider: EosioRpcProviderProtocol!
    override func setUp() {
        super.setUp()
        let url = URL(string: "https://localhost")
        rpcProvider = RPCProviderMock(endpoint: url!)
    }
    func testGetAbi() {
        let abiProvider = EosioAbiProvider(rpcProvider: rpcProvider!)
        do {
            let eosioToken = try EosioName("vex.token")
            abiProvider.getAbi(chainId: "", account: eosioToken, completion: { (response) in
                switch response {
                case .success(let abi):
                    XCTAssertEqual(abi.sha256.hex, "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248")
                case .failure(let error):
                    print(error)
                    XCTFail("Failed to get Abi from provider")
                }
            })
        } catch {
            XCTFail("\(error)")
        }

    }

    func testGetAbis() {
        let abiProvider = EosioAbiProvider(rpcProvider: rpcProvider!)
        do {
            let eosioToken = try EosioName("vex.token")
            let eosio = try EosioName("vexcore")
            abiProvider.getAbis(chainId: "", accounts: [eosioToken, eosio, eosioToken], completion: { (response) in
                switch response {
                case .success(let abi):
                    XCTAssertEqual(abi[eosioToken]?.sha256.hex, "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248")
                    XCTAssertEqual(abi[eosio]?.sha256.hex, "d745bac0c38f95613e0c1c2da58e92de1e8e94d658d64a00293570cc251d1441")
                case .failure(let error):
                    print(error)
                    XCTFail("Failed to get Abi from provider")
                }
            })
        } catch {
            XCTFail("\(error)")
        }

    }

    func testGetAbisBadAccount() {
        let abiProvider = EosioAbiProvider(rpcProvider: rpcProvider!)
        do {
            let eosioToken = try EosioName("vex.token")
            let eosio = try EosioName("vexcore")
            let badAccount = try EosioName("bad.acount")
            abiProvider.getAbis(chainId: "", accounts: [badAccount, eosioToken, eosio], completion: { (response) in
                switch response {
                case .success:
                    XCTFail("getting Abi from provider succeeded despite being wrong")
                case .failure(let error):
                    print(error)
                }
            })
        } catch {
            XCTFail("\(error)")
        }

    }

    class AbiProviderMock: EosioAbiProviderProtocol {
        var getAbisCalled = false
        func getAbis(chainId: String, accounts: [EosioName], completion: @escaping (EosioResult<[EosioName: Data], EosioError>) -> Void) {
            getAbisCalled = true
        }
        var getAbiCalled = false
        func getAbi(chainId: String, account: EosioName, completion: @escaping (EosioResult<Data, EosioError>) -> Void) {
            getAbiCalled = true
        }
    }
}
