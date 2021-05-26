//
//  Builder.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-03-07.
//

/// A collection of methods that will be called by the parser’s Finite State Machine.
protocol Builder {
    func newHeaderWithName()
    func addHeaderWithValue()
    func setStateName()
    func done()
    func setSuperStateName()
    func setEvent()
    func setNilEvent()
    func setEntryAction()
    func setExitAction()
    func setStateBase()
    func setNextState()
    func setNilNextState()
    func transitionWithAction()
    func transitionNilAction()
    func addAction()
    func transitionWithActions()
    func headerError(state: ParserState, event: ParserEvent, line: Int, position: Int)
    func stateSpecError(state: ParserState, event: ParserEvent, line: Int, position: Int)
    func transitionError(state: ParserState, event: ParserEvent, line: Int, position: Int)
    func transitionGroupError(state: ParserState, event: ParserEvent, line: Int, position: Int)
    func endError(state: ParserState, event: ParserEvent, line: Int, position: Int)
    func syntaxError(line: Int, position: Int)
    func setName(name: String)
    func getFsm() -> FsmSyntax
}
