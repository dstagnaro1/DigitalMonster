//
//  ViewController.swift
//  Digital Monster
//
//  Created by Daniel Stagnaro on 6/1/16.
//  Copyright © 2016 Daniel Stagnaro. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImage: MonsterImg!
    @IBOutlet weak var heartImage: DragImg!
    @IBOutlet weak var foodImage: DragImg!
    
    @IBOutlet weak var skull1Img: UIImageView!
    @IBOutlet weak var skull2Img: UIImageView!
    @IBOutlet weak var skull3Img: UIImageView!
    
    @IBOutlet weak var restartButton: UIButton!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_DEATHS = 3
    
    var current_deaths = 0
    var timer: NSTimer!
    
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var biteSound: AVAudioPlayer!
    var heartSound: AVAudioPlayer!
    var deathSound: AVAudioPlayer!
    var skullSound: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImage.dropTarget = monsterImage
        heartImage.dropTarget = monsterImage
        
        skull1Img.alpha = DIM_ALPHA
        skull2Img.alpha = DIM_ALPHA
        skull3Img.alpha = DIM_ALPHA
        
        foodImage.alpha = DIM_ALPHA
        heartImage.alpha = DIM_ALPHA
        
        restartButton.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            try biteSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try heartSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try deathSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try skullSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            biteSound.prepareToPlay()
            heartSound.prepareToPlay()
            deathSound.prepareToPlay()
            skullSound.prepareToPlay()
            
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
    }
    
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        heartImage.alpha = DIM_ALPHA
        heartImage.userInteractionEnabled = false
        
        if currentItem == 0 {
            heartSound.play()
        } else {
            biteSound.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        //        foodImage.alpha = DIM_ALPHA
        //        heartImage.alpha = DIM_ALPHA
        //        foodImage.userInteractionEnabled = false
        //        heartImage.userInteractionEnabled = false
        
        let rand = arc4random_uniform(2)
        
        if rand == 0 {
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
            
            heartImage.alpha = OPAQUE
            heartImage.userInteractionEnabled = true
        } else {
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
            
            foodImage.alpha = OPAQUE
            foodImage.userInteractionEnabled = true
        }
        
        if !monsterHappy {
            
            if current_deaths == 1 {
                skull1Img.alpha = OPAQUE
            } else if current_deaths == 2 {
                skull2Img.alpha = OPAQUE
            } else if current_deaths >= 3 {
                skull3Img.alpha = OPAQUE
            } else {
                skull1Img.alpha = DIM_ALPHA
                skull2Img.alpha = DIM_ALPHA
                skull3Img.alpha = DIM_ALPHA
            }
            
            if current_deaths >= MAX_DEATHS {
                gameOver()
            }
            current_deaths += 1
            skullSound.play()
        }
        currentItem = rand
        monsterHappy = false
    }
    
    func gameOver() {
        
        foodImage.alpha = DIM_ALPHA
        heartImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        heartImage.userInteractionEnabled = false 
        
        timer.invalidate()
        deathSound.play()
        monsterImage.playDeadAnimation()
        musicPlayer.stop()
        
        restartButton.hidden = false
    }
    
    @IBAction func onRestartTapped(sender: AnyObject) {
        
        
        current_deaths = 0
        currentItem = 0
        if musicPlayer.playing {
            musicPlayer.stop()
        }
        musicPlayer.play()
        
        skull1Img.alpha = DIM_ALPHA
        skull2Img.alpha = DIM_ALPHA
        skull3Img.alpha = DIM_ALPHA
        
        foodImage.alpha = DIM_ALPHA
        heartImage.alpha = DIM_ALPHA
        
        startTimer()
        monsterHappy = false
        monsterImage.playIdleAnimation()
        
        restartButton.hidden = true
    }
    
}
