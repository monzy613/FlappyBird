//
//  HighScoreBoard.swift
//  FlappyBird
//
//  Created by Monzy on 15/11/17.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit


class ImageNames {
    static let HighScoreBoard = "score_panel"
    static let CuMedal = "medals_3"
    static let AgMedal = "medals_2"
    static let AuMedal = "medals_1"
    static let PtMedal = "medals_0"
    static let NewScore = "new"
}

class HighScoreBoard: UIView {
    
    var currentScoreView: ScoreView?
    var maxScoreView: ScoreView?
    var boardImageView = UIImageView(image: UIImage(named: ImageNames.HighScoreBoard))
    var medalImageView: UIImageView?
    var newScoreImageView: UIImageView?
    
    init(_currentScore: Int, _maxScore: Int, centerPoint: CGPoint) {
        super.init(frame: CGRect.zero)
        let width = boardImageView.image?.size.width
        let height = boardImageView.image?.size.height
        //init background
        boardImageView.frame = CGRect(x: 0, y: 0, width: width!, height: height!)
        self.addSubview(boardImageView)
        
        let currentScore = _currentScore
        var maxScore = _maxScore
        if currentScore > maxScore {
            maxScore = currentScore
            //init newScoreImageView
            newScoreImageView = UIImageView(image: UIImage(named: ImageNames.NewScore))
            let newScoreImageSize = newScoreImageView?.image?.size
            newScoreImageView?.frame = CGRect(x: (155 - (newScoreImageSize?.width)! / 2), y: (67 - (newScoreImageSize?.height)! / 2), width: (newScoreImageSize?.width)!, height: (newScoreImageSize?.height)!)
            print("new Score: \(newScoreImageView!.frame)")
            self.addSubview(newScoreImageView!)
            SaveData.saveMaxScore(currentScore)
        }
        
        
        //init two scoreViews
        let numWidth: CGFloat = 14
        currentScoreView = ScoreView(withScore: currentScore, width: numWidth, rightUpPoint: CGPoint(x: 211, y: 31))
        maxScoreView = ScoreView(withScore: maxScore, width: numWidth, rightUpPoint: CGPoint(x: 211, y: 74))
        self.addSubview(currentScoreView!)
        self.addSubview(maxScoreView!)
        
        
        //init medalImageView
        func setMedalFrame() {
            if medalImageView == nil {
                return
            }
            let mWidth = medalImageView?.image?.size.width
            let mHeight = medalImageView?.image?.size.height
            medalImageView?.frame = CGRect(x: 53.5 - mWidth! / 2, y: 67 - mHeight! / 2, width: mWidth!, height: mHeight!)
            self.addSubview(medalImageView!)
        }
        switch currentScore {
        case 0...9:
            break
        case 10...19:
            medalImageView = UIImageView(image: UIImage(named: ImageNames.CuMedal))
        case 20...29:
            medalImageView = UIImageView(image: UIImage(named: ImageNames.AgMedal))
        case 30...39:
            medalImageView = UIImageView(image: UIImage(named: ImageNames.AuMedal))
        default:
            medalImageView = UIImageView(image: UIImage(named: ImageNames.PtMedal))
        }
        setMedalFrame()
        
        self.backgroundColor = UIColor.clearColor()
        self.frame = CGRect(x: centerPoint.x - width! / 2, y: centerPoint.y - height! / 2, width: width!, height: height!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
