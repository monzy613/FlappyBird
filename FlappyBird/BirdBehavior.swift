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
    
    override init() {
        super.init()
        gravity.magnitude = 0.7
        addChildBehavior(gravity)
    }
    
    
    func addGravityToItem(item: UIView) {
        if dynamicAnimator?.referenceView?.subviews.contains(item) == false {
            dynamicAnimator?.referenceView?.addSubview(item)
        }
        gravity.addItem(item)
    }
    
    func removeGravity(item: UIView) {
        gravity.removeItem(item)
    }
    
}