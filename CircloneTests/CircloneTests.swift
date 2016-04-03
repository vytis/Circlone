//
//  CircloneTests.swift
//  CircloneTests
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 🗿. All rights reserved.
//

import XCTest
@testable import Circlone

class CircloneTests: XCTestCase {
    
    func testCollisionPerformance() {
        var circles: [Circle] = []
        srand(100)
        for _ in 0...100000 {
            let circle = Circle(x:Float(rand() % 500), y:Float(rand() % 500), radius:Float(rand() % 50))
            if !circle.collides(circles) {
                circles += [circle]
            }
        }
        
        self.measureBlock() {
            var newCircles: [Circle] = []
            for _ in 0...10000 {
                let circle = Circle(x:Float(rand() % 500), y:Float(rand() % 500), radius:Float(rand() % 50))
                if !circle.collides(circles) {
                    newCircles += [circle]
                }
            }
        }
    }
}
