//
//  SemanticAnalyzer.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-05-16.
//

import Foundation

struct SemanticAnalyzer {

    private var ast: AbstractSyntaxTree!
    private var fsmHeader = Header.NilHeader()
    private var actionsHeader = Header()
    private var initialHeader = Header()

    mutating func analyze(_ fsm: FsmSyntax) -> AbstractSyntaxTree {
        ast = AbstractSyntaxTree()
        analyzeHeader(fsm)
        checkForErrorsAndWarnings(fsm)
        compile(fsm)
        return ast
    }

    private mutating func analyzeHeader(_ fsm: FsmSyntax) {
        setHeaders(fsm)
        checkMissingHeaders()
    }

    private mutating func setHeaders(_ fsm: FsmSyntax) {
        for header in fsm.headers {
            if isHeader(header, named: "fsm") {
                setFSMHeader(header: header)
            } else if isHeader(header, named: "initial") {
                setInitialHeader(header: header)
            } else {
                ast.errors.append(.invalidHeader(header))
            }
        }
    }

    private func isHeader(_ header: Header, named name: String) -> Bool {
        return header.name?.lowercased() == name.lowercased()
    }

    private mutating func setFSMHeader(header: Header) {
        if isNil(header: fsmHeader) {
            fsmHeader.name = header.name
            fsmHeader.value = header.value
        } else {
            ast.errors.append(.extraHeaderIgnored)
        }
    }

    private mutating func setInitialHeader(header: Header) {
        if isNil(header: initialHeader) {
            initialHeader.name = header.name
            initialHeader.value = header.value
        }
    }

    private mutating func checkMissingHeaders() {
        if isNil(header: fsmHeader) {
            ast.errors.append(.noFSM)
        }
        if isNil(header: initialHeader) {
            ast.errors.append(.noInitial)
        }
    }

    private func isNil(header: Header) -> Bool {
        return header.name == nil
    }

    private mutating func checkForErrorsAndWarnings(_ fsm: FsmSyntax) {
        createStateEventAndActionLists(fsm)
        checkUndefinedStates(fsm)
        checkForUnusedStates(fsm)
    }

    private mutating func createStateEventAndActionLists(_ fsm: FsmSyntax) {
        addStateNamesToStateList(fsm)
    }

    private mutating func addStateNamesToStateList(_ fsm: FsmSyntax) {
        for t in fsm.logic {
            let state = State(name: t.state.name)
            ast.states[state.name] = state
        }
    }

    private  mutating func checkUndefinedStates(_ fsm: FsmSyntax) {
        for t in fsm.logic {
            for superState in t.state.superStates {
                checkUndefinedState(superState, .undefinedSuperState(superState))
            }
            for st in t.subtransitions {
                if let nextState = st.nextState {
                    checkUndefinedState(nextState, .undefinedState(nextState))
                }
            }
        }
        if let initialValue = initialHeader.value {
            ast.errors.append(.undefinedState("initial: \(initialValue)"))
        }
    }

    private mutating func checkUndefinedState(_ referencedState: String, _ error: AnalysisError) {
        if !ast.states.keys.contains(referencedState) {
            ast.errors.append(error)
        }
    }

    private mutating func checkForUnusedStates(_ fsm: FsmSyntax) {
        findStatesDefinedButNotUsed(findUsedStates(fsm))
    }

    private func findUsedStates(_ fsm: FsmSyntax) -> Set<String> {
        var usedStates = Set<String>()
        if let initialHeaderValue = initialHeader.value {
            usedStates.insert(initialHeaderValue)
        }
        usedStates = usedStates.union(getNextSuperStates(fsm))
        usedStates = usedStates.union(getNextStates(fsm))

        return usedStates
    }

    private func getNextSuperStates(_ fsm: FsmSyntax) -> Set<String> {
        var superStates = Set<String>()
        for t in fsm.logic {
            for superState in t.state.superStates {
                superStates.insert(superState)
            }
        }
        return superStates
    }

    private func getNextStates(_ fsm: FsmSyntax) -> Set<String> {
        var nextStates = Set<String>()
        for t in fsm.logic {
            for st in t.subtransitions {
                if let nextState = st.nextState {
                    nextStates.insert(nextState)
                } else {
                    nextStates.insert(t.state.name)
                }
            }
        }
        return nextStates
    }

    private mutating func findStatesDefinedButNotUsed(_ usedStates: Set<String>) {
        for definedState in ast.states.keys {
            if !usedStates.contains(definedState) {
                ast.errors.append(.unusedState(definedState))
            }
        }

    }

    private func compile(_ fsm: FsmSyntax) {
        guard ast.errors.isEmpty else {
            return
        }
        compileHeaders()
        for t in fsm.logic {
            let state = compileState(t)
            compileTransitions(t, state)
        }

        var crawler = SuperClassCrawler()
        crawler.checkSuperClassTransitions()
    }

    private func compileHeaders() {

    }

    private func compileState(_ t: Transition) -> State {
        return State(name: "", isAbstract: false)
    }

    private func compileTransitions(_ t: Transition, _ state: State) {

    }
}

struct SuperClassCrawler {
    private var ast: AbstractSyntaxTree!
    private var concreteState: State?

    mutating func checkSuperClassTransitions() {
        for state in ast.states.values where !state.isAbstract {
            concreteState = state
            //transitionTuples =
            checkTransitionsForState(concreteState)
        }
    }

    private func checkTransitionsForState(_ state: State?) {
        guard let state = state else {
            return
        }
        for superState in state.superStates {
            checkTransitionsForState(superState)
        }
        checkStateForPreviouslyDefinedTransition(state)
    }


    private func checkStateForPreviouslyDefinedTransition(_ state: State) {

    }
}
