//
//  Parser.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-03-07.
//

/**
 @code
 <FSM> ::= <header>* <logic>
 <header> ::= "Actions:" <name> | "FSM:" <name> | "Initial:" <name>

 <logic> ::= "{" <transition>* "}"

 <transition> ::= <state-spec> <subtransition>
 |   <state-spec> "{" <subtransition>* "}"

 <subtransition>   ::= <event-spec> <next-state> <action-spec>
 <action-spec>     ::= <action> | "{" <action>* "}" | "-"
 <state-spec>      ::= <state> <state-modifiers>
 <state-modifiers> ::= "" | <state-modifier> | <state-modifier> <state-modifiers>
 <state-modifier>  ::= ":" <state>
 |   "<" <action-spec>
 |   ">" <action-spec>

 <next-state> ::= <state> | "-"
 <event-spec> :: <event> | "-"
 <action> ::= <name>
 <state> ::= <name>
 <event> ::= <name>
 @endcode
 */


/// The parser accepts the stream of tokens and converts it into a syntax data structure.
class Parser {

    private var state = ParserState.header
    private var builder: Builder
    private let transitions: [ParserTransition]
    private var transitionHistory = [ParserTransition]()

    init(builder: Builder) {
        self.builder = builder
        self.transitions = TransitionBuilder.get(usingBuilder: builder)
    }

    func handle(event: ParserEvent, line: Int, position: Int) {
        for t in transitions {
            if handle(transition: t, forEvent: event) {
                return
            }
        }
        handleEventError(event: event, line: line, pos: position)
    }

    private func handle(transition: ParserTransition, forEvent event: ParserEvent) -> Bool {
        if transition.currentState == state && transition.event == event {
            state = transition.newState
            if let action = transition.action {
                transitionHistory.append(transition)
                action()
            }
            return true
        }
        return false
    }

    private func handleEventError(event: ParserEvent, line: Int, pos: Int) {
        switch state {
        case .header:
            fallthrough
        case .headerColon:
            fallthrough
        case .headerValue:
            builder.headerError(state: state, event: event, line: line, position: pos)

        case .stateSpec:
            fallthrough
        case .superStateName:
            fallthrough
        case .superStateClose:
            fallthrough
        case .stateModifier:
            fallthrough
        case .exitAction:
            fallthrough
        case .entryAction:
            fallthrough
        case .stateBase:
            builder.stateSpecError(state: state, event: event, line: line, position: pos)

        case .singleEvent:
            fallthrough
        case .singleNextState:
            fallthrough
        case .singleActionGroup:
            fallthrough
        case .singleActionGroupName:
            builder.transitionError(state: state, event: event, line: line, position: pos)

        case .subtranstionGroup:
            fallthrough
        case .groupEvent:
            fallthrough
        case .groupNextState:
            fallthrough
        case .groupActionGroup:
            fallthrough
        case .groupActionGroupName:
            builder.transitionGroupError(state: state, event: event, line: line, position: pos)

        case .end:
            builder.endError(state: state, event: event, line: line, position: pos)

        default:
            return
        }
    }

    func printHistory() {
        TransitionPrinter(transitions: transitionHistory).printHistory()
    }
}


extension Parser: TokenCollector {

    func openBrace(line: Int, position: Int) {
        handle(event: .openBrace, line: line, position: position)
    }

    func closeBrace(line: Int, position: Int) {
        handle(event: .closedBrace, line: line, position: position)
    }

    func openParen(line: Int, position: Int) {
        handle(event: .openParen, line: line, position: position)
    }

    func closeParen(line: Int, position: Int) {
        handle(event: .closedParen, line: line, position: position)
    }

    func openAngle(line: Int, position: Int) {
        handle(event: .openAngle, line: line, position: position)
    }

    func closeAngle(line: Int, position: Int) {
        handle(event: .closedAngle, line: line, position: position)
    }

    func dash(line: Int, position: Int) {
        handle(event: .dash, line: line, position: position)
    }

    func colon(line: Int, position: Int) {
        handle(event: .colon, line: line, position: position)
    }

    func name(_ name: String, line: Int, position: Int) {
        builder.setName(name: name)
        handle(event: .name, line: line, position: position)
    }

    func error(line: Int, position: Int) {
        builder.syntaxError(line: line, position: position)
    }
}
