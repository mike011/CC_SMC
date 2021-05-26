//
//  OptimizierTests.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-05-16.
//

import XCTest

class OptimizierTests: XCTestCase {

    private var lexer: Lexer!
    private var parser: Parser!
    private var builder: SyntaxBuilder!
    private var analyzer: SemanticAnalyzer!
    private var optimizer: Optimizer!

    override func setUp() {
        builder = SyntaxBuilder()
        parser = Parser(builder: builder)
        lexer = Lexer(collector: parser)
        analyzer = SemanticAnalyzer()
        optimizer = Optimizer()
    }

    func produceStateMachineWithHeader(syntax: String) -> StateMachine {
        let fsmSyntax = "fsm:f initial:i actions:a " + syntax
        return produceStateMachine(syntax: fsmSyntax)
    }

    func produceStateMachine(syntax: String) -> StateMachine {
        //lexer.lex(
        return StateMachine()
    }

    func testHeader() throws {
        throw XCTSkip()
        let sm = produceStateMachineWithHeader(syntax: "{i e i -}")
        XCTAssertEqual(sm.header.fsm, "f")
        //assertThat(sm.header.fsm, equalTo("f"));
        //assertThat(sm.header.initial, equalTo("i"));
        //assertThat(sm.header.actions, equalTo("a"));
    }

}
