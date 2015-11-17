//
//  PlayViewController.swift
//  FlappyBird
//
//  Created by Monzy on 15/11/16.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController, UIDynamicAnimatorDelegate {

    
    @IBOutlet var scoreViewRootView: UIView!
    var score: Int = 0
    
    var replayButton: FlappyButton?
    @IBOutlet var bird: Bird!
    @IBOutlet var background: AutoScrollingBackground!
    @IBOutlet var tutorialImageView: UIImageView!
    var tutorialImageFrame: CGRect?
    var tutorialImage: UIImage?
    
    var pipeGeneratorTimer: NSTimer?
    
    var scoreView: ScoreView?
    
    lazy var animator: UIDynamicAnimator = {
        let laziedAnimator = UIDynamicAnimator(referenceView: self.view)
        laziedAnimator.delegate = self
        return laziedAnimator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tutorialImageFrame = tutorialImageView.frame
        tutorialImage = tutorialImageView.image
        
        initScoreView()
        bird.configureFlyImage("bird2_0", image2: "bird2_1", image3: "bird2_2", dieY: background.frame.origin.y, startPoint: CGPoint(x: background.frame.height / 2, y: (self.view.frame.height - background.frame.height) / 2))
        bird.animate()
        background.configure(UIImage(named: "land")!)
        background.animate()
        initObserver()
        initReplayButton()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if tutorialImageView != nil {
            tutorialImageView.removeFromSuperview()
            tutorialImageView = nil
            bird.start(self)
            initPipe()
        } else {
            if traitCollection.forceTouchCapability == .Unavailable {
                bird.up()
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if traitCollection.forceTouchCapability == .Available {
            if let touch = touches.first {
                let forceTimes = touch.force / touch.maximumPossibleForce
                if forceTimes > 0.3 {
                    bird.up(forceTimes / 5)
                } else {
                    bird.down()
                }
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        touchesEnded(touches!, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if traitCollection.forceTouchCapability == .Available {
            bird.down()
        }
    }
    
    func initScoreView() {
        if scoreView == nil {
            self.scoreView = ScoreView(width: scoreViewRootView.frame.width / 10, centerPoint: scoreViewRootView.center)
            scoreViewRootView.addSubview(scoreView!)
        } else {
            scoreView?.newScore(0)
        }
    }
    
    func initReplayButton() {
        replayButton = FlappyButton(type: .Custom)
        let playButtonImage = UIImage(named: "button_play")!
        replayButton?.setImage(playButtonImage, forState: .Normal)
        replayButton?.setImage(playButtonImage, forState: .Highlighted)
        let width = playButtonImage.size.width
        let height = playButtonImage.size.height
        self.replayButton!.frame = CGRect(x: self.background.frame.midX - width / 2, y: self.view.frame.height, width: width, height: height)
        self.view.addSubview(replayButton!)
        replayButton!.addTarget(self, action: "replay", forControlEvents: .TouchDown)
    }

    func hideReplayButton() {
        print("hideReplayButton")
        let playButtonImage = replayButton?.imageView?.image
        let width = playButtonImage!.size.width
        let height = playButtonImage!.size.height
        self.replayButton!.frame = CGRect(x: self.background.frame.midX - width / 2, y: self.view.frame.height, width: width, height: height)
    }
    
    func showReplayButton() {
        print("showReplayButton")
        if replayButton == nil {
            return
        }
        let width = replayButton!.frame.width
        let height = replayButton!.frame.height
        UIView.animateWithDuration(0.15, animations: {
            self.replayButton!.frame = CGRect(x: self.background.frame.midX - width / 2, y: self.background.frame.origin.y - height + 8, width: width, height: height)
        })
    }
    
    func initPipe() {
        pipeGeneratorTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "makePipe", userInfo: nil, repeats: true)
    }
    
    func makePipe() {
        //pipe.configure(spaceStartY: CGFloat) spaceStartY: 20 ~ (window.frame.height - background.frame.height)
        //window.frame.height - (pipeUp.frame.height + backgound.frame.height + spaceHeight) ~ pipeDown.frame.height
        let pipe = Pipe()
        view.addSubview(pipe)
        view.bringSubviewToFront(background)
        view.bringSubviewToFront(replayButton!)
        view.bringSubviewToFront(scoreViewRootView)
        pipe.configure(background.frame.height, startX: self.view.frame.width, birdSize: 48, downPipeImage: UIImage(named: "pipe_down")!,
            upPipeImage: UIImage(named: "pipe_up")!)
    }
    
    func initObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "birdDie", name: "BirdDieNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "scoreUp", name: "Score", object: nil)
    }
    
    func scoreUp() {
        score++
        scoreView!.newScore(score)
        print("score: \(score)")
    }
    
    func birdDie() {
        print("bird die")
        pipeGeneratorTimer?.invalidate()
        background.stop()
        bird.die()
        showReplayButton()
    }

    func replay() {
        print("perform replay")
        score = 0
        initScoreView()
        removePipes()
        replayButton?.removeFromSuperview()
        initReplayButton()
        bird.removeFromSuperview()
        bird = nil
        bird = Bird()
        self.view.addSubview(bird)
        bird.configureFlyImage("bird2_0", image2: "bird2_1", image3: "bird2_2", dieY: background.frame.origin.y, startPoint: CGPoint(x: background.frame.height / 2, y: (self.view.frame.height - background.frame.height) / 2))
        background.animate()
        bird.animate()
        
        tutorialImageView = UIImageView(image: tutorialImage ?? nil)
        if tutorialImageFrame != nil {
            tutorialImageView.frame = tutorialImageFrame!
        }
        self.view.addSubview(tutorialImageView)
    }
    
    func removePipes() {
        for subview in view.subviews {
            if subview.isKindOfClass(Pipe) {
                subview.removeFromSuperview()
            }
        }
    }
}
