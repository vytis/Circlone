//
//  CircleView.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-07-13.
//  Copyright © 2015 🗿. All rights reserved.
//

import UIKit
import Hatching

final class CircleView: UIView {
    
    private struct Blob {
        let circle: Circle
        let color: UIColor
    }
    
    private var blobsToDraw: [Blob] = []
    
    private var blobsLayer: CGLayerRef!
    private var imageToDraw: UIImage?
    
    var baseColor: UIColor!
    
    func reset() {
        let layerContext = CGLayerGetContext(blobsLayer)
        CGContextClearRect(layerContext, bounds)
        setNeedsDisplay()
    }
    
    var image: UIImage {
        get {
            let context = CGBitmapContextCreate(nil, Int(bounds.width) * 2, Int(bounds.height) * 2, 8, 0, CGColorSpaceCreateDeviceRGB(), CGImageAlphaInfo.NoneSkipFirst.rawValue)
            CGContextScaleCTM(context, 2, 2)
            CGContextDrawLayerInRect(context, bounds, blobsLayer)
            
            guard let imageData = CGBitmapContextCreateImage(context) else {
                return UIImage()
            }
            return UIImage(CGImage: imageData)
        }
        set {
            imageToDraw = newValue
            setNeedsDisplay()
        }
    }
    
    func addCircles(circles: [Circle]) {
        let newBlobs = circles.map { (circle) -> Blob in
            let ratio = Double(circle.normalizedRadius(maxRadius: 500))
            let color = self.baseColor.tintColor(amount: CGFloat(ratio))
            let blob = Blob(circle: circle, color: color)
            return blob
        }
        addBlobs(newBlobs)
    }
    
    func removeCircles(circles: [Circle]) {
        let blobs = circles.map { Blob(circle: $0, color: UIColor.blackColor()) }
        addBlobs(blobs)
    }
    
    private func addBlobs(blobs: [Blob]) {
        blobsToDraw += blobs
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
        
        let layerContext = CGLayerGetContext(blobsLayer)
        
        if let image = imageToDraw {
            CGContextDrawImage(layerContext, bounds, image.CGImage)
            imageToDraw = nil
        }
        
        let sortedBlobs = blobsToDraw.sort { left, right in
            return left.color == UIColor.blackColor()
        }

        sortedBlobs.forEach {
            $0.draw(layerContext)
        }
        
        blobsToDraw.removeAll()
        
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
