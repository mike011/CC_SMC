//
//  ErrorTests.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-05-14.
//

import XCTest

class ErrorTests: XCTestCase {

    func testParseNothing() throws {
        assert(input: "", is: "Syntax error: header. header|endOfFile. line -1, position -1.");
    }

    func testHeaderWithNoColonOrValue() throws {
        assert(input: "A {s e ns a}", is: "Syntax error: header. headerColon|openBrace. line 1, position 1.");
    }

    func testHeaderWithNoValue() throws {
        assert(input: "A: {s e ns a}", is: "Syntax error: header. headerValue|openBrace. line 1, position 2.");
    }

    func testTransitionWayTooShort() throws {
        assert(input: "{s}", is: "Syntax error: state. stateModifier|closedBrace. line 1, position 2.");
    }

    func testTransitionTooShort() throws {
        assert(input: "{s e}", is: "Syntax error: transition. singleEvent|closedBrace. line 1, position 2.");
    }

    func testTransitionNoAction() throws {
        assert(input: "{s e ns}", is: "Syntax error: transition. singleNextState|closedBrace. line 1, position 2.");
    }

    func testNoClosingBrace() throws {
        assert(input: "{", is: "Syntax error: state. stateSpec|endOfFile. line -1, position -1.");
    }

    func testInitialStateDash() throws {
        assert(input: "{- e ns a", is: "Syntax error: state. stateSpec|dash. line 1, position 2.");
    }

    func testLexicalError() throws {
        assert(input: "{.}", is: "Syntax error: syntax. . line 1, position 2.");
    }

}
