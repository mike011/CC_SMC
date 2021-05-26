//
//  Header.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-03-07.
//

struct Header: Equatable {
    var name: String?
    var value: String?

    public static func NilHeader() -> Header {
        return Header()
    }
}
