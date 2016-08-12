//
//  ViewController.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 🗿. All rights reserved.
//

import UIKit
import CoreGraphics
import Hatching

final class ViewController: UIViewController {

    @IBOutlet weak var circleView: CircleView!

    @IBOutlet weak var labelContainer: UIView!

    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var shakeLabel: UILabel!
    
    var newCircles: Subscriber!
    var removedCircles: Subscriber!
    
    var hatchery: Hatchery?
    var colorScheme: ColorScheme! {
        didSet {
            let color = colorScheme.currentColor
            circleView.baseColor = color
            tapLabel.textColor = color.tintColor(amount: 0.7)
            shakeLabel.textColor = color.tintColor(amount: 0.3)
        }
    }
    
    @IBAction func viewPanned(sender: UIPanGestureRecognizer) {
        if let hatchery = hatchery {
            let point = sender.locationInView(circleView)
            hatchery.removeCircleAt(x: Float(point.x), y: Float(point.y))
        }
    }
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        if let hatchery = hatchery {
            let point = sender.locationInView(circleView)
            hatchery.removeCircleAt(x: Float(point.x), y: Float(point.y))
        } else {
            start()
        }
    }
    
    func start(statePath statePath: String? = nil) {
        let viewport = Viewport(height: Float(view.frame.height), width: Float(view.frame.width))
        newCircles = Subscriber(onCircles: circleView.addCircles)
        removedCircles = Subscriber(onCircles: circleView.removeCircles)

        hatchery = Hatchery(viewport: viewport, maxSize: 500, delegate: self)
        labelContainer.hidden = true
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        hatchery?.stop()
        hatchery = nil
        labelContainer.hidden = false
        circleView.reset()
        colorScheme = colorScheme.nextScheme
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorScheme = ColorScheme()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    func applicationWillEnterForeground() {
        if let hatchery = hatchery {
            hatchery.start()
        }
    }
}

extension ViewController: HatcheryDelegate {
    func hatcheryAdded(circles circles: [Circle]) {
        newCircles.addNew(circles)
    }
    
    func hatcheryRemoved(circles circles: [Circle]) {
        removedCircles.addNew(circles)
    }
}
