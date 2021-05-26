//
//  TokenTests.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-02-28.
//

import XCTest

class TokenTests: XCTestCase {
    var lexer: Lexer!
    var collector: MockTokenCollector!

    override func setUp() {
        super.setUp()
        collector = MockTokenCollector()
        lexer = Lexer(collector: collector)
    }

    func assert(sequence: String, isTokens token: String, file: StaticString = #filePath, line: UInt = #line) {
        lexer.lex(sequence)
        XCTAssertEqual(collector.tokens, token, file: file, line: line)
    }
}
