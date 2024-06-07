import UIKit

private func randValue(from: CGFloat = 0.0, to: CGFloat = 1.0) -> CGFloat {
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
    
    func tinted(amount: CGFloat) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)

        let red   = r + amount * (1 - r)
        let green = g + amount * (1 - g)
        let blue  = b + amount * (1 - b)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

final class ColorScheme: NSObject {
    var currentColor: UIColor
    var nextColor: UIColor

    var nextScheme: ColorScheme {
        return ColorScheme(currentColor: nextColor, nextColor: UIColor.randomColor)
    }
    
    init(currentColor: UIColor = UIColor.baseBlueColor, nextColor: UIColor = UIColor.randomColor) {
        self.currentColor = currentColor
        self.nextColor = nextColor
    }
}
