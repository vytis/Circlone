//
//  ViewController.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 Wahanda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circleView: CircleView!
    var hatchery: Hatchery!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewport = Viewport(height: Float(view.frame.height), width: Float(view.frame.width))
        hatchery = Hatchery(viewport: viewport, maxSize: 30)
        
        for _ in 0...1000 {
            hatchery.hatch { _ in
                self.circleView.circles = self.hatchery.circles
            }
        }
    }
}

