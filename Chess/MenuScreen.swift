//
//  ViewController.swift
//  Chess
//
//  Created by Kousei Richeson on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit
import AVFoundation

class MenuScreen: UIViewController {

    var timer = Timer()
    var menuMusic = AVAudioPlayer()
    var click3 = AVAudioPlayer()

    
    
    @IBOutlet var previewBG: UIImageView!
    @IBOutlet var pressedAnywhereButton: UIButton!
    @IBOutlet var pressAnywhereToStart: UILabel!
    @IBOutlet var chessPreviewTitle: UIImageView!
    
    @IBOutlet var menuBG: UIImageView!
    @IBOutlet var chessMenuTitle: UIImageView!
    @IBOutlet var onePlayerButton: UIButton!
    @IBOutlet var twoPlayersButton: UIButton!
    @IBOutlet var threeDModel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startMoveBackground()
        //Good job Gilbert!
        let audioPath01 = Bundle.main.path(forResource: "Nocturne", ofType: "mp3")
        do{
            try menuMusic = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath01!))
        } catch {
            //error
        }
        
        let audioPath02 = Bundle.main.path(forResource: "Click3", ofType: "wav")
        do{
            try click3 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath02!))
        } catch {
            //error
        }
        
        click3.prepareToPlay()
        menuMusic.prepareToPlay()
        menuMusic.numberOfLoops = -1
        menuMusic.play()
        
        pressAnywhereToStart.alpha = 0
        menuBG.alpha = 0
        chessMenuTitle.alpha = 0
        onePlayerButton.alpha = 0
        twoPlayersButton.alpha = 0
        threeDModel.alpha = 0
        
        onePlayerButton.isHidden = true
        twoPlayersButton.isHidden = true
        threeDModel.isHidden = true
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "singleplayer" || segue.identifier == "multiplayer" {
            let destVC1 = segue.destination as! GameViewController
            if segue.identifier == "singleplayer" {
                destVC1.isAgainstAI = true
            }
            
            if segue.identifier == "multiplayer" {
                destVC1.isAgainstAI = false
            }
        }
        
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue){
        
    }
    

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func startMoveBackground() {
        
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(MenuScreen.moveBackground), userInfo: nil, repeats: true)
    }
    
    
    var moveRight = true
    var fadeOut = false
    
    func moveBackground() {
        
        var x = previewBG.frame.origin.x
        
        if moveRight {
            x = x - 1
            previewBG.frame = CGRect(x: x, y: previewBG.frame.origin.y, width: previewBG.frame.size.width, height: previewBG.frame.size.height)
        }
        else {
            x = x + 1
            previewBG.frame = CGRect(x: x, y: previewBG.frame.origin.y, width: previewBG.frame.size.width, height: previewBG.frame.size.height)
        }
        
        if(x == -485){
            moveRight = false
        }
        if(x == 446){
            moveRight = true
        }
    
        //print("Preview Picture x-coordinate: \(x)")
        
        
        let alpha = pressAnywhereToStart.alpha

        if fadeOut {
            pressAnywhereToStart.alpha = alpha - 0.02
        }
        else {
            pressAnywhereToStart.alpha = alpha + 0.02
        }
        
        if(pressAnywhereToStart.alpha < 0.00){
            fadeOut = false
        }
        if(pressAnywhereToStart.alpha > 0.90){
            fadeOut = true
        }
        
    }

    
    @IBAction func pressedAnywhere(_ sender: Any) {
        
        timer.invalidate()
        startChangeScreens()
        pressedAnywhereButton.isHidden = true
        onePlayerButton.isHidden = false
        twoPlayersButton.isHidden = false
        threeDModel.isHidden = false

        
    }
    
    
    
    func startChangeScreens() {
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(MenuScreen.changeScreens), userInfo: nil, repeats: true)
    }
    
    var changed = false
    func changeScreens() {
        
        let previewAlpha = previewBG.alpha
        let pressAnywhereAlpha = pressAnywhereToStart.alpha
        let menuAlpha = menuBG.alpha
        
        if (changed == false) {
            previewBG.alpha = previewAlpha - 0.01
            chessPreviewTitle.alpha = previewAlpha - 0.01
            pressAnywhereToStart.alpha = pressAnywhereAlpha - 0.01
            
        }
        else {
            menuBG.alpha = menuAlpha + 0.01
            chessMenuTitle.alpha = menuAlpha + 0.01
            onePlayerButton.alpha = menuAlpha + 0.01
            twoPlayersButton.alpha = menuAlpha + 0.01
            threeDModel.alpha = menuAlpha + 0.01
        }
        
        if(previewBG.alpha < -0.20){
             changed = true
        }
        if(menuBG.alpha > 0.99999){
            timer.invalidate()
        }
        
        //print("Menu's Alpha: \(menuBG.alpha)")
        
    }
    
    @IBAction func onePlayerPressed(_ sender: Any) {
        click3.play()
    }
    
    @IBAction func twoPlayersPressed(_ sender: Any) {
        click3.play()
    }
    
    
    @IBAction func settingsPressed(_ sender: Any) {
        click3.play()
    }
    
}

