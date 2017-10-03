//
//  ViewController.swift
//  Chess
//
//  Created by Kousei Richeson on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var timer = Timer()
    var menuMusic = AVAudioPlayer()
    
    
    @IBOutlet var bg: UIImageView!
    @IBOutlet var pressAnywhereToStart: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scheduledTimerWithTimeInterval()
        let audioPath01 = Bundle.main.path(forResource: "Halo", ofType: "mp3")
        do{
            try menuMusic = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath01!))
        } catch {
            //error
        }
        menuMusic.prepareToPlay()
        menuMusic.numberOfLoops = -1
        menuMusic.play()
        
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func scheduledTimerWithTimeInterval() {
        
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ViewController.updateCounting), userInfo: nil, repeats: true)
    }
    
    
    var moveRight = true
    var fadeOut = true
    func updateCounting() {
        
        var x = bg.frame.origin.x
        
        if moveRight {
            x = x - 1
            bg.frame = CGRect(x: x, y: bg.frame.origin.y, width: bg.frame.size.width, height: bg.frame.size.height)
        }
        else {
            x = x + 1
            bg.frame = CGRect(x: x, y: bg.frame.origin.y, width: bg.frame.size.width, height: bg.frame.size.height)
        }
        
        if(x == -485){
            moveRight = false
        }
        if(x == 446){
            moveRight = true
        }
    
        print(x)
        
        
        let alpha = pressAnywhereToStart.alpha

        if fadeOut {
            pressAnywhereToStart.alpha = alpha - 0.02
        }
        else {
            pressAnywhereToStart.alpha = alpha + 0.02
        }
        
        if(pressAnywhereToStart.alpha < 0.10){
            fadeOut = false
        }
        if(pressAnywhereToStart.alpha > 0.90){
            fadeOut = true
        }
        
        print(pressAnywhereToStart.alpha)
        
        
    }


}

