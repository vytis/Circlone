import UIKit
import Hatching

final class CircleView: UIView {
    
    fileprivate struct Blob {
        let circle: Circle
        let color: UIColor
    }
    
    fileprivate var blobsToDraw: [Blob] = []
    
    fileprivate var blobsLayer: CGLayer!
    fileprivate var imageToDraw: UIImage?
    
    var baseColor: UIColor!
    
    func reset() {
        let layerContext = blobsLayer.context
        layerContext?.clear(bounds)
        setNeedsDisplay()
    }
    
    var image: UIImage {
        get {
            let context = CGContext(data: nil, width: Int(bounds.width) * 2, height: Int(bounds.height) * 2, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
            context?.scaleBy(x: 2, y: 2)
            context?.draw(blobsLayer, in: bounds)
            
            guard let imageData = context?.makeImage() else {
                return UIImage()
            }
            return UIImage(cgImage: imageData)
        }
        set {
            imageToDraw = newValue
            setNeedsDisplay()
        }
    }
    
    func addEvents(_ events: [Event]) {
        let newBlobs = events.map { (event) -> Blob in
            switch event {
            case let .added(circle):
                let ratio = Double(circle.normalizedRadius(maxRadius: 500))
                let color = self.baseColor.tinted(amount: CGFloat(ratio))
                let blob = Blob(circle: circle, color: color)
                return blob
            case let .removed(circle):
                let blob = Blob(circle: circle, color: .black)
                return blob
            }
        }
        addBlobs(newBlobs)
    }
    
    fileprivate func addBlobs(_ blobs: [Blob]) {
        blobsToDraw += blobs
        if (blobsToDraw.count > 0) {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        if blobsLayer == nil {
            let size = CGSize(width: frame.width * 2, height: frame.height * 2)
            blobsLayer = CGLayer(context, size: size, auxiliaryInfo: nil)
            let layerContext = blobsLayer.context
            layerContext?.scaleBy(x: 2, y: 2)
        }
        
        let layerContext = blobsLayer.context
        
        if let image = imageToDraw {
            layerContext?.draw(image.cgImage!, in: bounds)
            imageToDraw = nil
        }
        
        blobsToDraw.forEach {
            $0.draw(layerContext)
        }
        
        blobsToDraw.removeAll()
        
        context.draw(blobsLayer, in: bounds)
    }
}

extension CircleView.Blob {
    
    func draw(_ context: CGContext?) {
        context?.setFillColor(color.cgColor)
        
        let radius = circle.radius
        let boundingBox = CGRect(x: CGFloat(circle.x - radius), y: CGFloat(circle.y - radius), width: CGFloat(radius * 2), height: CGFloat(radius * 2))
        context?.fillEllipse(in: boundingBox);
    }
}
