//
//  Bird.swift
//  FlappyBird
//
//  Created by Monzy on 15/11/16.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import CoreGraphics

class Bird: UIView {
    var imageView: UIImageView?
    var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }
    var flyImage1: UIImage?
    var flyImage2: UIImage?
    var flyImage3: UIImage?
    var currentImage: Int = 1
    var timer: CGFloat = 0
    let birdBehavior = BirdBehavior()
    var animateTimer: NSTimer?
    var groundTimer: NSTimer?
    var dieY: CGFloat?
    var originFrame: CGRect?
    
    var isDead = false
    var isFlyAnimComplete = true
    var downTimer: NSTimer?

    
    func configureFlyImage(image1: String, image2: String, image3: String, dieY: CGFloat, startPoint: CGPoint, birdSize: CGFloat) {
        imageView = UIImageView()
        image = UIImage()
        self.imageView!.contentMode = .ScaleAspectFit
        if let img1 = UIImage(named: image1), let img2 = UIImage(named: image2), let img3 = UIImage(named: image3) {
            flyImage1 = img1
            flyImage2 = img2
            flyImage3 = img3
            currentImage = 1
            self.backgroundColor = UIColor.clearColor()
            self.image = flyImage1
            self.frame = CGRect(x: startPoint.x, y: startPoint.y, width: birdSize, height: birdSize)
            imageView?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.dieY = dieY
            self.addSubview(imageView!)
            originFrame = self.frame
            print("originY: \(originFrame?.origin.y)")
        } else {
            print("configure bird failed")
        }
    }
    
    
    func animate() {
        animateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "changeImage", userInfo: nil, repeats: true)
    }
    
    func start(rootViewController: PlayViewController) {
        birdBehavior.addGravityToItem(self)
        rootViewController.animator.addBehavior(birdBehavior)
        enableDownTimer()
        startObservers()
    }

    func restart() {
        birdBehavior.addGravityToItem(self)
        self.frame = originFrame!
        self.imageView?.transform = CGAffineTransformMakeRotation(0)
        print("y: \(self.frame.origin.y), dieY: \(dieY!)")
        print("originY: \(originFrame?.origin.y)")
        image = flyImage1
        currentImage = 1
        enableDownTimer()
        startObservers()
        animate()
    }
    
    func kill() {
        self.isDead = true
        animateTimer?.invalidate()
        birdBehavior.addGravityToItem(self)
        self.imageView?.transform = CGAffineTransformMakeRotation(CGFloat(0.5 * M_PI))
    }
    
    func enableDownTimer() {
        timer = 0
    }
    
    func startObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "kill", name: "BirdDieNotification", object: nil)
        groundTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "observeGround", userInfo: nil, repeats: true)
    }
    
    func observeGround() {
        if (self.frame.origin.y + self.frame.height) >= dieY {
            birdBehavior.removeGravity(self)
            if isDead == false {
                NSNotificationCenter.defaultCenter().postNotificationName("BirdDieNotification", object: nil, userInfo: nil)
            } else {
                print("already dead")
            }
            intoTheGround()
        }
    }
    
    func changeImage() {
        switch currentImage {
        case 1:
            currentImage++
            image = flyImage2
        case 2:
            currentImage++
            image = flyImage3
        case 3:
            currentImage = 1
            image = flyImage1
        default:
            currentImage = 1
            image = flyImage1
        }
    }
    
    func startTimer() {
        timer += 0.1
        if timer == 0.5 {
            down()
        }
    }
    
    var flyFlag = false
    
    
    func up(byTimes: CGFloat = 0.5) {
        if animateTimer == nil || isDead == true {
            return
        }
        if flyFlag == false {
            AudioPlayer.fly()
            flyFlag = true
        }

        birdBehavior.removeGravity(self)
        
        
        if self.isFlyAnimComplete == false {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - self.frame.height * byTimes, width: self.frame.width, height: self.frame.height)
            return
        }
        
        UIView.animateWithDuration(0.1, animations: {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - self.frame.height * byTimes, width: self.frame.width, height: self.frame.height)
            self.imageView?.transform = CGAffineTransformMakeRotation(CGFloat(-0.25 * M_PI))
            }) {
                complete in
                if complete == false {
                    print("not complete")
                } else {
                    self.isFlyAnimComplete = true
                }
        }
    }
    
    
    func upWithout3DTouch() {
        if animateTimer == nil || isDead == true {
            return
        }
        AudioPlayer.fly()
        birdBehavior.removeGravity(self)
        self.downTimer?.invalidate()
        
        if self.isFlyAnimComplete == false {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - self.frame.height * 2 / 3, width: self.frame.width, height: self.frame.height)
            return
        }
        UIView.animateWithDuration(0.15, animations: {
            self.isFlyAnimComplete = false
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - self.frame.height * 2 / 3, width: self.frame.width, height: self.frame.height)
            self.imageView?.transform = CGAffineTransformMakeRotation(CGFloat(-0.25 * M_PI))
        }) {
            complete in
            if complete == false {
                print("not complete")
                self.downTimer?.invalidate()
            } else {
                self.isFlyAnimComplete = true
                self.downTimer = NSTimer.scheduledTimerWithTimeInterval(0.15, target: self, selector: "down", userInfo: nil, repeats: false)
            }
        }
    }
    
    
    func down() {
        if animateTimer == nil || isDead == true {
            return
        }
        flyFlag = false
        birdBehavior.addGravityToItem(self)
        let animatTimeInterval = Double(1.1 - self.frame.origin.y / self.dieY!)
        print("----------------------------------------")
        print("superViewHeight: \((self.superview?.frame.height)!)")
        print("selfHeight:      \(self.frame.origin.y)")
        print("dieY:            \(self.dieY!)")
        print("percent:         \(animatTimeInterval)")
        print("----------------------------------------")
        UIView.animateWithDuration(0.6, animations: {
            self.imageView?.transform = CGAffineTransformMakeRotation(CGFloat(0.5 * M_PI))
        })
    }
    
    func intoTheGround() {
        var newFrame = self.frame
        newFrame.origin.y = dieY! - newFrame.height / 2
        UIView.animateWithDuration(0.05, animations: {
            self.frame = newFrame
            }) {
                complete in
                if complete {
                    self.end()
                }
        }
    }
    
    func end() {
        animateTimer?.invalidate()
        groundTimer?.invalidate()
        animateTimer = nil
    }
}
