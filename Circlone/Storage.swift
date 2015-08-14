//
//  Storage.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-08-14.
//  Copyright © 2015 Wahanda. All rights reserved.
//

import Foundation

struct Storage<T: Comparable> {
    
    private let fetchQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
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
        let items = self.new
        self.new = []
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

        self.new += [item]
        dispatch_semaphore_signal(mutex)
    }
    
    func fetchLarge() -> [T] {
        dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER)
        let items = large
        dispatch_semaphore_signal(mutex)
        return items
    }

    func fetchSmall() -> [T] {
        dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER)
        let items = small
        dispatch_semaphore_signal(mutex)
        return items
    }
}
