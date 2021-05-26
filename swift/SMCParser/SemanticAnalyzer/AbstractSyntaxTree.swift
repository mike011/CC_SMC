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
    case confictingSuperStates(extra: String)
}

struct State {
    var name: String
    var entryActions = [String]()
    var exitActions = [String]()
    var isAbstract = false
    var superStates = [State]()
    //var transitions = [SemanticTransition]()
}
