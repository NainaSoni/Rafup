//
//  ArrayExtension.swift
//  AirPool
//
//  Created by Ashish on 01/03/18.
//  Copyright © 2018 DS. All rights reserved.
//

import UIKit

extension Array {
    
    func deleteObjectsTill(index: Int) -> Array<Any> {
        let newNumbers = Array(self[index..<self.count])
        return newNumbers
    }
    
    func subArray<T>(array: [T], index: Int) -> [T] {
        let newNumbers = Array(self[index..<self.count])
        return newNumbers as! [T]
    }
    
    //  MARK:- Element at the given index if it exists.
    ///
    ///        [1, 2, 3, 4, 5].item(at: 2) -> 3
    ///        [1.2, 2.3, 4.5, 3.4, 4.5].item(at: 3) -> 3.4
    ///        ["h", "e", "l", "l", "o"].item(at: 10) -> nil
    ///
    /// - Parameter index: index of element.
    /// - Returns: optional element (if exists).
    public func item(at index: Int) -> Element? {
        guard startIndex..<endIndex ~= index else { return nil }
        return self[index]
    }
    
    //  MARK:- Remove last element from array and return it.
    ///
    ///        [1, 2, 3, 4, 5].pop() // returns 5 and remove it from the array.
    ///        [].pop() // returns nil since the array is empty.
    ///
    /// - Returns: last element in array (if applicable).
    @discardableResult public mutating func pop() -> Element? {
        return popLast()
    }
    
    //  MARK:- Insert an element at the beginning of array.
    ///
    ///        [2, 3, 4, 5].prepend(1) -> [1, 2, 3, 4, 5]
    ///        ["e", "l", "l", "o"].prepend("h") -> ["h", "e", "l", "l", "o"]
    ///
    /// - Parameter newElement: element to insert.
    public mutating func prepend(_ newElement: Element) {
        insert(newElement, at: 0)
    }
    
    //  MARK:- Insert an element to the end of array.
    ///
    ///        [1, 2, 3, 4].push(5) -> [1, 2, 3, 4, 5]
    ///        ["h", "e", "l", "l"].push("o") -> ["h", "e", "l", "l", "o"]
    ///
    /// - Parameter newElement: element to insert.
    public mutating func push(_ newElement: Element) {
        append(newElement)
    }
    
    //  MARK:-  Safely Swap values at index positions.
    ///
    ///        [1, 2, 3, 4, 5].safeSwap(from: 3, to: 0) -> [4, 2, 3, 1, 5]
    ///        ["h", "e", "l", "l", "o"].safeSwap(from: 1, to: 0) -> ["e", "h", "l", "l", "o"]
    ///
    /// - Parameters:
    ///   - index: index of first element.
    ///   - otherIndex: index of other element.
    public mutating func safeSwap(from index: Int, to otherIndex: Int) {
        guard index != otherIndex,
            startIndex..<endIndex ~= index,
            startIndex..<endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }
    
    //  MARK:-  Swap values at index positions.
    ///
    ///        [1, 2, 3, 4, 5].swap(from: 3, to: 0) -> [4, 2, 3, 1, 5]
    ///        ["h", "e", "l", "l", "o"].swap(from: 1, to: 0) -> ["e", "h", "l", "l", "o"]
    ///
    /// - Parameters:
    ///   - index: index of first element.
    ///   - otherIndex: index of other element.
    public mutating func swap(from index: Int, to otherIndex: Int) {
        swapAt(index, otherIndex)
    }
}

extension Array where Element: Equatable {
    
    //  MARK:- Remove all duplicate elements from Array.
    ///
    ///        [1, 2, 2, 3, 4, 5].removeDuplicates() -> [1, 2, 3, 4, 5]
    ///        ["h", "e", "l", "l", "o"]. removeDuplicates() -> ["h", "e", "l", "o"]
    ///
    public mutating func removeDuplicates() {
        // Thanks to https://github.com/sairamkotha for improving the method
        self = reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
    
    //  MARK:- Return array with all duplicate elements removed.
    ///
    ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].duplicatesRemoved() -> [1, 2, 3, 4, 5])
    ///     ["h", "e", "l", "l", "o"].duplicatesRemoved() -> ["h", "e", "l", "o"])
    ///
    /// - Returns: an array of unique elements.
    ///
    public func duplicatesRemoved() -> [Element] {
        // Thanks to https://github.com/sairamkotha for improving the property
        return reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
}
