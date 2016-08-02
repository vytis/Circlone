//
//  Storage.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-08-14.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation
import CoreGraphics

final class Storage {
    
    private var tree: Node
    private var large: [Circle] = []
    private var all: [Circle] = []
    
    let start = NSDate()
    
    let pivotPoint: Float
    
    init(viewport: Viewport, pivotPoint: Float? = nil) {
        self.pivotPoint = pivotPoint ?? (viewport.height / 250)
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(viewport.width), height: CGFloat(viewport.height)))
        tree = Node(circles: [], frame: frame)
    }    
}

extension Storage {
    func popItemAt(x x: Float, y: Float) -> Circle? {
        for (index, item) in self.large.enumerate() {
            if item.containsPoint(x: x, y: y) {                
                large.removeAtIndex(index)
            }
        }
        return tree.remove(x: x, y: y)
    }
    
    func add(items: [Circle]) -> [Circle] {
        var circles = [Circle]()
        for item in items {
            if !item.collides(self.large) {
                if !tree.collides(circle: item) {
                    tree.add(circle: item)
                    if item.radius >= pivotPoint {
                        large.append(item)
                    }
                    all.append(item)
                    circles.append(item)
                    if all.count % 2500 == 0 {
                        print("Circles: \(all.count) in \(-start.timeIntervalSinceNow)s")
                    }
                }
            }
        }
        return circles
    }
}

typealias SVG = Storage
extension SVG {
    func saveSVG(atPath path: String) {
        var output = "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" viewBox=\"0 0 \(tree.frame.size.width) \(tree.frame.size.height)\" preserveAspectRatio=\"meet\">\n"
        output += "<rect width=\"\(tree.frame.size.width)\" height=\"\(tree.frame.size.height)\" fill=\"black\"/>"
        let circles = all
        for circle in circles {
            output += circle.svgFormat
        }
        print("Unique: \(circles.count)")
        output += "</svg>"
        if let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last {
            let path = (documentsDir as NSString).stringByAppendingPathComponent(path)
            do {
                try output.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
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
