//
//  Subscriber.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-04-03.
//  Copyright © 2016 🗿. All rights reserved.
//

import UIKit
import Hatching

typealias Circles = [Circle] -> Void

class Subscriber {
    private var displayLink: CADisplayLink!
    private var newCircles = [Circle]()
    private let q = dispatch_queue_create("Subscriber Queue", DISPATCH_QUEUE_SERIAL)
    
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
        dispatch_sync(q) {
            self.newCircles += circles
        }
    }
    
    @objc private func onDraw() {
        dispatch_sync(q) {
            if !self.newCircles.isEmpty {
                dispatch_async(dispatch_get_main_queue()) { [circles = self.newCircles] in
                    self.onNewCircles(circles)
                }
                self.newCircles.removeAll()
            }
        }
    }
}