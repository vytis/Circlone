//
//  HatcheryDelegate.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-08-12.
//  Copyright © 2016 🗿. All rights reserved.
//

import Foundation

public protocol HatcheryDelegate: class {
    func hatcheryAdded(circles circles: [Circle])
    func hatcheryRemoved(circles circles: [Circle])
}
