//
//  CGRect+Helpers.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-04-09.
//  Copyright © 2016 🗿. All rights reserved.
//

import CoreGraphics

extension CGRect {
    func intersects(circle: Circle) -> Bool {
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
