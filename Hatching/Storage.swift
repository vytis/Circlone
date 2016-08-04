//
//  Storage.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-08-14.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation
import CoreGraphics

struct Storage {
    
    private var tree: Node
    private var large: [Circle] = []
    private var all: [Circle] = []
    
    let start = NSDate()
    
    let pivotPoint: Float
    
    init(viewport: Viewport, pivotPoint: Float? = nil) {
        self.pivotPoint = pivotPoint ?? (viewport.height / 250)
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(viewport.width), height: CGFloat(viewport.height)))
        tree = Node(circles: [], frame: frame)
    }    
}

extension Storage {
    mutating func popItemAt(x x: Float, y: Float) -> Circle? {
        for (index, item) in self.large.enumerate() {
            if item.containsPoint(x: x, y: y) {                
                large.removeAtIndex(index)
            }
        }
        return tree.remove(x: x, y: y)
    }
    
    mutating func add(items: [Circle]) -> [Circle] {
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

extension CollectionType where Index: RandomAccessIndexType {
    
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

typealias SVG = Storage
extension SVG {
    func saveSVG(atPath path: String) {
        var output = "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" viewBox=\"0 0 \(tree.frame.size.width) \(tree.frame.size.height)\" preserveAspectRatio=\"meet\">\n"
        output += "<rect width=\"\(tree.frame.size.width)\" height=\"\(tree.frame.size.height)\" fill=\"black\"/>"
        let circles = all
        for circle in circles {
            output += circle.svgFormat
        }
        print("Unique: \(circles.count)")
        output += "</svg>"
        if let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last {
            let path = (documentsDir as NSString).stringByAppendingPathComponent(path)
            do {
                try output.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
                print("saved at \(path)")
            } catch {
                
            }
        }
    }
}

extension Circle {
    var svgFormat: String {
        return "<circle cx=\"\(x)\" cy=\"\(y)\" r=\"\(radius)\" fill=\"white\" stroke=\"none\"/>\n"
    }
}
