//
//  CirclesWatcher.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-08-12.
//  Copyright © 2016 🗿. All rights reserved.
//

import Foundation
import Hatching

class CirclesWatcher: HatcheryDelegate {
    let newCircles: Subscriber
    let removedCircles: Subscriber

    init(circleView: CircleView) {
        newCircles = Subscriber(onCircles: circleView.addCircles)
        removedCircles = Subscriber(onCircles: circleView.removeCircles)
    }
    
    func hatcheryAdded(circles circles: [Circle]) {
        newCircles.addNew(circles)
    }
    
    func hatcheryRemoved(circles circles: [Circle]) {
        removedCircles.addNew(circles)
    }
}
