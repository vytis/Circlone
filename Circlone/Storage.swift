//
//  Storage.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-08-14.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation
import CoreGraphics

class Storage {
    
    private var tree: Node
    private var large: [Circle] = []
    
    let pivotPoint: Float = 5
    
    init(viewport: Viewport) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(viewport.width), height: CGFloat(viewport.height)))
        tree = Node(circles: [], frame: frame)
    }
}

extension Storage {
    func popItemAt(x x: Float, y: Float) -> Circle? {
        for (index, item) in self.large.enumerate() {
            if item.containsPoint(x: x, y: y) {                
                large.removeAtIndex(index)
            }
        }
        return tree.remove(x: x, y: y)
    }
    
    func add(items: [Circle]) -> [Circle] {
        var circles = [Circle]()
        for item in items {
            if !item.collides(self.large) {
                if !tree.collides(circle: item) {
                    tree.add(circle: item)
                    if item.radius >= pivotPoint {
                        large.append(item)
                    }
                    circles.append(item)
                }
            }
        }
        return circles
    }
}

