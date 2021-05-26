//
//  AcceptanceTests.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-05-13.
//

import SMCParser
import XCTest

extension XCTest {

    func assertNoSpaces(input: String, is expected: String, file: StaticString = #file, line: UInt = #line) {
        let builder = SyntaxBuilder()
        let parser = Parser(builder: builder)
        let lexer = Lexer(collector: parser)
        lexer.lex(input)
        parser.handle(event: .endOfFile, line: -1, position: -1)
        parser.printHistory()

        XCTAssertEqual("\n" + expected.noSpaces(), "\n" + builder.getFsm().description.noSpaces(), file: file, line: line)
    }
}

private extension String {
    func noSpaces() -> String {
        return self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "/t", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
}

class AcceptanceTests: XCTestCase {

    func testParseOneHeader() throws {
        let input = """
        Actions: Turnstile
        FSM: OneCoinTurnstile
        Initial: Locked
        {
          Locked    Coin    Unlocked    {alarmOff unlock}
          Locked    Pass    Locked      alarmOn
          Unlocked  Coin    Unlocked    thankyou
          Unlocked  Pass    Locked      lock
        }
        """

        let expected = """
        Actions:Turnstile
        FSM:OneCoinTurnstile
        Initial:Locked
        {
          Locked Coin Unlocked {alarmOff unlock}
          Locked Pass Locked alarmOn
          Unlocked Coin Unlocked thankyou
          Unlocked Pass Locked lock
        }
        .

        """
        assertNoSpaces(input: input, is: expected)
    }

    func testTwoCoinTurnstileWithoutSuperState() throws {
        let input = """
        Actions: Turnstile
        FSM: TwoCoinTurnstile
        Initial: Locked
        {
            Locked {
                Pass   Alarming   alarmOn
                Coin   FirstCoin   -
                Reset   Locked   {lock alarmOff}
            }

            Alarming   Reset   Locked {lock alarmOff}

             FirstCoin {
                Pass   Alarming   -
                Coin   Unlocked   unlock
                Reset   Locked {lock alarmOff}
             }

             Unlocked {
                Pass   Locked   lock
                Coin   -      thankyou
                Reset   Locked {lock alarmOff}
             }
          }
        """

        let expected = """
        Actions:Turnstile
        FSM:TwoCoinTurnstile
        Initial:Locked
        {
            Locked {
                Pass Alarming alarmOn
                Coin FirstCoin {}
                Reset Locked {lock alarmOff}
            }
            Alarming Reset Locked {lock alarmOff}
            FirstCoin {
                Pass Alarming {}
                Coin Unlocked unlock
                Reset Locked {lock alarmOff}
            }
            Unlocked {
                Pass Locked lock
                Coin nil thankyou
                Reset Locked {lock alarmOff}
            }
        }
        .

        """
        assertNoSpaces(input: input, is: expected)
    }

    func testTwoCoinTurnstileWithSuperState() throws {
        let input = """
        Actions: Turnstile
        FSM: TwoCoinTurnstile
        Initial: Locked
        {
            (Base)  Reset  Locked  lock

          Locked : Base {
            Pass  Alarming  -
            Coin  FirstCoin  -
          }

          Alarming : Base  <alarmOn >alarmOff -  -  -

          FirstCoin : Base {
            Pass  Alarming  -
            Coin  Unlocked  unlock
          }

          Unlocked : Base {
            Pass  Locked  lock
            Coin  -    thankyou
          }
        }
        """

        let expected = """
        Actions:Turnstile
        FSM:TwoCoinTurnstile
        Initial:Locked
        {
          (Base) Reset Locked lock
          Locked:Base {
            Pass Alarming {}
            Coin FirstCoin {}
          }
          Alarming:Base <alarmOn >alarmOff nil nil {}
          FirstCoin:Base {
            Pass Alarming {}
            Coin Unlocked unlock
          }
          Unlocked:Base {
            Pass Locked lock
            Coin nil thankyou
          }
        }
        .
        """
        assertNoSpaces(input: input, is: expected)
    }
}
