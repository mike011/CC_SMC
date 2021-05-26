//
//  TablePrinter.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-05-10.
//

struct TablePrinter {
    private var columns = [Column]()

    mutating func addColumn(title: String, values: [String]) {
        columns.append(Column(title: title, values: values))
    }

    func getSpaces(for current: String, from values: [String]) -> String {
        return " "
    }

    func getRows() -> [String] {
        var rows = [String]()

        var titles = ""
        for column in columns {
            let spacesAmount = column.getRemainingSpacesForTitle()
            let spaces = createString(ofLength: spacesAmount)
            titles.append(column.title + spaces)
        }
        rows.append(titles)

        var row = ""
        for column in columns {
            let currentIndex = 0
            let value = column.values[currentIndex]
            let spacesAmount = column.getRemainingSpaces(atIndex: currentIndex)
            let spaces = createString(ofLength: spacesAmount)
            row.append(value + spaces)
        }
        rows.append(row)
        return rows
    }

    func createString(ofLength length: Int) -> String {
        return Array(repeating: " ", count: length + 1).joined()
    }
}
