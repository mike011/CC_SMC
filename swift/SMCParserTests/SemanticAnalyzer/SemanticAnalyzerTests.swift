//
//  SemanticAnalyzerTests.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-05-17.
//

import XCTest

class SemanticAnalyzerTests: XCTestCase {

    private var lexer: Lexer!
    private var parser: Parser!
    private var builder: Builder!
    private var analyzer: SemanticAnalyzer!

    override func setUp() {
        builder = SyntaxBuilder()
        parser = Parser(builder: builder)
        lexer = Lexer(collector: parser)
        analyzer = SemanticAnalyzer()
    }

    func produceAst(syntax: String) -> AbstractSyntaxTree {
        lexer.lex(syntax)
        parser.handle(event: .endOfFile, line: -1, position: -1)
        parser.printHistory()
        return analyzer.analyze(builder.getFsm())
    }
}

class SemanticStateErrors: SemanticAnalyzerTests {

    func testNilNextStateIsNotDefined() {
        let errors = produceAst(syntax: "{s - - -}").errors
        XCTAssertNotContains(errors, value: .undefinedState(""))
    }

    func testUndefinedState() {
        let errors = produceAst(syntax: "{s - s2 -}").errors
        XCTAssertContains(errors, value: .undefinedState("s2"))
    }

    func testNoUndefinedState() {
        let errors = produceAst(syntax: "{s - s -}").errors
        XCTAssertNotContains(errors, value: .undefinedState("s"))
    }

    func testUndefinedSuperState() {
        let errors = produceAst(syntax: "{s:ss - - -}").errors
        XCTAssertContains(errors, value: .undefinedSuperState("ss"))
    }

    func testSuperStateDefined() {
        let errors = produceAst(syntax: "{ss - - - s:ss - - -}").errors
        XCTAssertNotContains(errors, value: .undefinedSuperState("ss"))
    }

    func testUnusedStates() {
        let errors = produceAst(syntax: "{s e n -}").errors
        XCTAssertContains(errors, value: .unusedState("s"))
    }

    func testNoUnusedStates() {
        let errors = produceAst(syntax: "{s e s -}").errors
        XCTAssertNotContains(errors, value: .unusedState("s"))
    }

    func testNextStateNilIsImplicitUse() {
        let errors = produceAst(syntax: "{s e - -}").errors
        XCTAssertNotContains(errors, value: .unusedState("s"))
    }

    func testUsedAsBaseIsValidUsage() {
        let errors = produceAst(syntax: "{b e n - s:b e2 s -}").errors
        XCTAssertNotContains(errors, value: .unusedState("b"))
    }

    func testUsedAsInitialIsValidUsage() {
        let errors = produceAst(syntax: "initial: b {b e n -}").errors
        XCTAssertNotContains(errors, value: .unusedState("b"))
    }

    func testErrorIfSuperStatesHaveConflictingTransitions() {
        let syntax = """
        FSM: f Actions: act Initial: s
        {
          (ss1) e1 s1 -
          (ss2) e1 s2 -
          s :ss1 :ss2 e2 s3 a
          s2 e s -
          s1 e s -
          s3 e s -
        }
        """
        let errors = produceAst(syntax: syntax).errors
        XCTAssertContains(errors, value: .confictingSuperStates(extra: "s|e1"))
    }
}

