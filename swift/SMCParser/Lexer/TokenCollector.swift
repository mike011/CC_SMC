//
//  TokenCollector.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-02-28.
//

protocol TokenCollector {
    func openBrace(line: Int, position: Int)
    func closeBrace(line: Int, position: Int)

    func openParen(line: Int, position: Int)
    func closeParen(line: Int, position: Int)

    func openAngle(line: Int, position: Int)
    func closeAngle(line: Int, position: Int)

    func dash(line: Int, position: Int)
    func colon(line: Int, position: Int)

    mutating func name(_ name: String, line: Int, position: Int)
    func error(line: Int, position: Int)
}
