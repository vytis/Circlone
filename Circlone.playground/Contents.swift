//: Playground - noun: a place where people can play

import Cocoa

let maxSize: Float = 20

struct Viewport {
    let height: Float = 100
    let width: Float = 200
}

struct Circle {
    var x: Float
    var y: Float
    var radius: Float
    
    func collides(circle: Circle) -> Bool {
        let otherCircle = circle
        let delta_x = x - otherCircle.x;
        let delta_y = y - otherCircle.y;
        let distance_sq = delta_x * delta_x + delta_y * delta_y;
        let radiuses = radius + otherCircle.radius;
        return distance_sq < radiuses * radiuses
    }
    
    func fits(circles:[Circle]) -> Bool {
        return circles.filter {collides($0)}.count == 0
    }
    
    func isValid(viewport: Viewport, circles: [Circle]) -> Bool {
        return fits(viewport) && fits(circles)
    }
    
    func fits(viewport: Viewport) -> Bool {
        return (x - radius >= 0) && (y - radius >= 0) && (x + radius <= viewport.width) && (y + radius <= viewport.height)
    }
}

let viewport = Viewport()

func randomCircle(viewport: Viewport, maxSize: Float) -> Circle {
    let x = Float(arc4random_uniform(uint(viewport.width)))
    let y = Float(arc4random_uniform(uint(viewport.height)))
    
    let radius = Float(arc4random_uniform(uint(maxSize)) + 1)
    return Circle(x:x, y:y, radius:radius)
}

var circles: [Circle] = []
for _ in 1...100 {
    let c = randomCircle(viewport, maxSize: maxSize)
    if c.isValid(viewport, circles:circles) {
        circles.append(c)
    }
}
circles
let c = Circle(x: 50, y: 50, radius: 10 )
c.isValid(viewport, circles: circles)
