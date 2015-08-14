//
//  ViewController.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 Wahanda. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController {

    @IBOutlet weak var circleView: CircleView!
    var hatchery: Hatchery!
    var displayLink: CADisplayLink!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayLink = CADisplayLink(target: self, selector: Selector("update"))
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        let viewport = Viewport(height: Float(view.frame.height), width: Float(view.frame.width))
        hatchery = Hatchery(viewport: viewport, maxSize: 30)
        hatchery.running = true
    }
    
    func update() {
        let newCircles = hatchery.popNewCircles()
        self.circleView.drawCircles(newCircles)
    }
}

