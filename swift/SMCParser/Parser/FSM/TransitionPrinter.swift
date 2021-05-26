//
//  TransitionPrinter.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-05-07.
//

import Foundation

struct TransitionPrinter {

    private var transitions: [ParserTransition]

    init(transitions: [ParserTransition]) {
        self.transitions = transitions
    }

    func getHistory() -> [String] {
        var lines = [String]()
        var printedNumber = 0

        for transition in transitions {
            var line = "#\(printedNumber) "
            if transitions.count > 10 {
                line += printedNumber > 9 ? "" : " "
            }
            let afterCurrentSpaces = getSpaces(afterGivenState: transition.currentState)
            let afterEventSpaces = getSpaces(afterEvent: transition.event)
            let afterNextStateSpaces = getSpaces(afterNextState: transition.newState)
            line += transition.getString(afterCurrentSpaces: afterCurrentSpaces,
                                         afterEventSpaces: afterEventSpaces,
                                         afterNextStateSpaces: afterNextStateSpaces)

            lines.append(line)
            printedNumber += 1
        }
        return lines
    }

    func getSpaces(afterGivenState state: ParserState) -> Int {
        return 1 + getLongestGivenStateLength() - state.count()
    }

    func getLongestGivenStateLength() -> Int {
        var mx = 0
        for t in transitions {
            mx = max(mx, t.currentState.count())
        }
        return mx
    }

    func getSpaces(afterEvent event: ParserEvent) -> Int {
        return 1 + getLongestAfterEventLength() - event.count()
    }

    func getLongestAfterEventLength() -> Int {
        var mx = 0
        for t in transitions {
            mx = max(mx, t.event.count())
        }
        return mx
    }

    func getSpaces(afterNextState state: ParserState) -> Int {
        return 1 + getLongestNextStateLength() - state.count()
    }

    func getLongestNextStateLength() -> Int {
        var mx = 0
        for t in transitions {
            mx = max(mx, t.newState.count())
        }
        return mx
    }

    func printHistory() {
        print()
        for line in getHistory() {
            print(line)
        }
        print()
    }
}
