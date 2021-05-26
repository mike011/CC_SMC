//
//  ParserTests.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-03-07.
//

import SMCParser
import XCTest

extension XCTest {
    func assert(input: String, is expected: String, file: StaticString = #file, line: UInt = #line) {
        let builder = SyntaxBuilder()
        let parser = Parser(builder: builder)
        let lexer = Lexer(collector: parser)
        lexer.lex(input)
        parser.handle(event: .endOfFile, line: -1, position: -1)
        parser.printHistory()
        XCTAssertEqual("\n" + expected, "\n" + builder.getFsm().description, file: file, line: line)
    }
}

class ParserTests: XCTestCase {

    func testParseOneHeader() throws {
        let input = "Header:HeaderValue{}"
        let expected = """
        Header:HeaderValue
        .

        """
        assert(input: input, is: expected)
    }

    func testParseManyHeaders() {
        let input = "   N1  : V1\tN2 : V2\n{}"
        let expected = """
        N1:V1
        N2:V2
        .

        """
        assert(input: input, is: expected)
    }

    func testNoHeader() {
        let input = " {}"
        let expected = """
        .

        """
        assert(input: input, is: expected)
    }

    func testSimpleTransition() {
        let input = " {state event nextState action}"
        let expected = """
        {
          state event nextState action
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testTransitionWithNilAction() {
        let input = " {s e ns -}"
        let expected = """
        {
          s e ns {}
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testTransitionWithManyActions() {
        let input = " {s e ns {a1 a2}}"
        let expected = """
        {
          s e ns {a1 a2}
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testWithSubTransitions() {
        let input = " {s {e ns a}}"
        let expected = """
        {
          s e ns a
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testWithSeveralSubTransitions() {
        let input = " {s {e1 ns a1 e2 ns a2}}"
        let expected = """
        {
          s {
             e1 ns a1
             e2 ns a2
            }
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testManyTransitions() {
        let input = " {s1 e1 s2 a1 s2 e2 s3 a2}"
        let expected = """
        {
          s1 e1 s2 a1
          s2 e2 s3 a2
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testSuperState() {
        let input = " {(ss) e s a}"
        let expected = """
        {
          (ss) e s a
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testEntryAction() {
        let input = "{s <ea e ns a}"
        let expected = """
        {
          s <ea e ns a
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testExitAction() {
        let input = "{s >xa e ns a}"
        let expected = """
        {
          s >xa e ns a
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testDerivedState() {
        let input = "{s:ss e ns a}"
        let expected = """
        {
          s:ss e ns a
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testAllStateAdornments() {
        let input = "{(s)<ea>xa:ss e ns a}"
        let expected = """
        {
          (s):ss <ea >xa e ns a
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testStateWithNoSubTransitions() {
        let input = "{s {}}"
        let expected = """
        {
          s {
            }
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testStateWithAllDashes() {
        let input = "{s - - -}"
        let expected = """
        {
          s nil nil {}
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testMultipleSupperStates() {
        let input = "{s :x :y - - -}"
        let expected = """
        {
          s:x:y nil nil {}
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testMultipleEntryActions() {
        let input = "{s <x <y - - -}"
        let expected = """
        {
          s <x <y nil nil {}
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testMultipleExitActions() {
        let input = "{s >x >y - - -}"
        let expected = """
        {
          s >x >y nil nil {}
        }
        .

        """
        assert(input: input, is: expected)
    }

    func testMultipleEntryAndExitActionsWithBraces() {
        let input = "{s <{u v} >{w x} - - -}"
        let expected = """
        {
          s <u <v >w >x nil nil {}
        }
        .

        """
        assert(input: input, is: expected)
    }
}
