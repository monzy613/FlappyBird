//: Playground - noun: a place where people can play

import UIKit
/*
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
*/
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

let number = 9876
let nod = numberOfDigits(0)

func power(num: Int, pow: Int) -> Int {
    var result = 1
    for i in 0..<pow {
        result *= num
    }
    return result
}

func getEachDigit(number: Int) -> [Int] {
    var eachDigits = [Int]()
    let nod = numberOfDigits(number)
    for i in 1...nod {
        let i = nod - i + 1
        eachDigits.append((number % power(10, pow: i) - number % power(10, pow: i - 1)) / power(10, pow: i - 1))
    }
    
    return eachDigits
}

for i in 1...nod {
    print((number % power(10, pow: i) - number % power(10, pow: i - 1)) / power(10, pow: i - 1))
}

getEachDigit(111123)

Int("xx")