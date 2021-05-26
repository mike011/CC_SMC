//
//  SyntaxError.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-05-14.
//

struct SyntaxError: CustomStringConvertible {

    enum ErrorType {
        case header
        case state
        case transition
        case transitionGroup
        case end
        case syntax
    }

    let type: ErrorType
    let msg: String
    let lineNumber: Int
    let position: Int

    var description: String {
        return "\(type). \(msg). line \(lineNumber), position \(position)."
    }
}
