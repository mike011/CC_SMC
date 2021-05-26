//
//  MockTokenCollector.swift
//  
//
//  Created by Michael Charland on 2021-02-28.
//

class MockTokenCollector: TokenCollector {

    var tokens = ""
    var first = true

    fileprivate func add(token: String) {
        if first {
            first = false
        } else {
            tokens += ","
        }
        tokens += token
    }

    func openBrace(line: Int, position: Int) {
        add(token: "OB")
    }

    func closeBrace(line: Int, position: Int) {
        add(token: "CB")
    }

    func openParen(line: Int, position: Int) {
        add(token: "OP")
    }

    func closeParen(line: Int, position: Int) {
        add(token: "CP")
    }

    func openAngle(line: Int, position: Int) {
        add(token: "OA")
    }

    func closeAngle(line: Int, position: Int) {
        add(token: "CA")
    }

    func dash(line: Int, position: Int) {
        add(token: "D")
    }

    func colon(line: Int, position: Int) {
        add(token: "C")
    }

    func name(_ name: String, line: Int, position: Int) {
        add(token:  "#\(name)#")
    }

    func error(line: Int, position: Int) {
        add(token: "E\(line)/\(position)")
    }
}
