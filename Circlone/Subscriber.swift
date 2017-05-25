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
//    fileprivate var newCircles = [Circle]()
    fileprivate let q = DispatchQueue(label: "Subscriber Queue", attributes: [])
    fileprivate var hatchery: Hatchery!
    fileprivate var view: CircleView!
    
    internal weak var delegate: SubscriberDelegate?
        
    func stop() {
        displayLink.invalidate()
    }
    
    init(hatchery: Hatchery, view: CircleView) {
        self.hatchery = hatchery
        self.view = view
        displayLink = CADisplayLink(target: self, selector: #selector(onDraw))
        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    @objc fileprivate func onDraw() {
        let newEvents = hatchery.consumeAll()
        if !newEvents.isEmpty {
            view.addEvents(newEvents)
        }
    }
}
