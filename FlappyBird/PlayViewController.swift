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
    var highScoreBoard: HighScoreBoard?
    var scoreBoardSize = CGSize.zero
    @IBOutlet var bird: Bird!
    @IBOutlet var background: AutoScrollingBackground!
    @IBOutlet var tutorialImageView: UIImageView!
    var tutorialImageFrame: CGRect?
    var tutorialImage: UIImage?
    
    var no3DTouchAutoDownTimer: NSTimer?
    var pipeGeneratorTimer: NSTimer?
    var scoreView: ScoreView?
    var birdSize: CGFloat = 48
    
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
        birdSize = background.frame.height * 48 / 125
        bird.configureFlyImage("bird2_0", image2: "bird2_1", image3: "bird2_2", dieY: background.frame.origin.y, startPoint: CGPoint(x: background.frame.height / 2, y: (self.view.frame.height - background.frame.height) / 2), birdSize: birdSize)
        bird.animate()
        background.configure(UIImage(named: "land")!)
        background.animate()
        
        initObserver()
        initGameOverComponents()
        scoreBoardSize = (UIImage(named: ImageNames.HighScoreBoard)?.size)!
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
                no3DTouchAutoDownTimer?.invalidate()
                bird.upWithout3DTouch()
                //no3DTouchAutoDownTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: bird, selector: "down", userInfo: nil, repeats: false)
            }
        }
    }
    
    var isFalling = false
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if traitCollection.forceTouchCapability == .Available {
            if let touch = touches.first {
                let forceTimes = touch.force / touch.maximumPossibleForce
                if forceTimes > 0.3 {
                    isFalling = false
                    bird.up(forceTimes / 5)
                } else {
                    if isFalling == false {
                        bird.down()
                    } else {
                        isFalling = true
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        touchesEnded(touches!, withEvent: event)
        if traitCollection.forceTouchCapability == .Available {
            bird.down()
        }
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
    
    func initGameOverComponents() {
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
        UIView.animateWithDuration(0.35, animations: {
            self.replayButton!.frame = CGRect(x: self.background.frame.midX - width / 2, y: self.background.frame.origin.y - height + 8, width: width, height: height)
        })
    }
    
    func initPipe() {
        //pipeGeneratorTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "makePipe", userInfo: nil, repeats: true)
        makeTwoPipes()
    }
    
    
    func makePipe() {
        //pipe.configure(spaceStartY: CGFloat) spaceStartY: 20 ~ (window.frame.height - background.frame.height)
        //window.frame.height - (pipeUp.frame.height + backgound.frame.height + spaceHeight) ~ pipeDown.frame.height
        let pipe = Pipe()
        view.addSubview(pipe)
        view.bringSubviewToFront(background)
        view.bringSubviewToFront(bird)
        view.bringSubviewToFront(replayButton!)
        view.bringSubviewToFront(scoreViewRootView)
        pipe.configure(background.frame.height, startX: self.view.frame.width, birdSize: birdSize, downPipeImage: UIImage(named: "pipe_down")!,
            upPipeImage: UIImage(named: "pipe_up")!)
    }
    
    func makeTwoPipes() {
        for i in 0...1 {
            let pipe = Pipe()
            view.addSubview(pipe)
            view.bringSubviewToFront(background)
            view.bringSubviewToFront(bird)
            view.bringSubviewToFront(replayButton!)
            view.bringSubviewToFront(scoreViewRootView)
            pipe.configure(background.frame.height, startX: self.view.frame.width + (self.view.frame.width * CGFloat(i)) / 2, birdSize: birdSize, downPipeImage: UIImage(named: "pipe_down")!,
                upPipeImage: UIImage(named: "pipe_up")!)
        }
        
    }
    
    func initObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "birdDie", name: "BirdDieNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "scoreUp", name: "Score", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "makePipe", name: "NewPipe", object: nil)
    }
    
    func scoreUp() {
        score++
        scoreView!.newScore(score)
        AudioPlayer.play(.Point)
    }
    
    func birdDie() {
        print("bird die[player view]")
        AudioPlayer.play(.Hit)
        shineScreen()
        pipeGeneratorTimer?.invalidate()
        background.stop()
        showHighScoreBoard()
    }
    
    func shineScreen() {
        let shineView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        shineView.backgroundColor = UIColor.whiteColor()
        shineView.alpha = 0
        self.view.addSubview(shineView)
        UIView.animateWithDuration(0.1, animations: {
            shineView.alpha = 0.8
            }){
                complete in
                if complete {
                    UIView.animateWithDuration(0.1, animations: {
                        shineView.alpha = 0
                        }) {
                            complete2 in
                            if complete2 {
                                shineView.removeFromSuperview()
                            }
                    }
                }
        }
    }
    
    func showHighScoreBoard() {
        let currentScore = self.score
        let maxScore = SaveData.loadMaxScore()
        if highScoreBoard != nil {
            highScoreBoard?.removeFromSuperview()
            highScoreBoard = nil
        }
        highScoreBoard = HighScoreBoard(_currentScore: currentScore, _maxScore: maxScore, centerPoint: CGPoint(x: self.view.center.x, y: -scoreBoardSize.height))
        self.view.addSubview(highScoreBoard!)
        var newFrame = self.highScoreBoard?.frame
        newFrame?.origin.x = self.view.center.x - (newFrame?.width)! / 2
        newFrame?.origin.y = self.view.center.y - (newFrame?.height)! / 2
        UIView.animateWithDuration(0.7, animations: {
            self.highScoreBoard?.frame = newFrame!
            }){
                complete in
                //show button
                AudioPlayer.play(.Scroll)
                self.showReplayButton()
        }
    }
    
    func dismissScoreBoard() {
        highScoreBoard?.removeFromSuperview()
        highScoreBoard = nil
    }

    func replay() {
        print("perform replay")
        score = 0
        initScoreView()
        removePipes()
        replayButton?.removeFromSuperview()
        initGameOverComponents()
        dismissScoreBoard()
        bird.removeFromSuperview()
        bird = nil
        bird = Bird()
        self.view.addSubview(bird)
        bird.configureFlyImage("bird2_0", image2: "bird2_1", image3: "bird2_2", dieY: background.frame.origin.y, startPoint: CGPoint(x: background.frame.height / 2, y: (self.view.frame.height - background.frame.height) / 2), birdSize: birdSize)
        background.animate()
        bird.animate()
        tutorialImageView = UIImageView(image: tutorialImage ?? nil)
        tutorialImageView.frame = CGRect(x: self.view.center.x - (tutorialImage?.size.width)! / 2, y: self.view.center.y - (tutorialImage?.size.height)! / 2, width: (tutorialImage?.size.width)!, height: (tutorialImage?.size.height)!)
        self.animator.removeAllBehaviors()
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
