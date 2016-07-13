//
//  Circle.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-06-20.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation
import Hatching

extension Circle {
    func normalizedRadius(maxRadius maxRadius: Float) -> Float {
        return radius / maxRadius
    }
}

//extension NSCoder {
//    func encodeCircles(circles: [Circle], forKey key: String) {
//        let xs = circles.map { $0.x }
//        let ys = circles.map { $0.y }
//        let radiuses = circles.map { $0.radius }
//
//        let values = ["xs" : xs, "ys": ys, "radiuses": radiuses]
//        encodeObject(values, forKey: key)
//    }
//    
//    func decodeCirclesForKey(key: String) -> [Circle]? {
//        guard let values = decodeObjectForKey(key) as? [String : [Float]] else {
//            return nil
//        }
//        guard let xs = values["xs"],
//            let ys = values["ys"],
//            let radiuses = values["radiuses"]
//            where xs.count == ys.count && ys.count == radiuses.count else {
//                return nil
//        }
//        var circles = [Circle]()
//        for (idx, x) in xs.enumerate() {
//            let y = ys[idx]
//            let radius = radiuses[idx]
//            circles.append(Circle(x: x, y: y, radius: radius))
//        }
//        return circles
//    }
//}
//
