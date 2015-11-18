//
//  Pipe.swift
//  FlappyBird
//
//  Created by Monzy on 15/11/16.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class Pipe: UIView {
    
    //52 320
    var width: CGFloat?
    var height: CGFloat?
    var pipeWidth: CGFloat = 0
    var pipeHeight: CGFloat = 0
    
    var startX: CGFloat?
    var startY: CGFloat?
    var downPipe: UIImageView?
    var upPipe: UIImageView?
    var space: CGFloat?
    var birdSize: CGFloat?
    
    var animateTimer: NSTimer?
    var checkInSuperViewTimer: NSTimer?
    var checkCollisionTimer: NSTimer?
    
    func configure(bgHeight: CGFloat, startX: CGFloat, birdSize: CGFloat, downPipeImage: UIImage, upPipeImage: UIImage) {
        if downPipe != nil || superview == nil {
            return
        }
        
        
        space = birdSize * 1.5
        width = birdSize
        height = space! + (width! * 320 / 52) * 2
        pipeWidth = width!
        pipeHeight = width! * 320 / 52
        
        let spaceStartY: CGFloat = randomInRange(pipeHeight, min: (superview?.frame.height)! - (pipeHeight + bgHeight + space!))
        self.startX = startX
        self.startY = spaceStartY - pipeHeight
        self.birdSize = birdSize
        downPipe = UIImageView(image: downPipeImage)
        downPipe?.frame = CGRect(x: 0, y: 0, width: pipeWidth, height: pipeHeight)
        upPipe = UIImageView(image: upPipeImage)
        upPipe?.frame = CGRect(x: 0, y: pipeHeight + space!, width: pipeWidth, height: pipeHeight)
        
        
        self.addSubview(downPipe!)
        self.addSubview(upPipe!)
        self.frame = CGRect(x: startX, y: startY!, width: width!, height: height!)
        animate()
        initObserver()
        
    }
    
    func initObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "birdDie", name: "BirdDieNotification", object: nil)
    }
    
    func birdDie() {
        stop()
    }
    
    func randomInRange(max: CGFloat, min: CGFloat) -> CGFloat {
        let a = UInt32(Float(max - min + 1))
        let b = UInt32(Float(min))
        return CGFloat(arc4random() % a + b)
    }
    
    func animate() {
        animateTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "move", userInfo: nil, repeats: true)
        checkInSuperViewTimer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: "checkInSuperView", userInfo: nil, repeats: true)
        checkCollisionTimer = NSTimer.scheduledTimerWithTimeInterval(0.0001, target: self, selector: "checkCollision", userInfo: nil, repeats: true)
    }
    
    func move() {
        var newFrame = self.frame
        newFrame.origin.x -= 1
        self.frame = newFrame
    }
    
    func stop() {
        animateTimer?.invalidate()
        checkCollisionTimer?.invalidate()
        checkInSuperViewTimer?.invalidate()
    }
    
    func checkInSuperView() {
        if (self.frame.origin.x + self.frame.width) < 0 {
            NSNotificationCenter.defaultCenter().postNotificationName("NewPipe", object: nil)
            self.removeFromSuperview()
            self.stop()
        }
    }
    
    func checkCollision() {
        if let superView = superview {
            for subView in superView.subviews {
                if subView.isKindOfClass(Bird) {
                    if isSafe(subView.frame) == false {
                        NSNotificationCenter.defaultCenter().postNotificationName("BirdDieNotification", object: nil)
                        stop()
                        print("bird die[pipe]")
                    }
                    break
                }
            }
        }
    }
    
    func isSafe(birdFrame: CGRect) -> Bool {
        let deathRadius: CGFloat = 0
        if (birdFrame.midX + birdFrame.width * deathRadius) <= self.frame.origin.x {
            return true
        } else if (birdFrame.midX - birdFrame.width * deathRadius) >= (self.frame.origin.x + self.frame.width) {
            NSNotificationCenter.defaultCenter().postNotificationName("Score", object: nil)
            checkCollisionTimer?.invalidate()
            return true
        } else if
        ((birdFrame.midY + birdFrame.height * deathRadius) < (self.frame.origin.y + pipeHeight + space!)) &&
        ((birdFrame.midY - birdFrame.height * deathRadius) > (self.frame.origin.y + pipeHeight)) {
            return true
        } else {
            return false
        }
    }
}
