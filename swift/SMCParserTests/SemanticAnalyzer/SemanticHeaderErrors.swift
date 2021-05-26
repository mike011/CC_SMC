//
//  SemanticHeaderErrors.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-05-18.
//

import XCTest

class SemanticHeaderErrors: SemanticAnalyzerTests {

    func testNoHeaders() {
        let errors = produceAst(syntax: "{}").errors
        XCTAssertContains(errors, value: .noFSM)
        XCTAssertContains(errors, value: .noInitial)
    }

    func testMissingActions() {
        let errors = produceAst(syntax: "FSM:f Initial:i {}").errors
        XCTAssertFalse(errors.contains(.noFSM))
        XCTAssertFalse(errors.contains(.noInitial))
    }

    func testMissingFSM() {
        let errors = produceAst(syntax: "actions:a Initial:i {}").errors
        XCTAssertContains(errors, value: .noFSM)
        XCTAssertFalse(errors.contains(.noInitial))
    }

    func testMissingInitial() {
        let errors = produceAst(syntax: "Actions:a Fsm:f {}").errors
        XCTAssertFalse(errors.contains(.noFSM))
        XCTAssertContains(errors, value: .noInitial)
    }

    func testNothingMissing() {
        let errors = produceAst(syntax: "Initial: f Actions:a Fsm:f {}").errors
        XCTAssertFalse(errors.contains(.noFSM))
        XCTAssertFalse(errors.contains(.noInitial))
    }

    func testUnexpectedHeader() {
        let errors = produceAst(syntax: "X: x{s - - -}").errors
        XCTAssertContains(errors, value: .invalidHeader(Header(name: "X", value: "x")))
    }

    func testDuplicatedHeader() {
        let errors = produceAst(syntax: "fsm:f fsm:x{s - - -}").errors
        XCTAssertContains(errors, value: .extraHeaderIgnored)
    }

    func testInitialStateMustBeDefined() {
        let errors = produceAst(syntax: "initial: i {s - - -}").errors
        XCTAssertContains(errors, value: .undefinedState("initial: i"))
    }
}
