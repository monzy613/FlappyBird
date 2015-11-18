//
//  AudioPlayer.swift
//  FlappyBird
//
//  Created by Monzy on 15/11/17.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayer: NSObject {
    static private var instance: AudioPlayer?
    
    static func getInstance() -> AudioPlayer {
        if AudioPlayer.instance == nil {
            AudioPlayer.instance = AudioPlayer()
        }
        return AudioPlayer.instance!
    }
    
    enum Wavs: String {
        case Die = "die"
        case Fly = "fly"
        case Scroll = "scroll"
        case Point = "point"
        case Hit = "hit"
    }
    
    var wavDic = [String: NSURL]()
    private var player: AVAudioPlayer?
    private var flyPlayers = [AVAudioPlayer]()
    
    private override init() {
        super.init()
        wavDic = FileOperator.getWavs()
        for _ in 0...7 {
            do {
                let tmpFly = try AVAudioPlayer(contentsOfURL: wavDic[Wavs.Fly.rawValue]!)
                flyPlayers.append(tmpFly)
            } catch {print("error: \(error)")}
        }
    }
    
    
    func play(wav: Wavs) {
        do {
            self.player = try AVAudioPlayer(contentsOfURL: wavDic[wav.rawValue]!)
            self.player?.numberOfLoops = 0
            //self.player?.delegate = self
        }
        catch {
            print("error: \(error)")
            return
        }
        self.player?.play()
    }
    
    static func fly() {
        for fp in AudioPlayer.getInstance().flyPlayers {
            if fp.playing == false {
                fp.play()
                return
            }
        }
        print("[noneAvailable]")
    }
    
    static func play(wav: Wavs) {
        getInstance().play(wav)
    }
    
}

class FileOperator: NSObject {
    class func getWavs() -> [String: NSURL]{
        var wavDic = [String: NSURL]()
        for url in NSBundle.mainBundle().URLsForResourcesWithExtension("wav", subdirectory: nil) ?? []{
            let components = url.pathComponents ?? []
            let key = components[components.count - 1].componentsSeparatedByString(".")[0]
            wavDic[key] = url
        }
        return wavDic
    }
}
