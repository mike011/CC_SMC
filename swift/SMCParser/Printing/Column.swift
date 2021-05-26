//
//  Column.swift
//  SMCParser
//
//  Created by Michael Charland on 2021-05-10.
//

struct Column {
    let title: String
    let values: [String]

    func getLongestStringLength() -> Int {
        return max(title.count, values.sorted().last!.count)
    }

    func getRemainingSpaces(atIndex index: Int) -> Int {
        return getLongest(forString: values[index])
    }

    func getRemainingSpacesForTitle() -> Int {
        return getLongest(forString: title)
    }

    fileprivate func getLongest(forString string: String) -> Int {
        return getLongestStringLength() - string.count
    }

}
