//
//  Subscriber.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-04-03.
//  Copyright © 2016 🗿. All rights reserved.
//

import UIKit
import Hatching

protocol SubscriberDelegate: class {
    func updated(from subscriber: Subscriber, withCircles circles: [Circle])
}

final class Subscriber {
    fileprivate var displayLink: CADisplayLink!
    fileprivate var newCircles = [Circle]()
    fileprivate let q = DispatchQueue(label: "Subscriber Queue", attributes: [])
    
    internal weak var delegate: SubscriberDelegate?
        
    func stop() {
        displayLink.invalidate()
    }
    
    init() {
        displayLink = CADisplayLink(target: self, selector: #selector(onDraw))
        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func addNew(_ circles: [Circle]) {
        q.sync {
            self.newCircles += circles
        }
    }
    
    @objc fileprivate func onDraw() {
        var circles: [Circle]?
        q.sync {
            circles = self.newCircles
            self.newCircles = []
        }
        if let newCircles = circles, !newCircles.isEmpty {
            self.delegate?.updated(from: self, withCircles: newCircles)
        }
    }
}
