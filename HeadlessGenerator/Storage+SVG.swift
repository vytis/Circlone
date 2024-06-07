import Foundation
import Hatching

typealias SVG = Hatchery
extension SVG {
    func saveSVG(atPath path: String) {
        let width = viewport.width
        let height = viewport.height
        
        var output = "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" viewBox=\"0 0 \(width) \(height)\" preserveAspectRatio=\"meet\">\n"
        output += "<rect width=\"\(width)\" height=\"\(height)\" fill=\"black\"/>"
        for circle in allCircles {
            output += circle.svgFormat
        }
        print("Unique: \(allCircles.count)")
        output += "</svg>"
        if let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last {
            let path = (documentsDir as NSString).appendingPathComponent(path)
            do {
                try output.write(toFile: path, atomically: true, encoding: .utf8)
                print("saved at \(path)")
            } catch {
                
            }
        }
    }
}

extension Circle {
    var svgFormat: String {
        return "<circle cx=\"\(x)\" cy=\"\(y)\" r=\"\(radius)\" fill=\"white\" stroke=\"none\"/>\n"
    }
}
