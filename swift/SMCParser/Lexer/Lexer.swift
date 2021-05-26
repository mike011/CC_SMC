//
//  Lexer.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-02-27.
//

import Foundation

/// Performs Lexical Analysis which translates the stream of characters into a stream of lexical tokens.
class Lexer {

    private var collector: TokenCollector
    private var currentIndex: String.Index!
    private var line = 1
    private var position = 1

    init(collector: TokenCollector) {
        self.collector = collector
    }

    /// - Parameter input: The string you want to parse into tokens.
    func lex(_ input: String) {
        for inputLine in input.split(separator: "\n") {
            lexLine(String(inputLine))
            line += 1
        }
    }

    private func lexLine(_ input: String) {
        currentIndex = input.startIndex

        var found = true
        while(currentIndex < input.endIndex) {
            found = findWhiteSpace(input) || singleCharacterToken(input) || findName(input)
            if !found {
                position = input.distance(from: input.startIndex, to: currentIndex) + 1
                collector.error(line: line, position: position)
                currentIndex = input.index(after: currentIndex)
            }
        }
    }


    private func findWhiteSpace(_ input: String) -> Bool {
        var test = input
        test.removeSubrange(..<currentIndex)

        if let words = matches(for: "^\\s+", in: test), !words.isEmpty {
            currentIndex = input.index(currentIndex, offsetBy: words[0].count)
            return true
        }
        return false

    }

    private func findName(_ input: String) -> Bool {
        var test = input
        test.removeSubrange(..<currentIndex)

        if let words = matches(for: "^\\w+", in: test), !words.isEmpty {
            collector.name(words[0], line: line, position: position)
            currentIndex = input.index(currentIndex, offsetBy: words[0].count)
            return true
        }
        return false
    }

    private func matches(for regex: String, in text: String) -> [String]? {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return nil
        }
    }

    private func singleCharacterToken(_ input: String) -> Bool {
        let next = input.index(after: currentIndex)
        let test = input[currentIndex..<next]
        switch test {
        case "{":
            collector.openBrace(line: line, position: position)
        case "}":
            collector.closeBrace(line: line, position: position)
        case "(":
            collector.openParen(line: line, position: position)
        case ")":
            collector.closeParen(line: line, position: position)
        case "<":
            collector.openAngle(line: line, position: position)
        case ">":
            collector.closeAngle(line: line, position: position)
        case "-":
            collector.dash(line: line, position: position)
        case ":":
            collector.colon(line: line, position: position)
        default:
            return false
        }
        currentIndex = input.index(after: currentIndex)
        position += 1
        return true
    }
}
