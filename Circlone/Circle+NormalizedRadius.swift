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
