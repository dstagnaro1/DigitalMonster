//
//  ViewController.swift
//  Digital Monster
//
//  Created by Daniel Stagnaro on 6/1/16.
//  Copyright © 2016 Daniel Stagnaro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var monsterImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imgArray = [UIImage]()
        
        for x in 1..<5 {
            let img = UIImage(named: "idle\(x).png")
            imgArray.append(img!)
        }
        
        
        monsterImage.animationImages = imgArray
        monsterImage.animationDuration = 0.8
        monsterImage.animationRepeatCount = 0
        monsterImage.startAnimating()
        
    }


}

