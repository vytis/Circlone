//
//  Circle+Comparable.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-08-12.
//  Copyright © 2016 🗿. All rights reserved.
//

import Foundation

extension Circle: Comparable {}

public func <(lhs: Circle, rhs: Circle) -> Bool {
    return lhs.radius < rhs.radius
}

public func ==(lhs: Circle, rhs: Circle) -> Bool {
    return lhs.radius == rhs.radius
}
