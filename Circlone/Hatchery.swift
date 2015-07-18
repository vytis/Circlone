//
//  Hatchery.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 Wahanda. All rights reserved.
//

import Foundation

typealias OnCircles = ([Circle] -> Void)

class Hatchery {
    
    let maxSize: Float
    let viewport: Viewport
    var running = false {
        didSet {
            if (running) {
                hatch()
            }
        }
    }
    
    private let hatchQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    private let circlesQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)

    private var circles: [Circle] = []
    private var newCircles: [Circle] = []

    init(viewport:Viewport, maxSize:Float) {
        self.viewport = viewport
        self.maxSize = maxSize;
    }
    
    func fetchAllCircles(onCircles: OnCircles) {
        dispatch_async(circlesQueue) {
            let circles = self.circles
            dispatch_sync(dispatch_get_main_queue()) {
                onCircles(circles)
            }
        }
    }
    
    func fetchNewCircles(onCircles: OnCircles) {
        dispatch_async(circlesQueue) {
            let circles = self.newCircles
            self.newCircles = []
            dispatch_sync(dispatch_get_main_queue()) {
                onCircles(circles)
            }
        }
    }
    
    private func randomCircle(viewport: Viewport, maxSize: Float) -> Circle {
        let radius = Float(arc4random_uniform(uint(maxSize)) + 1)

        let x = Float(arc4random_uniform(uint(viewport.width - radius)) + uint(radius))
        let y = Float(arc4random_uniform(uint(viewport.height - radius)) + uint(radius))
        
        return Circle(x:x, y:y, radius:radius)
    }
    
    private func hatch() {
        dispatch_async(hatchQueue) {
            while(self.running) {
                let circle = self.randomCircle(self.viewport, maxSize: self.maxSize)
                var circles: [Circle] = []
                dispatch_sync(self.circlesQueue) {
                    circles = self.circles
                }
                if (circle.fits(circles)) {
                    dispatch_sync(self.circlesQueue) {
                        self.circles += [circle]
                        self.newCircles += [circle]
                    }
                }
            }
        }
    }
    
    
}
