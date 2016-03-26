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

class SeededRandomGenerator {
    init(seed: Int) {
        srand(UInt32(seed))
    }
    
    func generate(viewport: Viewport, maxSize: Float) -> Circle {
        
        let radius = Float(rand() % Int32(maxSize) + 1)
        
        let x = Float(rand() % Int32(viewport.width - radius) + Int32(radius))
        let y = Float(rand() % Int32(viewport.height - radius) + Int32(radius))
        
        return Circle(x:x, y:y, radius:radius)
    }
}


let viewport = Viewport()

//func randomCircle(viewport: Viewport, maxSize: Float) -> Circle {
//    let x = Float(arc4random_uniform(uint(viewport.width)))
//    let y = Float(arc4random_uniform(uint(viewport.height)))
//    
//    let radius = Float(arc4random_uniform(uint(maxSize)) + 1)
//    return Circle(x:x, y:y, radius:radius)
//}
//
//var circles: [Circle] = []
//for _ in 1...100 {
//    let c = randomCircle(viewport, maxSize: maxSize)
//    if c.isValid(viewport, circles:circles) {
//        circles.append(c)
//    }
//}
//circles
//let c = Circle(x: 50, y: 50, radius: 10 )
//c.isValid(viewport, circles: circles)


//let q = dispatch_queue_create("com.mine", DISPATCH_QUEUE_SERIAL)
//
//let source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, q)
//
//dispatch_source_set_event_handler(source) {
//    print("Data: \(dispatch_source_get_data(source))")
//}
//
//dispatch_resume(source)
//
////while true {
//    dispatch_source_merge_data(source, 1)
////}
//
//
//protocol A {
//    func randomCircles(count: Int) -> [Circle] // should not collide together
//    func fits(storage: String, circle: Circle) -> Circle? // nil if it doesn't fit
//    
//}

let produceQ = dispatch_queue_create("com.mine", DISPATCH_QUEUE_CONCURRENT)
let resultsQ = dispatch_queue_create("com.mine", DISPATCH_QUEUE_SERIAL)

let generator = SeededRandomGenerator(seed: 10)

var storage: [Circle] = []

func appendToStorage(circle: Circle) {
    storage.append(circle)
}

func generate() {
    var circles: [Circle] = []
    for _ in 1...30 {
        let circle = generator.generate(viewport, maxSize: 10)
        if circle.fits(circles) {
            circles.append(circle)
        }
    }
    print("Generated \(circles.count)")
    iteration(circles, storage: storage) {
        print("Total \(storage.count)")
    }
}

func iteration(circles: [Circle], storage: [Circle], completion: (Void) -> Void ) {
    dispatch_async(resultsQ) {
        for circle in circles {
            dispatch_async(produceQ) {
                if circle.fits(storage) {
                    dispatch_async(resultsQ) {
                        appendToStorage(circle)
                    }
                }
            }
        }
        dispatch_async(resultsQ, completion)
    }
}
DISPATCH_API_VERSION
generate()
generate()
generate()
generate()
generate()
generate()
generate()
generate()
generate()
generate()
//iteration(storage)
//iteration()

while true {}
//dispatch_sync(resultsQ) {
//    print(storage.count)
//}

