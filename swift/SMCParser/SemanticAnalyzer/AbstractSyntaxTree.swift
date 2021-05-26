//
//  AbstractSyntaxTree.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-05-16.
//

import Foundation

struct AbstractSyntaxTree {
    var states = [String: State]()
    var errors = [AnalysisError]()
}

enum AnalysisError: Equatable {
    case noFSM
    case noInitial
    case extraHeaderIgnored
    case invalidHeader(Header)
    case undefinedState(String)
    case undefinedSuperState(String)
    case unusedState(String)
    case conflictingSuperStates(extra: String)
}

struct State: Equatable {

    var name: String
    var entryActions = [String]()
    var exitActions = [String]()
    var isAbstract = false
    var superStates = [State]()
    var transitions = [SemanticTransition]()

    static func == (lhs: State, rhs: State) -> Bool {
        return lhs.name == rhs.name
    }
}

struct SemanticTransition {
    var event: String
    var nextState: State
    var actions = [String]()
}
