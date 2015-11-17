//
//  MainViewController.swift
//  FlappyBird
//
//  Created by Monzy on 15/11/16.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var background: AutoScrollingBackground!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        background.configure(UIImage(named: "land")!)
        background.animate()
    }
    
    @IBAction func play(sender: UIButton) {
        print("button pressed")
        AudioPlayer.getInstance().play(.Scroll)
        performSegueWithIdentifier("PlaySegue", sender: sender)
    }
    
}
