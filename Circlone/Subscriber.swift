//
//  Subscriber.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-04-03.
//  Copyright © 2016 🗿. All rights reserved.
//

import UIKit

typealias Circles = [Circle] -> Void

class Subscriber {
    private var displayLink: CADisplayLink!
    private var newCircles = [Circle]()
    private let lock = NSLock()
    
    private let onNewCircles: Circles
        
    func stop() {
        displayLink.invalidate()
    }
    
    init(onCircles: Circles) {
        self.onNewCircles = onCircles
        displayLink = CADisplayLink(target: self, selector: #selector(onDraw))
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func addNew(circles: [Circle]) {
        lock.lock()
        newCircles += circles
        lock.unlock()
    }
    
    @objc private func onDraw() {
        lock.lock()
        if !newCircles.isEmpty {
            onNewCircles(newCircles)
            newCircles.removeAll()
        }
        lock.unlock()
    }
}