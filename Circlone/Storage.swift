//
//  Storage.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-08-14.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation

struct Storage<T: Comparable> {
    
    private let mutex = dispatch_semaphore_create(1)
    
    private var small: [T] = []
    private var large: [T] = []
    
    private var new: [T] = []
    
    let pivotPoint: T
    
    init(pivotPoint: T) {
        self.pivotPoint = pivotPoint
    }
    
    mutating func popAllNew() -> [T] {
        dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER)
        let items = new
        new = []
        dispatch_semaphore_signal(mutex)
        return items
    }
    
    mutating func pushNew(item: T) {
        dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER)
        
        if item <= pivotPoint {
            small += [item]
        } else {
            large += [item]
        }

        new += [item]
        dispatch_semaphore_signal(mutex)
    }
    
    func fetchLarge() -> [T] {
        return large
    }

    func fetchSmall() -> [T] {
        return small
    }
}

protocol Collideable {
    func containsPoint(x x: Float, y: Float) -> Bool
}

extension Storage where T: Collideable {
    
    mutating func removeLarge(atIndex index: Int) {
        dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER)
        large.removeAtIndex(index)
        dispatch_semaphore_signal(mutex)
    }
    
    mutating func itemAt(x x: Float, y: Float) -> T? {
        for (index, item) in large.enumerate() {
            if item.containsPoint(x: x, y: y) {
                removeLarge(atIndex: index)
                return item
            }
        }
        return nil
    }
}
