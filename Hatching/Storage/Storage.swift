//
//  Storage.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-08-14.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation
import CoreGraphics

internal struct Storage: Equatable {
    
    fileprivate var tree: Node
    fileprivate var large: [Circle] = []
    internal var all: [Circle] = []
    
    fileprivate let start = Date()
    
    internal let pivotPoint: Float
    
    internal init(viewport: Viewport, pivotPoint: Float? = nil) {
        self.pivotPoint = pivotPoint ?? (viewport.height / 250)
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(viewport.width), height: CGFloat(viewport.height)))
        tree = Node(circles: [], frame: frame)
    }    
}

extension Storage {

    typealias Progress = (Int) -> (Void)

    internal mutating func popItemAt(x: Float, y: Float) -> Circle? {
        for (index, item) in self.large.enumerated() {
            if item.containsPoint(x: x, y: y) {                
                large.remove(at: index)
            }
        }
        return tree.remove(x: x, y: y)
    }
    
    internal mutating func add(_ items: [Circle], progress: Progress? = nil) -> [Circle] {
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
            progress?(circles.count)
        }
        return circles
    }
}

