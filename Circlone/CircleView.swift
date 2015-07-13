//
//  CircleView.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-07-13.
//  Copyright © 2015 Wahanda. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var circles: [Circle] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext();
        circles.map {
            $0.draw(context)
        }
    }
}

extension Circle {
    
    func draw(context:CGContext?) {
        let boundingBox = CGRectMake(CGFloat(x - radius), CGFloat(y - radius), CGFloat(radius * 2), CGFloat(radius * 2))
        CGContextFillEllipseInRect(context, boundingBox);
    }
}
