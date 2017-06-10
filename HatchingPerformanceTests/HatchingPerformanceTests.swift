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
    var storage: Storage!
    
    override func setUp() {
        generator = RandomGenerator(seed: 1234)
        storage = Storage(viewport: viewport)
        _ = storage.add(generateCircles(count: 100_000))
    }
    
    override func tearDown() {
        generator = nil
        storage = nil
    }
    
    func generateCircles(count: Int) -> [Circle] {
        return (0...count).map { _ in self.generator.generate(self.viewport, maxSize: self.maxSize) }
    }
    
    func testGeneratorPerformance() {
        self.measure {
            // We want to see the performance of the generate function without array overhead
            // So we should not use the helper function here
            for _ in 0...500_000 {
                _ = self.generator.generate(self.viewport, maxSize: self.maxSize)
            }
        }
    }
    
    func testCollisionPerformance() {
        var initial: [Circle] = []
        
        // Make sure we have a set of circles that don't overlap
        for circle in generateCircles(count: 100_000) {
            if !circle.collides(initial) {
                initial += [circle]
            }
        }
        
        let toCollide = generateCircles(count: 10_000)
        self.measure() {
            _ = toCollide.filter { $0.collides(initial) }
        }
    }
    
    func testStoragePerformance() {
        
        let toCollide = generateCircles(count: 20_000)
        self.measure {
            _ = storage.add(toCollide)
        }
    }
    
    func testRemovalPerformance() {
        let toRemove = generateCircles(count: 200)
        self.measure {
            toRemove.forEach {
                _ = storage.popItemAt(x: $0.x, y: $0.y)
            }
        }
    }
    
}
