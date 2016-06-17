//
//  ColorScheme.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-06-10.
//  Copyright © 2016 🗿. All rights reserved.
//

import UIKit

private func randValue(from from: CGFloat = 0.0, to: CGFloat = 1.0) -> CGFloat {
    let interval = to - from
    let ratio = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
    let value = interval * ratio + from
    return value
}

extension UIColor {
    static var baseBlueColor: UIColor {
        return UIColor(hue: 184.0/360.0, saturation: 0.49, brightness: 0.95, alpha: 1.0)
    }
    
    static var randomColor: UIColor {
        return UIColor(hue: randValue(), saturation: randValue(), brightness: randValue(from: 0.3, to: 0.9), alpha: 1.0)
    }
}

class ColorScheme: NSObject, NSCoding {
    var currentColor: UIColor
    var nextColor: UIColor

    var nextScheme: ColorScheme {
        return ColorScheme(currentColor: nextColor, nextColor: UIColor.randomColor)
    }
    
    init(currentColor: UIColor = UIColor.baseBlueColor, nextColor: UIColor = UIColor.randomColor) {
        self.currentColor = currentColor
        self.nextColor = nextColor
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(currentColor, forKey: "currentColor")
        aCoder.encodeObject(nextColor, forKey: "nextColor")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let
            currentColor = aDecoder.decodeObjectForKey("currentColor") as? UIColor,
            nextColor = aDecoder.decodeObjectForKey("nextColor") as? UIColor else {
                return nil
        }
        self.init(currentColor: currentColor, nextColor: nextColor)
    }
}
