//
//  FlappyButton.swift
//  FlappyBird
//
//  Created by Monzy on 15/11/16.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class FlappyButton: UIButton {
    
    var originFrame: CGRect?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if originFrame == nil {
            originFrame = self.frame
        }
        self.imageView?.clipsToBounds = true
        down()
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        up()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        up()
    }
    
    func up() {
        if let originFrame = originFrame {
            UIView.animateWithDuration(0.05, animations: {
                self.frame = originFrame
            })
        } else {
            print("originFrame nil")
        }
    }
    
    func down() {
        var newFrame = self.frame
        newFrame.origin.y += newFrame.height / 15
        UIView.animateWithDuration(0.05, animations: {
            self.frame = newFrame
        })
    }
}
