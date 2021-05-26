//
//  ColumnTests.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-05-11.
//

@testable import SMCParser
import XCTest

class ColumnTests: XCTestCase {

    func testGetLongestStringLengthOneString() throws {

        let column = Column(title: "", values: ["a",])

        XCTAssertEqual(column.getLongestStringLength(), 1)
    }

    func testGetLongestStringLengthOneStringDifferentLength() throws {

        let column = Column(title: "", values: ["ab",])

        XCTAssertEqual(column.getLongestStringLength(), 2)
    }

    func testGetLongestStringLengthMultipleString() throws {

        let column = Column(title: "", values: ["ab","a"])

        XCTAssertEqual(column.getLongestStringLength(), 2)
    }

    func testGetLongestStringLengthTitleIsLonger() throws {

        let column = Column(title: "abc", values: ["ab","a"])

        XCTAssertEqual(column.getLongestStringLength(), 3)
    }

    func testGetRemainingSpaceOneString() {

        let column = Column(title: "", values: ["a",])

        XCTAssertEqual(column.getRemainingSpaces(atIndex: 0), 0)
    }

    func testGetRemainingSpaceManyStrings() {
        let column = Column(title: "", values: ["a","ab"])

        XCTAssertEqual(column.getRemainingSpaces(atIndex: 0), 1)
        XCTAssertEqual(column.getRemainingSpaces(atIndex: 1), 0)
    }

    func testGetRemainingSpaceTitleLonger() {

        let column = Column(title: "ab", values: ["a",])

        XCTAssertEqual(column.getRemainingSpacesForTitle(), 0)
    }

    func testGetRemainingSpaceTitleShorter() {

        let column = Column(title: "ab", values: ["abc",])

        XCTAssertEqual(column.getRemainingSpacesForTitle(), 1)
    }

}
