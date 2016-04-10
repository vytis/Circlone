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

    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var shakeLabel: UILabel!
    
    var hatchery: Hatchery?
    
    @IBAction func viewPanned(sender: AnyObject) {
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
    
    func start() {
        let viewport = Viewport(height: Float(view.frame.height), width: Float(view.frame.width))
        let newCircles = Subscriber(onCircles: circleView.addCircles)
        let removedCircles = Subscriber(onCircles: circleView.removeCircles)
        hatchery = Hatchery(viewport: viewport, maxSize: Circle.maxRadius, newCircles: newCircles, removedCircles: removedCircles)
        labelContainer.hidden = true
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func randValue(from from: CGFloat = 0.0, to: CGFloat = 1.0) -> CGFloat {
        let interval = to - from
        let ratio = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        let value = interval * ratio + from
        return value
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        hatchery?.stop()
        hatchery = nil
        labelContainer.hidden = false
        circleView.reset()
        let color = UIColor(hue: randValue(), saturation: randValue(), brightness: randValue(from: 0.3, to: 0.9), alpha: 1.0)
        updateColor(color)
    }
    
    func updateColor(color: UIColor) {
        circleView.baseColor = color
        tapLabel.textColor = color.tintColor(amount: 0.7)
        shakeLabel.textColor = color.tintColor(amount: 0.3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        updateColor(circleView.baseColor)
    }
}

extension ViewController {
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        coder.encodeObject(circleView.baseColor, forKey: "baseColor")
        coder.encodeBool(hatchery != nil, forKey: "running")
        
        super.encodeRestorableStateWithCoder(coder)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        if let color = coder.decodeObjectForKey("baseColor") as? UIColor {
            updateColor(color)
        }
        
        if coder.decodeBoolForKey("running") {
            start()
        }
        
        super.decodeRestorableStateWithCoder(coder)
    }
}
