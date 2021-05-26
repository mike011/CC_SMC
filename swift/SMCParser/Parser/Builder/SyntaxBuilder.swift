//
//  SyntaxBuilder.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-03-07.
//

class SyntaxBuilder: Builder {

    private var fsm: FsmSyntax
    private var header: Header?
    private var parsedName: String
    private var transition: Transition!
    private var subtransition: Subtransition!

    init() {
        fsm = FsmSyntax()
        parsedName = ""
    }

    func newHeaderWithName() {
        header = Header()
        header?.name = parsedName
    }

    func addHeaderWithValue() {
        if var header = header {
            header.value = parsedName
            fsm.headers.append(header)
        }
    }

    func setStateName() {
        let spec = StateSpec(name: parsedName, isAbstractState: false)
        if transition != nil {
            fsm.logic.append(transition)
        }
        transition = Transition(state: spec)
    }

    func done() {
        if transition != nil {
            fsm.logic.append(transition)
        }
        fsm.done = true
    }

    func setSuperStateName() {
        setStateName()
        transition.state.isAbstractState = true
    }

    func setEvent() {
        subtransition = Subtransition(event: parsedName)
    }

    func setNilEvent() {
        subtransition = Subtransition(event: nil)
    }

    func setEntryAction() {
        transition.state.entryActions.append(parsedName)
    }

    func setExitAction() {
        transition.state.exitActions.append(parsedName)
    }

    func setStateBase() {
        transition.state.superStates.append(parsedName)
    }

    func setNextState() {
        subtransition?.nextState = parsedName
    }

    func setNilNextState() {
    }

    func transitionWithAction() {
        subtransition?.actions.append(parsedName)
        transition?.subtransitions.append(subtransition)
    }

    func transitionNilAction() {
        transition?.subtransitions.append(subtransition)
    }

    func addAction() {
        subtransition.actions.append(parsedName)
    }

    func transitionWithActions() {
        transition.subtransitions.append(subtransition)
    }

    func headerError(state: ParserState, event: ParserEvent, line: Int, position: Int) {
        fsm.errors.append(SyntaxError(type: .header, msg: "\(state)|\(event)", lineNumber: line, position: position))
    }

    func stateSpecError(state: ParserState, event: ParserEvent, line: Int, position: Int) {
        fsm.errors.append(SyntaxError(type: .state, msg: "\(state)|\(event)", lineNumber: line, position: position))
    }

    func transitionError(state: ParserState, event: ParserEvent, line: Int, position: Int) {
        fsm.errors.append(SyntaxError(type: .transition, msg: "\(state)|\(event)", lineNumber: line, position: position))
    }

    func transitionGroupError(state: ParserState, event: ParserEvent, line: Int, position: Int) {
        fsm.errors.append(SyntaxError(type: .transitionGroup, msg: "\(state)|\(event)", lineNumber: line, position: position))
    }

    func endError(state: ParserState, event: ParserEvent, line: Int, position: Int) {
        fsm.errors.append(SyntaxError(type: .end, msg: "\(state)|\(event)", lineNumber: line, position: position))
    }

    func syntaxError(line: Int, position: Int) {
        fsm.errors.append(SyntaxError(type: .syntax, msg: "", lineNumber: line, position: position))
    }

    func setName(name: String) {
        parsedName = name
    }

    func getFsm() -> FsmSyntax {
        return fsm
    }
}
