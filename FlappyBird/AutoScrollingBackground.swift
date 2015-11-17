//
//  AutoScrollingBackground.swift
//  FlappyBird
//
//  Created by Monzy on 15/11/16.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class AutoScrollingBackground: UIView {
    var backgroundImage: UIImage?
    var imageViews = [UIImageView]()
    var animateTimer: NSTimer?
    
    func configure(background: UIImage) {
        backgroundImage = background
        let width = self.frame.width
        let height = self.frame.height
        for i in 0...2 {
            let imgView = UIImageView(frame: CGRect(x: CGFloat(i) * width, y: 0, width: width, height: height))
            imgView.image = backgroundImage
            imageViews.append(imgView)
            self.addSubview(imgView)
        }
        
    }
    
    func animate() {
        for imgView in imageViews {
            let index: Int = imageViews.indexOf(imgView)!
            var newFrame = imgView.frame
            newFrame.origin.x = CGFloat(index) * (newFrame.width)
            imgView.frame = newFrame
        }
        animateTimer?.invalidate()
        animateTimer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: "move", userInfo: nil, repeats: true)
    }
    
    func move() {
        for imgView in imageViews {
            var newFrame = imgView.frame
            newFrame.origin.x -= 2
            imgView.frame = newFrame
            if (imgView.frame.origin.x + imgView.frame.width) <= 0 {
                imgView.frame = CGRect(x: imgView.frame.origin.x + imgView.frame.width * 2, y: 0, width: imgView.frame.width, height: imgView.frame.height)
            }
        }
    }
    
    func stop() {
        animateTimer?.invalidate()
    }
}
