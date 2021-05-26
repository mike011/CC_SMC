//
//  ParserEvent.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-03-07.
//

enum ParserEvent {
    case name
    case openBrace
    case closedBrace
    case openParen
    case closedParen
    case openAngle
    case closedAngle
    case dash
    case endOfFile
    case colon
}

extension ParserEvent {
    func count() -> Int {
        return "\(self)".count
    }
}
