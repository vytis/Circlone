import Foundation

extension Circle: Comparable {}

public func <(lhs: Circle, rhs: Circle) -> Bool {
    return lhs.radius < rhs.radius
}
