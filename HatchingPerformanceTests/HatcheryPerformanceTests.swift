//
//  HatcheryPerformanceTests.swift
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
    
    var hatchery: Hatchery?
    var generator: RandomGenerator!
    var storage: Storage!
    
    override func setUp() {
        generator = RandomGenerator(seed: 1234)
        storage = Storage(viewport: viewport)
        hatchery = Hatchery(viewport: viewport, maxSize: maxSize, storage: storage, generator: generator)
    }
    
    override func tearDown() {
        hatchery = nil
        storage = nil
        generator = nil
    }
}

extension HatchingPerformanceTests {
    func measureHatching(range: CountableRange<Int>, callbackInterval: Int = 100, file: StaticString = #file, line: UInt = #line) {
        guard range.lowerBound % callbackInterval == 0 else { XCTFail("Lower range value should be divisible by \(callbackInterval)", file: file, line: line); return}
        guard range.upperBound % callbackInterval == 0 else { XCTFail("Upper range value should be divisible by \(callbackInterval)", file: file, line: line); return}
        
        let expectation = self.expectation(description: "Limit reached")
        
        let hatchery = Hatchery(viewport: viewport, maxSize: maxSize, storage: storage, generator: generator)
        hatchery.storage.setObserver(every: callbackInterval) { count, elapsed in
            if count == range.lowerBound {
                self.startMeasuring()
            }
            if count == range.upperBound {
                expectation.fulfill()
            }
        }
        hatchery.start()
        if range.lowerBound == 0 {
            self.startMeasuring()
        }
        waitForExpectations(timeout: 5) { _ in
            self.stopMeasuring()
            hatchery.stop()
        }
    }
    
    func testSmallBatchPerformance() {
        measureMetrics(type(of: self).defaultPerformanceMetrics, automaticallyStartMeasuring: false) {
            measureHatching(range: 0..<500, callbackInterval: 500)
        }
    }
    
    func testLargeBatchPerformance() {
        measureMetrics(type(of: self).defaultPerformanceMetrics, automaticallyStartMeasuring: false) {
            measureHatching(range: 0..<1000, callbackInterval: 1000)
        }
    }
    
    func testPerformanceFrom500to600() {
        measureMetrics(type(of: self).defaultPerformanceMetrics, automaticallyStartMeasuring: false) {
            measureHatching(range: 500..<600)
        }
    }
    
    func testPerformanceFrom600to700() {
        measureMetrics(type(of: self).defaultPerformanceMetrics, automaticallyStartMeasuring: false) {
            measureHatching(range: 600..<700)
        }
    }
    
    func testPerformanceFrom700to800() {
        measureMetrics(type(of: self).defaultPerformanceMetrics, automaticallyStartMeasuring: false) {
            measureHatching(range: 700..<800)
        }
    }
    
    func testPerformanceFrom1000to1100() {
        measureMetrics(type(of: self).defaultPerformanceMetrics, automaticallyStartMeasuring: false) {
            measureHatching(range: 1000..<1100)
        }
    }
    
    
}
