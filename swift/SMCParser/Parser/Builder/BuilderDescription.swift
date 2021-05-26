//
//  BuilderDescription.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-05-04.
//

import Foundation

enum BuilderDescription {
    case newHeaderWithName
    case addHeaderWithValue
    case setStateName
    case done
    case setSuperStateName
    case setEvent
    case setNilEvent
    case setEntryAction
    case setExitAction
    case setStateBase
    case setNextState
    case setNilNextState
    case transitionWithAction
    case transitionNilAction
    case addAction
    case transitionWithActions
    case none
}

extension BuilderDescription {
    func get(from builder: Builder) -> (() -> ())? {
        switch self {
        case .newHeaderWithName:
            return builder.newHeaderWithName
        case .addHeaderWithValue:
            return builder.addHeaderWithValue
        case .setStateName:
            return builder.setStateName
        case .done:
            return builder.done
        case .setSuperStateName:
            return builder.setSuperStateName
        case .setEvent:
            return builder.setEvent
        case .setNilEvent:
            return builder.setNilEvent
        case .setEntryAction:
            return builder.setEntryAction
        case .setExitAction:
            return builder.setExitAction
        case .setStateBase:
            return builder.setStateBase
        case .setNextState:
            return builder.setNextState
        case .setNilNextState:
            return builder.setNilNextState
        case .transitionWithAction:
            return builder.transitionWithAction
        case .transitionNilAction:
            return builder.transitionNilAction
        case .addAction:
            return builder.addAction
        case .transitionWithActions:
            return builder.transitionWithActions
        default:
            return nil
        }
    }
}
