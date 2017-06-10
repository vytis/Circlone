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
    
    fileprivate var tree: Node
    fileprivate var large: [Circle] = []
    internal var all: [Circle] = []
    
    internal typealias ObserverCallback = (Int, TimeInterval) -> ()
    fileprivate typealias Observer = (limit: Int, callback: ObserverCallback)
    
    fileprivate let start = Date()
    fileprivate var callback: Observer?
    
    internal let pivotPoint: Float
    
    internal init(viewport: Viewport, pivotPoint: Float? = nil) {
        self.pivotPoint = pivotPoint ?? (viewport.height / 250)
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(viewport.width), height: CGFloat(viewport.height)))
        tree = Node(circles: [], frame: frame)
    }
    
    internal mutating func setObserver(every limit: Int, callback: @escaping ObserverCallback) {
        self.callback = (limit: limit, callback: callback)
    }
}

extension Storage {
    internal mutating func popItemAt(x: Float, y: Float) -> Circle? {
        for (index, item) in self.large.enumerated() {
            if item.containsPoint(x: x, y: y) {                
                large.remove(at: index)
            }
        }
        return tree.remove(x: x, y: y)
    }
    
    internal mutating func add(_ items: [Circle]) -> [Circle] {
        var circles = [Circle]()
        for item in items {
            if item.collides(large) {
                continue
            }
            if tree.collides(item) {
                continue
            }
            
            tree.add(circle: item)
            if item.radius >= pivotPoint {
                let index = large.binarySearch {
                    return $0.radius > item.radius
                }
                large.insert(item, at: index)
            } else {
                tree.add(circle: item)
            }
            all.append(item)
            circles.append(item)
            if let (limit, callback) = callback, all.count % limit == 0 {
                let count = all.count
                let elapsed = -self.start.timeIntervalSinceNow
                    callback(count, elapsed)
            }
        }
        return circles
    }
}

