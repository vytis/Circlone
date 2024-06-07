import Foundation

public struct Circle: Equatable {
    public let x: Float
    public let y: Float
    public let radius: Float
    
    public init(x: Float, y: Float, radius: Float) {
        self.x = x
        self.y = y
        self.radius = radius
    }    
}
