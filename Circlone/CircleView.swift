//
//  CircleView.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-07-13.
//  Copyright © 2015 Wahanda. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    private var circlesToDraw: [Circle] = []
    private var circleQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    private var circleLayer: CGLayerRef!
    
    func drawCircles(circles: [Circle]) {
        dispatch_sync(circleQueue) {
            self.circlesToDraw += circles
        }
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()
        
        if circleLayer == nil {
            let size = CGSize(width: self.frame.width * 2, height: self.frame.height * 2)
            circleLayer = CGLayerCreateWithContext(context, size, nil)
            let layerContext = CGLayerGetContext(circleLayer)
            CGContextScaleCTM(layerContext, 2, 2)
        }
        
        var circles: [Circle] = []
        dispatch_sync(circleQueue) {
            circles += self.circlesToDraw
            self.circlesToDraw = []
        }
        
        let layerContext = CGLayerGetContext(circleLayer)
        circles.map {
            $0.draw(layerContext)
        }
        
        CGContextDrawLayerInRect(context, bounds, circleLayer)
    }
}

extension Circle {
    
    func draw(context:CGContext?) {
        let boundingBox = CGRectMake(CGFloat(x - radius), CGFloat(y - radius), CGFloat(radius * 2), CGFloat(radius * 2))
        CGContextFillEllipseInRect(context, boundingBox);
    }
}
