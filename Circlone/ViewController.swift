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
    
    func start(statePath statePath: String? = nil) {
        let viewport = Viewport(height: Float(view.frame.height), width: Float(view.frame.width))
        let newCircles = Subscriber(onCircles: circleView.addCircles)
        let removedCircles = Subscriber(onCircles: circleView.removeCircles)
        hatchery = Hatchery(viewport: viewport, maxSize: Circle.maxRadius, newCircles: newCircles, removedCircles: removedCircles, statePath: statePath)
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    func applicationWillEnterForeground() {
        if let hatchery = hatchery {
            hatchery.start()
        }
    }
}

extension ViewController {
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        coder.encodeObject(circleView.baseColor, forKey: "baseColor")
        if let hatchery = hatchery {
            let path = "circles"
            hatchery.stop()
            hatchery.saveState(toFile: path)
            if let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last {
                let path = (documentsDir as NSString).stringByAppendingPathComponent("image.png")
                let image = circleView.image
                do {
                    try UIImagePNGRepresentation(image)?.writeToFile(path, options: .AtomicWrite)
                } catch {}
            }
            coder.encodeObject(path, forKey: "statePath")
        }
        
        super.encodeRestorableStateWithCoder(coder)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        if let color = coder.decodeObjectForKey("baseColor") as? UIColor {
            updateColor(color)
        }
        
        if let path = coder.decodeObjectForKey("statePath") as? String {
            if let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last ,
            let image = UIImage(contentsOfFile: (documentsDir as NSString).stringByAppendingPathComponent("image.png")) {
                circleView.image = image
            }
            
            start(statePath: path)
        }
        
        super.decodeRestorableStateWithCoder(coder)
    }
}
