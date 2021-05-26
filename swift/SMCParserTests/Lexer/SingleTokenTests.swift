//
//  SingleTokenTests.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-02-27.
//

import XCTest

class SingleTokenTests: TokenTests {

    func testFindOpenBrace() throws {
        assert(sequence: "{", isTokens: "OB")
    }

    func testFindClosedBrace() throws {
        assert(sequence: "}", isTokens: "CB")
    }

    func testFindOpenParen() throws {
        assert(sequence: "(", isTokens: "OP")
    }

    func testFindClosedParen() throws {
        assert(sequence: ")", isTokens: "CP")
    }

    func testFindOpenAngle() throws {
        assert(sequence: "<", isTokens: "OA")
    }

    func testFindClosedAngle() throws {
        assert(sequence: ">", isTokens: "CA")
    }

    func testFindDash() throws {
        assert(sequence: "-", isTokens: "D")
    }

    func testFindColon() throws {
        assert(sequence: ":", isTokens: "C")
    }

    func testSimpleName() throws {
        assert(sequence: "name", isTokens: "#name#")
    }

    func testComplexName() throws {
        assert(sequence: "Room_222", isTokens: "#Room_222#")
    }

    func testError() {
        assert(sequence: ".", isTokens: "E1/1")
    }

    func testNothingButWhiteSpace() {
        assert(sequence: " ", isTokens: "")
    }

    func testNothingButTab() {
        assert(sequence: "\t", isTokens: "")
    }

    func testNothingButNewLine() {
        assert(sequence: "\n", isTokens: "")
    }

    func testWhiteSpaceBefore() {
        assert(sequence: "  \t\n  -", isTokens: "D")
    }
}
