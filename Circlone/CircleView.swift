//
//  CircleView.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-07-13.
//  Copyright © 2015 🗿. All rights reserved.
//

import UIKit
import DynamicColor

class CircleView: UIView {
    
    struct Blob {
        let circle: Circle
        let color: UIColor
    }
    
    private var blobsToDraw: [Blob] = []
    
    private var blobsQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    private var blobsLayer: CGLayerRef!
    
    var baseColor = UIColor(hue: 184.0/360.0, saturation: 0.49, brightness: 0.95, alpha: 1.0)
    
    func reset() {
        let layerContext = CGLayerGetContext(blobsLayer)
        CGContextClearRect(layerContext, bounds)
        setNeedsDisplay()
    }
    
    func addCircles(circles: [Circle]) {
        let newBlobs = circles.map { (circle) -> Blob in
            let ratio = Double(circle.normalizedRadius)
            let color = self.baseColor.tintColor(amount: CGFloat(ratio))
            let blob = Blob(circle: circle, color: color)
            return blob
        }
        addBlobs(newBlobs)
    }
    
    func removeCircle(circle: Circle) {
        addBlobs([Blob(circle: circle, color: UIColor.blackColor())])
    }
    
    private func addBlobs(blobs: [Blob]) {
        dispatch_sync(blobsQueue) {
            self.blobsToDraw += blobs
        }
        if (blobsToDraw.count > 0) {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        if blobsLayer == nil {
            let size = CGSize(width: frame.width * 2, height: frame.height * 2)
            blobsLayer = CGLayerCreateWithContext(context, size, nil)
            let layerContext = CGLayerGetContext(blobsLayer)
            CGContextScaleCTM(layerContext, 2, 2)
        }
        
        var blobs: [Blob] = []
        dispatch_sync(blobsQueue) {
            blobs += self.blobsToDraw
            self.blobsToDraw = []
        }
        
        let layerContext = CGLayerGetContext(blobsLayer)

        blobs.forEach {
            $0.draw(layerContext)
        }
        
        CGContextDrawLayerInRect(context, bounds, blobsLayer)
    }
}

extension CircleView.Blob {
    
    func draw(context: CGContext?) {
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        let radius = circle.radius
        let boundingBox = CGRectMake(CGFloat(circle.x - radius), CGFloat(circle.y - radius), CGFloat(radius * 2), CGFloat(radius * 2))
        CGContextFillEllipseInRect(context, boundingBox);
    }
}
