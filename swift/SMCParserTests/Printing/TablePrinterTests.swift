//
//  TablePrinterTests.swift
//  SMCParserTests
//
//  Created by Michael Charland on 2021-05-10.
//

import SMCParser
import XCTest

class TablePrinterTests: XCTestCase {

    func testTitleRow() throws {
        var table = TablePrinter()
        table.addColumn(title: "A", values: [""])
        table.addColumn(title: "B", values: [""])

        let rows = table.getRows()
        XCTAssertEqual(rows.count, 2)
        XCTAssertEqual(rows[0], "A B ")
    }

    func testOneColumnTable() throws {
        var table = TablePrinter()
        table.addColumn(title: "#", values: ["0"])

        let rows = table.getRows()
        XCTAssertEqual(rows.count, 2)
        XCTAssertEqual(rows[0], "# ")
        XCTAssertEqual(rows[1], "0 ")
    }

    func testOneColumnTableWithLongerValue() throws {
        var table = TablePrinter()
        table.addColumn(title: "title", values: ["0"])

        let rows = table.getRows()
        XCTAssertEqual(rows.count, 2)
        XCTAssertEqual(rows[0], "title ")
        XCTAssertEqual(rows[1], "0     ")
    }

    func testOneColumnValueWithLongerValue() throws {
        var table = TablePrinter()
        table.addColumn(title: "T", values: ["01234"])

        let rows = table.getRows()
        XCTAssertEqual(rows.count, 2)
        XCTAssertEqual(rows[0], "T     ")
        XCTAssertEqual(rows[1], "01234 ")
    }

    func testTwoColumnS() throws {
        var table = TablePrinter()
        table.addColumn(title: "#", values: ["013"])
        table.addColumn(title: "Action", values: ["01"])

        let rows = table.getRows()
        XCTAssertEqual(rows.count, 2)
        XCTAssertEqual(rows[0], "#   Action ")
        XCTAssertEqual(rows[1], "013 01     ")
    }

    func stestTwoColumnTable() throws {
        var table = TablePrinter()
        table.addColumn(title: "#", values: ["0"])
        table.addColumn(title: "Current State", values: ["end"])

        let rows = table.getRows()
        XCTAssertEqual(rows.count, 2)
        XCTAssertEqual(rows[0], "# Current State")
        XCTAssertEqual(rows[1], "0 end")
    }
}
