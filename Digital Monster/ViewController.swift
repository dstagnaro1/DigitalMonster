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
    @IBOutlet weak var lifeFruit: DragImg!
    
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
        lifeFruit.dropTarget = monsterImage
        
        skull1Img.alpha = DIM_ALPHA
        skull2Img.alpha = DIM_ALPHA
        skull3Img.alpha = DIM_ALPHA
        
        foodImage.alpha = DIM_ALPHA
        heartImage.alpha = DIM_ALPHA
        lifeFruit.alpha = DIM_ALPHA
        
        restartButton.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacterLifeFruit(_:)), name: "onTargetDroppedLifeFruit", object: nil)
        
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
        lifeFruit.alpha = DIM_ALPHA
        lifeFruit.userInteractionEnabled = false
        
        if currentItem == 0 {
            heartSound.play()
        } else {
            biteSound.play()
        }
    }
    
    func itemDroppedOnCharacterLifeFruit(notif: AnyObject) {
        
        current_deaths -= 2
        if current_deaths < 0 {
            current_deaths = 0
        }
        print("current deaths: \(current_deaths)")
        lightUpSkulls()
        currentItem = 0
        
        itemDroppedOnCharacter(notif)
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
         let rand = arc4random_uniform(9)
//        let rand = 8
        
        if rand <= 3 { // if rand == 0
            // heart active, rest inactive
            heartImage.alpha = OPAQUE
            heartImage.userInteractionEnabled = true
            
            lifeFruit.alpha = DIM_ALPHA
            lifeFruit.userInteractionEnabled = false
            
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
        } else if rand <= 7 { // else if rand <= 7
            // food active, rest inactive
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
            
            lifeFruit.alpha = DIM_ALPHA
            lifeFruit.userInteractionEnabled = false

            foodImage.alpha = OPAQUE
            foodImage.userInteractionEnabled = true
            
        } else if rand == 8 {
            // life fruit active, rest inactive
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
            
            lifeFruit.alpha = OPAQUE
            lifeFruit.userInteractionEnabled = true
            
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
        }
        
        if !monsterHappy {
            
            lightUpSkulls()
            
            if current_deaths >= MAX_DEATHS {
                gameOver()
            }
            current_deaths += 1
            skullSound.play()
        }
        currentItem = rand
        monsterHappy = false
    }
    
    func lightUpSkulls() {
        
        if current_deaths == 1 {
            skull1Img.alpha = OPAQUE
            skull2Img.alpha = DIM_ALPHA
            skull3Img.alpha = DIM_ALPHA
        } else if current_deaths == 2 {
            skull1Img.alpha = OPAQUE
            skull2Img.alpha = OPAQUE
            skull3Img.alpha = DIM_ALPHA
        } else if current_deaths >= 3 {
            skull1Img.alpha = OPAQUE
            skull2Img.alpha = OPAQUE
            skull3Img.alpha = OPAQUE
        } else {
            skull1Img.alpha = DIM_ALPHA
            skull2Img.alpha = DIM_ALPHA
            skull3Img.alpha = DIM_ALPHA
        }
    }
    
    func gameOver() {
        
        foodImage.alpha = DIM_ALPHA
        heartImage.alpha = DIM_ALPHA
        lifeFruit.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        heartImage.userInteractionEnabled = false
        lifeFruit.userInteractionEnabled = false
        
        timer.invalidate()
        deathSound.play()
        monsterImage.playDeadAnimation()
        musicPlayer.stop()
        musicPlayer.currentTime = 0.0
        
        restartButton.hidden = false
    }
    
    @IBAction func onRestartTapped(sender: AnyObject) {
        
        current_deaths = 0
        currentItem = 0

        musicPlayer.play()
        
        skull1Img.alpha = DIM_ALPHA
        skull2Img.alpha = DIM_ALPHA
        skull3Img.alpha = DIM_ALPHA
        
        foodImage.alpha = DIM_ALPHA
        heartImage.alpha = DIM_ALPHA
        lifeFruit.alpha = DIM_ALPHA
        
        startTimer()
        monsterHappy = false
        monsterImage.playIdleAnimation()
        
        restartButton.hidden = true
    }
    
}
