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
    
    var hatchery: Hatchery!
    var displayLink: CADisplayLink!
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        if hatchery.running {
            let point = sender.locationInView(circleView)
            hatchery.removeCircleAt(x: Float(point.x), y: Float(point.y)) {[weak self] circle in
                self?.circleView.removeCircle(circle)
            }
        } else {
            hatchery.running = true
            labelContainer.hidden = true
        }
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
        hatchery.running = false
        hatchery.reset()
        labelContainer.hidden = false
        circleView.reset()
        let color = UIColor(hue: randValue(), saturation: randValue(), brightness: randValue(from: 0.3, to: 0.9), alpha: 1.0)
        circleView.baseColor = color
        updateTextColor(color)
    }
    
    func updateTextColor(color: UIColor) {
        tapLabel.textColor = color.tintColor(amount: 0.7)
        shakeLabel.textColor = color.tintColor(amount: 0.3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewport = Viewport(height: Float(view.frame.height), width: Float(view.frame.width))
        hatchery = Hatchery(viewport: viewport, maxSize: Circle.maxRadius)
        hatchery.popNewCircles = circleView.addCircles
        updateTextColor(circleView.baseColor)
    }
}
