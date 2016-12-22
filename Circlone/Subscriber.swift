//
//  Subscriber.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-04-03.
//  Copyright © 2016 🗿. All rights reserved.
//

import UIKit
import Hatching

typealias Circles = ([Circle]) -> Void

final class Subscriber {
    fileprivate var displayLink: CADisplayLink!
    fileprivate var newCircles = [Circle]()
    fileprivate let q = DispatchQueue(label: "Subscriber Queue", attributes: [])
    
    fileprivate let onNewCircles: Circles
        
    func stop() {
        displayLink.invalidate()
    }
    
    init(onCircles: @escaping Circles) {
        self.onNewCircles = onCircles
        displayLink = CADisplayLink(target: self, selector: #selector(onDraw))
        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func addNew(_ circles: [Circle]) {
        (q).sync {
            self.newCircles += circles
        }
    }
    
    @objc fileprivate func onDraw() {
        q.sync {
            if !self.newCircles.isEmpty {
                DispatchQueue.main.async { [circles = self.newCircles] in
                    self.onNewCircles(circles)
                }
                self.newCircles.removeAll()
            }
        }
    }
}
