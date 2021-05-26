//
//  TransitionParserTests.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-05-07.
//

import XCTest

class TransitionParserTests: XCTestCase {

    func testOneTransition() throws {

        var transitions = [ParserTransition]()
        transitions.append(ParserTransition(currentState: .header,
                                            event: .colon,
                                            newState: .entryAction,
                                            action: nil,
                                            actionDescription: .addAction))
        let tp = TransitionPrinter(transitions: transitions)

        let history = tp.getHistory()
        XCTAssertTrue(history[0].starts(with: "#0 Given State:"), "String is " + history[0])
//        XCTAssertEqual(history[0], "#0 Given State: header Event: colon Next State: entryAction Action: addAction")
    }

    func testMoreThen10Transition() throws {

        var transitions = [ParserTransition]()
        let transition = ParserTransition(currentState: .header,
                                          event: .colon,
                                          newState: .entryAction,
                                          action: nil,
                                          actionDescription: .addAction)

        for _ in 0..<15 {
            transitions.append(transition)
        }
        let tp = TransitionPrinter(transitions: transitions)

        let history = tp.getHistory()
        XCTAssertTrue(history[0].starts(with: "#0  Given State:"), history[0])
        XCTAssertTrue(history[10].starts(with: "#10 Given State:"), history[10])
    }

    func testGetLongestGivenStateLength() throws {
        var transitions = [ParserTransition]()
        transitions.append(ParserTransition(currentState: .end,
                                            event: .colon,
                                            newState: .entryAction,
                                            action: nil,
                                            actionDescription: .addAction))
        transitions.append(ParserTransition(currentState: .groupActionGroupName,
                                            event: .colon,
                                            newState: .entryAction,
                                            action: nil,
                                            actionDescription: .addAction))
        let tp = TransitionPrinter(transitions: transitions)

        XCTAssertEqual(20, tp.getLongestGivenStateLength())
    }

    func testGetSpacerAfterGivenState() throws {
        var transitions = [ParserTransition]()
        transitions.append(ParserTransition(currentState: .end,
                                            event: .colon,
                                            newState: .entryAction,
                                            action: nil,
                                            actionDescription: .addAction))
        transitions.append(ParserTransition(currentState: .groupActionGroupName,
                                            event: .colon,
                                            newState: .entryAction,
                                            action: nil,
                                            actionDescription: .addAction))
        let tp = TransitionPrinter(transitions: transitions)

        XCTAssertEqual(1, tp.getSpaces(afterGivenState: .groupActionGroupName))
        XCTAssertEqual(18, tp.getSpaces(afterGivenState: .end))
    }

    func testGetSpacerAfterEvent() throws {
        var transitions = [ParserTransition]()
        transitions.append(ParserTransition(currentState: .end,
                                            event: .colon,
                                            newState: .entryAction,
                                            action: nil,
                                            actionDescription: .addAction))
        transitions.append(ParserTransition(currentState: .groupActionGroupName,
                                            event: .colon,
                                            newState: .entryAction,
                                            action: nil,
                                            actionDescription: .addAction))
        let tp = TransitionPrinter(transitions: transitions)

        XCTAssertEqual(1, tp.getSpaces(afterGivenState: .groupActionGroupName))
        XCTAssertEqual(18, tp.getSpaces(afterGivenState: .end))
    }
}
