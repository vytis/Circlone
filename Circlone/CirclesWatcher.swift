//
//  CirclesWatcher.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-08-12.
//  Copyright © 2016 🗿. All rights reserved.
//

import Foundation
import Hatching

final class CirclesWatcher: HatcheryDelegate {
    let newCircles: Subscriber
    let removedCircles: Subscriber
    weak var circleView: CircleView?
    
    deinit {
        newCircles.stop()
        removedCircles.stop()
    }

    init(circleView: CircleView) {
        self.circleView = circleView
        newCircles = Subscriber()
        removedCircles = Subscriber()
        newCircles.delegate = self
        removedCircles.delegate = self
    }
    
    func hatcheryAdded(circles: [Circle]) {
        newCircles.addNew(circles)
    }
    
    func hatcheryRemoved(circles: [Circle]) {
        removedCircles.addNew(circles)
    }
}

extension CirclesWatcher: SubscriberDelegate {
    func updated(from subscriber: Subscriber, withCircles circles: [Circle]) {
        if subscriber === newCircles {
            circleView?.addCircles(circles)
        } else {
            circleView?.removeCircles(circles)
        }
    }
}
