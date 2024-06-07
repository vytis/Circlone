import Foundation
import Hatching

extension Circle {
    func normalizedRadius(maxRadius: Float) -> Float {
        return radius / maxRadius
    }
}
