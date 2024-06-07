import CoreGraphics

internal extension Circle {
    var boundingBox: CGRect {
        return CGRect(x: CGFloat(x - radius), y: CGFloat(y - radius), width: CGFloat(radius * 2), height: CGFloat(radius * 2))
    }
}

internal extension CGRect {
    func intersects(_ circle: Circle) -> Bool {
        return intersects(circle.boundingBox)
    }
    
    var leftSide: CGRect {
        return CGRect(origin: origin, size: CGSize(width: width / 2.0, height: height))
    }
    
    var rightSide: CGRect {
        return CGRect(x: origin.x + width / 2.0, y: origin.y, width: width / 2.0, height: height)
    }
    
    var bottomSide: CGRect {
        return CGRect(x: origin.x, y: origin.y + height / 2.0, width: width, height: height / 2.0)
    }
    
    var topSide: CGRect {
        return CGRect(x: origin.x, y: origin.y, width: width, height: height / 2.0)
    }

}
