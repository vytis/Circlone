//
//  Storage.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-08-14.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation
import CoreGraphics

internal struct Storage {
    
    private var tree: Node
    private var large: [Circle] = []
    internal var all: [Circle] = []
    
    private let start = NSDate()
    
    internal let pivotPoint: Float
    
    internal init(viewport: Viewport, pivotPoint: Float? = nil) {
        self.pivotPoint = pivotPoint ?? (viewport.height / 250)
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(viewport.width), height: CGFloat(viewport.height)))
        tree = Node(circles: [], frame: frame)
    }    
}

extension Storage {
    internal mutating func popItemAt(x x: Float, y: Float) -> Circle? {
        for (index, item) in self.large.enumerate() {
            if item.containsPoint(x: x, y: y) {                
                large.removeAtIndex(index)
            }
        }
        return tree.remove(x: x, y: y)
    }
    
    internal mutating func add(items: [Circle]) -> [Circle] {
        var circles = [Circle]()
        for item in items {
            if item.collides(large) {
                continue
            }
            if tree.collides(circle: item) {
                continue
            }
            
            tree.add(circle: item)
            if item.radius >= pivotPoint {
                let index = large.binarySearch {
                    return $0.radius > item.radius
                }
                large.insert(item, atIndex: index)
            } else {
                tree.add(circle: item)
            }
            all.append(item)
            circles.append(item)
            if all.count % 2500 == 0 {
                print("Circles: \(all.count) in \(-start.timeIntervalSinceNow)s")
            }
        }
        return circles
    }
}

private extension CollectionType where Index: RandomAccessIndexType {
    
    /// Finds such index N that predicate is true for all elements up to
    /// but not including the index N, and is false for all elements
    /// starting with index N.
    /// Behavior is undefined if there is no such N.
    func binarySearch(predicate: Generator.Element -> Bool) -> Index {
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
