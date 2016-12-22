//
//  ViewController.swift
//  HeadlessGenerator
//
//  Created by Vytis ⚫ on 2016-07-13.
//  Copyright © 2016 🗿. All rights reserved.
//

import Cocoa
import Hatching

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    var hatchery: Hatchery?

    @IBAction func startTapped(_ sender: AnyObject) {
        let viewport = Viewport(height: 2000, width: 2000)
        hatchery = Hatchery(viewport: viewport, maxSize: 1)
    }
    
    @IBAction func stopTapped(_ sender: AnyObject) {
        hatchery?.stop()
        hatchery?.saveSVG(atPath: "Some.svg")
        hatchery = nil
    }

}

