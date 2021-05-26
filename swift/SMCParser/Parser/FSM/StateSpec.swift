//
//  StateSpec.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-03-07.
//

import Foundation

struct StateSpec {
    let name: String
    var superStates = [String]()
    var entryActions = [String]()
    var exitActions = [String]()
    var isAbstractState: Bool
}
