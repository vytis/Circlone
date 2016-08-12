//
//  CollectionType+BinarySearch.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-08-12.
//  Copyright © 2016 🗿. All rights reserved.
//

import Foundation

/*
   Taken from http://stackoverflow.com/a/33674192/791329
*/
internal extension CollectionType where Index: RandomAccessIndexType {
    
    /// Finds such index N that predicate is true for all elements up to
    /// but not including the index N, and is false for all elements
    /// starting with index N.
    /// Behavior is undefined if there is no such N.
    internal func binarySearch(predicate: Generator.Element -> Bool) -> Index {
        var low = startIndex
        var high = endIndex
        while low != high {
            let mid = low.advancedBy(low.distanceTo(high) / 2)
            if predicate(self[mid]) {
                low = mid.advancedBy(1)
            } else {
                high = mid
            }
        }
        return low
    }
    
}
