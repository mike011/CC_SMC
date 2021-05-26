//
//  Subtransition.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-03-07.
//

struct Subtransition {
    let event: String?
    var nextState: String?
    var actions = [String]()

    init(event: String?) {
        self.event = event
    }
}
