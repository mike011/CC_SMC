//
//  MultiTokenTests.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-02-28.
//

import XCTest

class MultiTokenTests: TokenTests {

    func testSimpleSequence() throws {
        assert(sequence: "{}", isTokens: "OB,CB")
    }

    func testComplexSequence() {
        assert(sequence: "FSM:fsm{this}", isTokens: "#FSM#,C,#fsm#,OB,#this#,CB")
    }

    func testSpacesInMiddle() throws {
        assert(sequence: "{         }", isTokens: "OB,CB")
    }

    func testNewLineInMiddle() throws {
        assert(sequence: "{\n}", isTokens: "OB,CB")
    }

    func testErrorAtDifferentPosition() throws {
        assert(sequence: "..", isTokens: "E1/1,E1/2")
    }

    func testAllTokens() {
        assert(sequence: "{}()<>-: name .", isTokens: "OB,CB,OP,CP,OA,CA,D,C,#name#,E1/15")
    }

    func testMultipleTokens() {
        assert(sequence: "FSM:fsm.\n{bob-.}", isTokens: "#FSM#,C,#fsm#,E1/8,OB,#bob#,D,E2/6,CB")
    }
}
