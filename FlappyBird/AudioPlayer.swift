//
//  AudioPlayer.swift
//  FlappyBird
//
//  Created by Monzy on 15/11/17.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
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
    var player: AVAudioPlayer?
    
    private override init() {
        super.init()
        wavDic = FileOperator.getWavs()
    }
    
    
    
    func play(wav: Wavs) {
        do {
            self.player = try AVAudioPlayer(contentsOfURL: wavDic[wav.rawValue]!)
        }
        catch {
            print("error: \(error)")
            return
        }
        self.player?.delegate = self
        self.player?.play()
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("finish playing")
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
