//
//  ScoreViewTestViewController.swift
//  FlappyBird
//
//  Created by Monzy on 15/11/17.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class ScoreViewTestViewController: UIViewController {
    var scoreView: ScoreView?

    @IBOutlet var numberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scoreView = ScoreView(width: self.view.frame.width / 10, centerPoint: self.view.center)
        self.view.addSubview(scoreView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeScore(sender: UIButton) {
        if let num = Int(numberTextField.text!) {
            scoreView?.newScore(num)
        } else {
            scoreView?.newScore(12)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
