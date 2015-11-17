//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var arr = [15, 16, 17, 18, 19, 20]

for i in 1..<100 {
    let num = Int(arc4random() % (21 - 15) + 15)
    if arr.contains(num) == false {
        print("\(num) not contailed")
    }
}


//arc4random() % (max + 1 - min) + min
// random value in range 15 ~ 20
//arc4random() % (20 - 15) + 15
func randomInRange(max: CGFloat, min: CGFloat) -> CGFloat {
    
    let a = UInt32(Float(max - min + 1))
    let b = UInt32(Float(min))
    return CGFloat(arc4random() % a + b)
}

let a = UInt32(Float(CGFloat(20) - CGFloat(0) + 1))

let b = UInt32(Float(CGFloat(0)))

CGFloat(arc4random() % a + b)
randomInRange(20, min: 0)