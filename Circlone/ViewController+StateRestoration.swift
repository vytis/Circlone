//
//  ViewController+StateRestoration.swift
//  Circlone
//
//  Created by Vytis ⚫ on 2016-06-10.
//  Copyright © 2016 🗿. All rights reserved.
//

import UIKit

extension ViewController {
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        coder.encodeObject(colorScheme, forKey: "colorScheme")

        if let hatchery = hatchery {
            let path = "circles"
            hatchery.stop()
            hatchery.saveState(toFile: path)
            if let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last {
                let path = (documentsDir as NSString).stringByAppendingPathComponent("image.png")
                let image = circleView.image
                do {
                    try UIImagePNGRepresentation(image)?.writeToFile(path, options: .AtomicWrite)
                } catch {}
            }
            coder.encodeObject(path, forKey: "statePath")
        }
        
        super.encodeRestorableStateWithCoder(coder)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        if let colorScheme = coder.decodeObjectForKey("colorScheme") as? ColorScheme {
            self.colorScheme = colorScheme
        }
        
        if let path = coder.decodeObjectForKey("statePath") as? String {
            if let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last ,
                let image = UIImage(contentsOfFile: (documentsDir as NSString).stringByAppendingPathComponent("image.png")) {
                circleView.image = image
            }
            
            start(statePath: path)
        }
        
        super.decodeRestorableStateWithCoder(coder)
    }
}
