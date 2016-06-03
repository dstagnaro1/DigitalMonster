//
//  ViewController.swift
//  Digital Monster
//
//  Created by Daniel Stagnaro on 6/1/16.
//  Copyright © 2016 Daniel Stagnaro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var monsterImage: MonsterImg!
    @IBOutlet weak var heartImage: DragImg!
    @IBOutlet weak var foodImage: DragImg!
    
    @IBOutlet weak var skull1Img: UIImageView!
    @IBOutlet weak var skull2Img: UIImageView!
    @IBOutlet weak var skull3Img: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_DEATHS = 3
    
    var current_deaths = 0
    var timer: NSTimer!
    
    var monsterHappy = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        foodImage.dropTarget = monsterImage
        heartImage.dropTarget = monsterImage
        
        skull1Img.alpha = DIM_ALPHA
        skull2Img.alpha = DIM_ALPHA
        skull3Img.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        
        startTimer()
    }
    
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        print("Item dropped on monster")
        
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        current_deaths += 1
        if !monsterHappy {
            
            if current_deaths == 1 {
                skull1Img.alpha = OPAQUE
                skull2Img.alpha = DIM_ALPHA
            } else if current_deaths == 2 {
                skull2Img.alpha = OPAQUE
                skull3Img.alpha = DIM_ALPHA
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
        
        }
        
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
        
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImage.playDeadAnimation()
    }
    
}

//            skull3Img.alpha = DIM_ALPHA
//            skull1Img.alpha = OPAQUE
//            skull1Img.alpha = OPAQUE
//            skull2Img.alpha = OPAQUE
//        current_deaths += 1

