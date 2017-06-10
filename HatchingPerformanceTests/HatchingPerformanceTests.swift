//
//  HatchingPerformanceTests.swift
//  HatchingPerformanceTests
//
//  Created by Vytis ⚫ on 10/06/2017.
//  Copyright © 2017 🗿. All rights reserved.
//

import XCTest
@testable import Hatching

class HatchingPerformanceTests: XCTestCase {
    
    let maxSize: Float = 100
    let viewport = Viewport(height: 500, width: 500)
    
    var generator: RandomGenerator!
    override func setUp() {
        generator = RandomGenerator(seed: 1234)
    }
    
    
    func testGeneratorPerformance() {
        self.measure {
            for _ in 0...500000 {
                _ = self.generator.generate(self.viewport, maxSize: self.maxSize)
            }
        }
    }
    
    func testCollisionPerformance() {
        var circles: [Circle] = []
        let toAdd = (0...100000).map{ _ in self.generator.generate(self.viewport, maxSize: self.maxSize) }
        
        for circle in toAdd {
            if !circle.collides(circles) {
                circles += [circle]
            }
        }
        let toCollide = (0...10000).map{ _ in self.generator.generate(self.viewport, maxSize: self.maxSize) }
        self.measure() {
            var newCircles: [Circle] = []
            for circle in toCollide {
                if !circle.collides(circles) {
                    newCircles += [circle]
                }
            }
        }
    }
    
    func testStoragePerformance() {
        var storage = Storage(viewport: viewport)
        let toAdd = (0...100000).map{ _ in self.generator.generate(self.viewport, maxSize: self.maxSize) }
        _ = storage.add(toAdd)
        let toCollide = (0...20000).map{ _ in self.generator.generate(self.viewport, maxSize: self.maxSize) }
        self.measure {
            _ = storage.add(toCollide)
        }
    }
    
}
