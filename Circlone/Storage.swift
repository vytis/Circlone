//
//  Storage.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-08-14.
//  Copyright © 2015 Wahanda. All rights reserved.
//

import Foundation

struct Storage<T> {
    
    private let fetchQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    
    private var all: [T] = []
    private var new: [T] = []
    
    mutating func popAllNew() -> [T] {
        var items: [T] = []
        dispatch_sync(fetchQueue) {
            items = self.new
            self.new = []
        }
        return items
    }
    
    mutating func pushNew(item: T) {
        dispatch_sync(fetchQueue) {
            self.all += [item]
            self.new += [item]
        }
    }
    
    func fetchAll() -> [T] {
        var items: [T] = []
        dispatch_sync(fetchQueue) {
            items = self.all
        }
        return items
    }
}
