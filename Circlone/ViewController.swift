//
//  ViewController.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 🗿. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController {

    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var labelContainer: UIView!

    var hatchery: Hatchery!
    var displayLink: CADisplayLink!
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        if hatchery.running {
            let point = sender.locationInView(circleView)
            if let circle = hatchery.removeCircleAt(x: Float(point.x), y: Float(point.y)) {
                circleView.removeCircle(circle)
            }
        } else {
            hatchery.running = true
            labelContainer.hidden = true
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        hatchery.running = false
        hatchery.reset()
        labelContainer.hidden = false
        circleView.reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayLink = CADisplayLink(target: self, selector: Selector("update"))
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        let viewport = Viewport(height: Float(view.frame.height), width: Float(view.frame.width))
        hatchery = Hatchery(viewport: viewport, maxSize: 60)
    }
    
    func update() {
        let newCircles = hatchery.popNewCircles()
        circleView.addCircles(newCircles)
    }
}

