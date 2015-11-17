//
//  SaveData.swift
//  FlappyBird
//
//  Created by Monzy on 15/11/17.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class Constants {
    static let MaxScore = "MaxScore"
}

class SaveData: NSObject {
    static private let userDefault = NSUserDefaults.standardUserDefaults()
    
    class func loadMaxScore() -> Int {
        if userDefault.valueForKey(Constants.MaxScore) == nil{
            userDefault.setInteger(0, forKey: Constants.MaxScore)
            return 0
        } else {
            return userDefault.integerForKey(Constants.MaxScore)
        }
    }
    
    class func saveMaxScore(maxScore: Int) {
        userDefault.setInteger(maxScore, forKey: Constants.MaxScore)
    }
}
