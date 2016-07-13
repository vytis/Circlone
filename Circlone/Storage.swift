//
//  Storage.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2015-08-14.
//  Copyright © 2015 🗿. All rights reserved.
//

import Foundation
import CoreGraphics

class Storage: NSObject, NSCoding {
    
    private var tree: Node
    private var large: [Circle] = []
    private var all: [Circle] = []
    
    let pivotPoint: Float = 5
    
    init(viewport: Viewport) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(viewport.width), height: CGFloat(viewport.height)))
        tree = Node(circles: [], frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let tree = aDecoder.decodeObjectForKey("tree") as? Node,
        let large = aDecoder.decodeCirclesForKey("large") else {
            return nil
        }
        self.tree = tree
        self.large = large
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(tree, forKey: "tree")
        aCoder.encodeCircles(large, forKey: "large")
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
                }
            }
        }
        return circles
    }
}

typealias SVG = Storage
extension SVG {
    func saveSVG(atPath path: String) {
        var output = "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">\n"
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
        return "<circle cx=\"\(x)\" cy=\"\(y)\" r=\"\(radius-0.5)\" fill=\"none\" stroke=\"black\"/>\n"
    }
}
