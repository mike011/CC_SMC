//
//  XCTestCase+Extension.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-05-19.
//

import XCTest

extension XCTestCase {
    func XCTAssertContains<T: Equatable>(_ collection: [T],
                                         value: T,
                                         file: StaticString = #file,
                                         line: UInt = #line) {

        if collection.contains(value) {
            return
        }
        XCTFail("Collection \(collection) does not contain \(value)", file: file, line: line)
    }

    func XCTAssertNotContains<T: Equatable>(_ collection: [T],
                                            value: T,
                                            file: StaticString = #file,
                                            line: UInt = #line) {

        if !collection.contains(value) {
            return
        }
        XCTFail("Collection \(collection) does contain \(value)", file: file, line: line)
    }
}
