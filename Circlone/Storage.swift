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

private let q = dispatch_queue_create("com.circlone.storage", DISPATCH_QUEUE_SERIAL)

extension Storage {
    func popItemAt(x x: Float, y: Float, success: Circle -> Void) {
        dispatch_async(q) {
            for (index, item) in self.large.enumerate() {
                if item.containsPoint(x: x, y: y) {
                    self.large.removeAtIndex(index)
                    success(item)
                    break
                }
            }
        }
    }
    
    func add(items: [Circle], completed: [Circle] -> Void) {
        var circles = [Circle]()
        dispatch_async(q) {
            for item in items {
                if !item.collides(self.large) {
                    if !item.collides(self.small) {
                        circles.append(item)
                        self.pushNew(item)
                    }
                }
            }
        }
        dispatch_sync(q) {
            completed(circles)
        }
    }
}

