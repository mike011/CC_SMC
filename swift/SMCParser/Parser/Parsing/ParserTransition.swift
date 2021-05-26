//
//  ParserTransition.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-03-07.
//

struct ParserTransition: CustomStringConvertible {
    let currentState: ParserState
    let event: ParserEvent
    let newState: ParserState
    let action: (() -> ())?
    let actionDescription: BuilderDescription?

    var description: String {
        return getString(afterCurrentSpaces: 1, afterEventSpaces: 1, afterNextStateSpaces: 1)
    }

    func getString(afterCurrentSpaces: Int, afterEventSpaces: Int, afterNextStateSpaces: Int) -> String {
        var result = ""
        result += "Given State: \(currentState)\(get(spaces: afterCurrentSpaces))"
        result += "Event: \(event)\(get(spaces: afterEventSpaces))"
        result += "Next State: \(newState)\(get(spaces: afterNextStateSpaces))"
        result += getActionString()
        return result
    }

    func get(spaces: Int) -> String {
        return Array(repeating: " ", count: spaces).joined()
    }

    func getActionString() -> String {
        guard let actionDescription = actionDescription else {
            return ""
        }
        return "Action: \(actionDescription))"

    }
}



struct TransitionBuilder {

    var builder: Builder
    var transtions = [ParserTransition]()

    mutating func add(fromState: ParserState,
                      event: ParserEvent,
                      toState: ParserState,
                      action: BuilderDescription? = nil) {

        let transition = ParserTransition(currentState: fromState,
                                          event: event,
                                          newState: toState,
                                          action: action?.get(from: builder),
                                          actionDescription: action)
        transtions.append(transition)
    }

    static func get(usingBuilder builder: Builder) -> [ParserTransition] {

        var tb = TransitionBuilder(builder: builder)
        tb.add(fromState: .header, event: .name, toState: .headerColon, action: .newHeaderWithName)
        tb.add(fromState: .header, event: .openBrace, toState: .stateSpec)
        tb.add(fromState: .headerColon, event: .colon, toState: .headerValue)
        tb.add(fromState: .headerValue, event: .name, toState: .header, action: .addHeaderWithValue)
        tb.add(fromState: .stateSpec, event: .openParen, toState: .superStateName)
        tb.add(fromState: .stateSpec, event: .name, toState: .stateModifier, action: .setStateName)
        tb.add(fromState: .stateSpec, event: .closedBrace, toState: .end, action: .done)
        tb.add(fromState: .superStateName, event: .name, toState: .superStateClose, action: .setSuperStateName)
        tb.add(fromState: .superStateClose, event: .closedParen, toState: .stateModifier)
        tb.add(fromState: .stateModifier, event: .openAngle, toState: .entryAction)
        tb.add(fromState: .stateModifier, event: .closedAngle, toState: .exitAction)
        tb.add(fromState: .stateModifier, event: .colon, toState: .stateBase)
        tb.add(fromState: .stateModifier, event: .name, toState: .singleEvent, action: .setEvent)
        tb.add(fromState: .stateModifier, event: .dash, toState: .singleEvent, action: .setNilEvent)
        tb.add(fromState: .stateModifier, event: .openBrace, toState: .subtranstionGroup)
        tb.add(fromState: .entryAction, event: .name, toState: .stateModifier, action: .setEntryAction)
        tb.add(fromState: .entryAction, event: .openBrace, toState: .multipleEntryActions)
        tb.add(fromState: .multipleEntryActions, event: .name, toState: .multipleEntryActions, action: .setEntryAction)
        tb.add(fromState: .multipleEntryActions, event: .closedBrace, toState: .stateModifier)
        tb.add(fromState: .exitAction, event: .name, toState: .stateModifier, action: .setExitAction)
        tb.add(fromState: .exitAction, event: .openBrace, toState: .multipleExitActions)
        tb.add(fromState: .multipleExitActions, event: .name, toState: .multipleExitActions, action: .setExitAction)
        tb.add(fromState: .multipleExitActions, event: .closedBrace, toState: .stateModifier)
        tb.add(fromState: .stateBase, event: .name, toState: .stateModifier, action: .setStateBase)
        tb.add(fromState: .singleEvent, event: .name, toState: .singleNextState, action: .setNextState)
        tb.add(fromState: .singleEvent, event: .dash, toState: .singleNextState, action: .setNilNextState)
        tb.add(fromState: .singleNextState, event: .name, toState: .stateSpec, action: .transitionWithAction)
        tb.add(fromState: .singleNextState, event: .dash, toState: .stateSpec, action: .transitionNilAction)
        tb.add(fromState: .singleNextState, event: .openBrace, toState: .singleActionGroup)
        tb.add(fromState: .singleActionGroup, event: .name, toState: .singleActionGroupName, action: .addAction)
        tb.add(fromState: .singleActionGroup, event: .closedBrace, toState: .stateSpec, action: .transitionNilAction)
        tb.add(fromState: .singleActionGroupName, event: .name, toState: .singleActionGroupName, action: .addAction)
        tb.add(fromState: .singleActionGroupName, event: .closedBrace, toState: .stateSpec, action: .transitionWithActions)
        tb.add(fromState: .subtranstionGroup, event: .closedBrace, toState: .stateSpec)
        tb.add(fromState: .subtranstionGroup, event: .name, toState: .groupEvent, action: .setEvent)
        tb.add(fromState: .subtranstionGroup, event: .dash, toState: .groupEvent, action: .setNilEvent)
        tb.add(fromState: .groupEvent, event: .name, toState: .groupNextState, action: .setNextState)
        tb.add(fromState: .groupEvent, event: .dash, toState: .groupNextState, action: .setNilNextState)
        tb.add(fromState: .groupNextState, event: .name, toState: .subtranstionGroup, action: .transitionWithAction)
        tb.add(fromState: .groupNextState, event: .dash, toState: .subtranstionGroup, action: .transitionNilAction)
        tb.add(fromState: .groupNextState, event: .openBrace, toState: .groupActionGroup)
        tb.add(fromState: .groupActionGroup, event: .name, toState: .groupActionGroupName, action: .addAction)
        tb.add(fromState: .groupActionGroup, event: .closedBrace, toState: .subtranstionGroup, action: .transitionNilAction)
        tb.add(fromState: .groupActionGroupName, event: .name, toState: .groupActionGroupName, action: .addAction)
        tb.add(fromState: .groupActionGroupName, event: .closedBrace, toState: .subtranstionGroup, action: .transitionWithActions)
        tb.add(fromState: .end, event: .endOfFile, toState: .end)

        return tb.transtions
    }
}
