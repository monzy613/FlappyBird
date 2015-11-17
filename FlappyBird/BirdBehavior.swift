//
//  BirdBehavior.swift
//  FlappyBird
//
//  Created by Monzy on 15/11/16.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class BirdBehavior: UIDynamicBehavior {
    let gravity = UIGravityBehavior()
    lazy var push: UIPushBehavior = {
        let laziedPushBehavior = UIPushBehavior(items: [], mode: UIPushBehaviorMode.Instantaneous)
        return laziedPushBehavior
    }()
    
    override init() {
        super.init()
        gravity.magnitude = 0.7
        push.active = true
        addChildBehavior(gravity)
        addChildBehavior(push)
    }
    
    func addPushToItem(item: UIView) {
        push.angle = CGFloat(0.5 * M_PI)
        push.magnitude = 1
    }
    
    func addGravityToItem(item: UIView) {
        dynamicAnimator?.referenceView?.addSubview(item)
        gravity.addItem(item)
    }
    
    func removeGravity(item: UIView) {
        gravity.removeItem(item)
    }
    
    func flyUp(item: UIView) {
        dynamicAnimator?.referenceView?.addSubview(item)
    }
}