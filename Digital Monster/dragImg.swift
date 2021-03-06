//
//  dragImg.swift
//  Digital Monster
//
//  Created by Daniel Stagnaro on 6/2/16.
//  Copyright © 2016 Daniel Stagnaro. All rights reserved.
//

import Foundation
import UIKit

class DragImg: UIImageView {
    
    var originalPositon: CGPoint!
    var dropTarget: UIView?
//    var tagValueMine: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        originalPositon = self.center
//        tagValueMine = self.tag
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            
            let position = touch.locationInView(self.superview)
            self.center = CGPointMake(position.x, position.y) 
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first, let target = dropTarget {
            let position = touch.locationInView(self.superview)
            if CGRectContainsPoint(target.frame, position) {
                
                if self.tag == 1 {                    
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "onTargetDroppedLifeFruit", object: nil))
                } else {
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "onTargetDropped", object: nil))
                }
            }
            
        }
        
        self.center = originalPositon
    }
}
