//
//  Transition.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-03-07.
//

struct Transition {
    var state: StateSpec
    var subtransitions = [Subtransition]()
}
