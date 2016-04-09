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
    
    override class func setUp() {
        srand(100)
    }
    
    let toAdd = (0...100000).map{ _ in Circle(x:Float(rand() % 500), y:Float(rand() % 500), radius:Float(rand() % 50)) }
    let toCollide = (0...5000).map{ _ in Circle(x:Float(rand() % 500), y:Float(rand() % 500), radius:Float(rand() % 50)) }
    
    func testCollisionPerformance() {
        var circles: [Circle] = []
        for circle in toAdd {
            if !circle.collides(circles) {
                circles += [circle]
            }
        }
        
        self.measureBlock() {
            var newCircles: [Circle] = []
            for circle in self.toCollide {
                if !circle.collides(circles) {
                    newCircles += [circle]
                }
            }
        }
    }
    
    func testStoragePerformance() {
        let storage = Storage()
        storage.add(toAdd)
        
        self.measureBlock { 
            storage.add(self.toCollide)
        }
    }
    
}
