//
//  ParserState.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-03-07.
//

import Foundation

enum ParserState {
    case header
    case headerColon
    case headerValue
    case stateSpec
    case superStateName
    case superStateClose
    case stateModifier
    case exitAction
    case entryAction
    case stateBase
    case singleEvent
    case singleNextState
    case singleActionGroup
    case singleActionGroupName
    case subtranstionGroup
    case groupEvent
    case groupNextState
    case groupActionGroup
    case groupActionGroupName
    case multipleEntryActions
    case multipleExitActions
    case end
}

extension ParserState {
    func count() -> Int {
        return "\(self)".count
    }
}
