//
//  ScoreView.swift
//  FlappyBird
//
//  Created by Monzy on 15/11/17.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class ScoreView: UIView {
    var imageViews = [UIImageView]()
    var digits = [UIImage]()
    var centerPoint = CGPoint.zero
    var width: CGFloat = 0
    var score: Int = 0
    var height: CGFloat {
        get {
            return width * 11 / 6
        }
    }
    var space: CGFloat {
        get {
            return width / 10
        }
    }
    
    //width6, height11
    init(width: CGFloat, centerPoint: CGPoint) {
        super.init(frame: CGRect.zero)
        self.width = width
        self.centerPoint = centerPoint
        for i in 0...9 {
            digits.append(UIImage(named: "font_0\(48 + i)")!)
        }
        let imgView = UIImageView(image: digits[0])
        imgView.contentMode = .ScaleAspectFit
        imgView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        imageViews.append(imgView)
        self.addSubview(imgView)
        self.frame = CGRect(x: centerPoint.x - width / 2, y: centerPoint.y - height / 2, width: width, height: height)
    }
    
    convenience init(withScore: Int, width: CGFloat, rightUpPoint: CGPoint) {
        self.init(width: width, centerPoint: rightUpPoint)
        newScore(withScore)
        let viewWidth = self.frame.width
        let viewHeight = self.frame.height
        self.frame = CGRect(x: rightUpPoint.x - viewWidth, y: rightUpPoint.y, width: viewWidth, height: viewHeight)
    }
    
    //space 1
    
    //Mark changeScore
    func newScore(newScore: Int) {
        let nod = numberOfDigits(newScore)
        let eachDigits = getEachDigit(newScore)
        if numberOfDigits(self.score) == nod {
            print("same digits")
            for (index, imgView) in imageViews.enumerate() {
                imgView.image = digits[eachDigits[index]]
            }
        } else {
            print("different digits: old \(numberOfDigits(self.score)), new: \(nod)")
            emptySelf()
            for i in 0..<nod {
                let imgView = UIImageView(image: digits[eachDigits[i]])
                imgView.contentMode = .ScaleAspectFit
                imgView.frame = CGRect(x: (width + space) * CGFloat(i), y: 0, width: width, height: height)
                imageViews.append(imgView)
                self.addSubview(imgView)
            }
            let viewWidth = CGFloat(nod) * width + space * CGFloat(nod - 1)
            let viewHeight = height
            self.frame = CGRect(x: centerPoint.x - viewWidth / 2, y: centerPoint.y - viewHeight / 2, width: viewWidth, height: viewHeight)
        }
        self.score = newScore
    }
    
    func emptySelf() {
        for imgView in imageViews {
            imgView.removeFromSuperview()
        }
        imageViews.removeAll()
    }
    
    func numberOfDigits(number: Int) -> Int {
        if number == 0 {
            return 1
        }
        var sum = 0
        var num = number
        while num > 0 {
            sum++
            num /= 10
        }
        return sum
    }
    
    func power(num: Int, pow: Int) -> Int {
        var result = 1
        for _ in 0..<pow {
            result *= num
        }
        return result
    }
    
    //Mark eachDigit
    //e.g. 1234 -> [1, 2, 3, 4]
    func getEachDigit(number: Int) -> [Int] {
        var eachDigits = [Int]()
        let nod = numberOfDigits(number)
        for i in 1...nod {
            let i = nod - i + 1
            eachDigits.append((number % power(10, pow: i) - number % power(10, pow: i - 1)) / power(10, pow: i - 1))
        }
        
        return eachDigits
    }
    
    
    func scoreUp() {
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
