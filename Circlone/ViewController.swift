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
    
    var consumer: EventsConsumer!
    
    var hatchery: Hatchery?
    var colorScheme: ColorScheme! {
        didSet {
            let color = colorScheme.currentColor
            circleView.baseColor = color
            tapLabel.textColor = color.tinted(amount: 0.7)
            shakeLabel.textColor = color.tinted(amount: 0.3)
        }
    }
    
    @IBAction func viewPanned(_ sender: UIPanGestureRecognizer) {
        if let hatchery = hatchery {
            let point = sender.location(in: circleView)
            hatchery.removeCircleAt(x: Float(point.x), y: Float(point.y))
        }
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        if let hatchery = hatchery {
            let point = sender.location(in: circleView)
            hatchery.removeCircleAt(x: Float(point.x), y: Float(point.y))
        } else {
            start()
        }
    }
    
    func start(statePath: String? = nil) {
        let viewport = Viewport(height: Float(view.frame.height), width: Float(view.frame.width))
        self.hatchery = Hatchery(viewport: viewport, maxSize: 500)
        self.consumer = EventsConsumer(hatchery: hatchery!, view: circleView)
        labelContainer.isHidden = true
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        hatchery?.stop()
        hatchery = nil
        consumer.stop()
        consumer = nil
        labelContainer.isHidden = false
        circleView.reset()
        colorScheme = colorScheme.nextScheme
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorScheme = ColorScheme()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    func applicationWillEnterForeground() {
        if let hatchery = hatchery {
            hatchery.start()
        }
    }
}

