//
//  Storage.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-08-14.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation

class Storage {
    
    private var small: [Circle] = []
    private var large: [Circle] = []
    
    let pivotPoint: Circle

    init(pivotPoint: Circle) {
        self.pivotPoint = pivotPoint
    }
    
    private func pushNew(item: Circle) {
        if item <= pivotPoint {
            small.append(item)
        } else {
            large.append(item)
        }
    }
}


extension Storage {
    func popItemAt(x x: Float, y: Float) -> Circle? {
        for (index, item) in self.large.enumerate() {
            if item.containsPoint(x: x, y: y) {
                self.large.removeAtIndex(index)
                return item
            }
        }
        return nil
    }
    
    func add(items: [Circle]) -> [Circle] {
        var circles = [Circle]()
        for item in items {
            if !item.collides(self.large) {
                if !item.collides(self.small) {
                    circles.append(item)
                    self.pushNew(item)
                }
            }
        }
        return circles
    }
}

