//
//  FsmSyntqax.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-03-07.
//

class FsmSyntax: CustomStringConvertible {

    var headers = [Header]()
    var logic = [Transition]()
    var errors = [SyntaxError]();
    var done = false

    var description: String {
        let errors = formatErrors()
        guard errors.isEmpty else {
            return errors
        }

        return formatHeaders() +
            formatLogic() +
            (done ? ".\n" : "")
    }

    func formatHeaders() -> String {
        var result = ""
        for header in headers {
            result += format(header: header)
        }
        return result
    }

    func format(header: Header) -> String {
        guard let name = header.name, let value = header.value else {
            return "nil:nil\n"
        }
        return "\(name):\(value)\n"
    }

    func formatLogic() -> String {
        if logic.isEmpty {
            return ""
        }
        return "{\n\(formatTransitions())}\n"
    }

    func formatTransitions() -> String {
        var result = ""
        for t in logic {
            result += format(transition: t) + "\n"
        }
        return result
    }

    fileprivate func format(transition: Transition) -> String {
        var result = "  " + format(stateSpec: transition.state)
        result += " " + formatSubstransitions(transition: transition)
        return result
    }

    fileprivate func format(stateSpec: StateSpec) -> String {
        let name = stateSpec.name
        var stateName = stateSpec.isAbstractState ? "(\(name))" : name
        for superState in stateSpec.superStates {
            stateName += ":" + superState
        }
        for entryAction in stateSpec.entryActions {
            stateName += " <" + entryAction
        }
        for exitAction in stateSpec.exitActions {
            stateName += " >" + exitAction
        }
        return stateName
    }

    fileprivate func formatSubstransitions(transition: Transition) -> String {
        if transition.subtransitions.count == 1 {
            return format(subtransition: transition.subtransitions[0])
        } else {
            var result = "{\n"
            for sub in transition.subtransitions {
                result += "     " + format(subtransition: sub) + "\n"
            }
            return result + "    }"
        }
    }

    fileprivate func format(subtransition sub: Subtransition) -> String {
        var result = formatNextState(subtransition: sub)
        result += " " + formatActions(subtransition: sub)
        return result
    }

    fileprivate func formatNextState(subtransition sub: Subtransition) -> String {

        var nextStateName = "nil"
        if let e = sub.nextState {
            nextStateName = e
        }

        var eventName = "nil"
        if let e = sub.event {
            eventName = e
        }
        return "\(eventName) \(nextStateName)"
    }

    fileprivate func formatActions(subtransition sub: Subtransition) -> String {
        if sub.actions.count == 1 {
            return sub.actions[0]
        } else {
            var actions = "{"
            var first = true
            for action in sub.actions {
                actions += (first ? "" : " ") + action
                first = false
            }
            return actions + "}"
        }
    }

    func formatErrors() -> String {
        if !errors.isEmpty {
            return formatError(atIndex: 0)
        }
        return ""
    }

    func formatError(atIndex index: Int) -> String {
        return "Syntax error: \(errors[index])"
    }
}
