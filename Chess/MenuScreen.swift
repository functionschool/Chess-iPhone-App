//
//  ViewController.swift
//  Chess
//
//  Created by Kousei Richeson & Gilbert Carrillo  on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

//main menu screen


import UIKit
import AVFoundation

class MenuScreen: UIViewController {

    var timer = Timer()
    var menuMusic = AVAudioPlayer()

    
    
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

        startMoveBackground()//start up animation
        
        //background music inside app
        let audioPath01 = Bundle.main.path(forResource: "Halo", ofType: "mp3")
        do{
            try menuMusic = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath01!))
        } catch {
            //error
        }
        
        //constantly play music
        menuMusic.prepareToPlay()
        menuMusic.numberOfLoops = -1
        menuMusic.play()
        
        pressAnywhereToStart.alpha = 0 //transition to main menu after start up animation
        menuBG.alpha = 0
        chessMenuTitle.alpha = 0
        onePlayerButton.alpha = 0
        twoPlayersButton.alpha = 0
        threeDModel.alpha = 0
        
       /*main menu buttons*/
        onePlayerButton.isHidden = true
        twoPlayersButton.isHidden = true
        threeDModel.isHidden = true
        
    }

    
     /*  set up destination after main menu button is pressed  */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "singleplayer" || segue.identifier == "multiplayer" {
            let destVC1 = segue.destination as! GameScreen
           
             /* check if user selected singleplayer, to play against ai */
            if segue.identifier == "singleplayer" {
                destVC1.isAgainstAI = true
            }
            
             /* check if user selected multiplayer */
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
    
    /*
     function startMoveBackground:
     this function automatically displays the chess logo and animation,
      once the application starts
     */
    func startMoveBackground() {
        
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(MenuScreen.moveBackground), userInfo: nil, repeats: true)
    }
    
    
    var moveRight = true
    var fadeOut = false
    /*
     function startMoveBackground:
     this function automatically displays the chess logo and animation,
     until user presses on the screen to continue
     */
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

    /*
     function presssedAnywhere:
     this function waits until the user presses on the screen,
     to transition into the next screen
    */
    @IBAction func pressedAnywhere(_ sender: Any) {
        
        timer.invalidate()
        startChangeScreens()
        pressedAnywhereButton.isHidden = true
        onePlayerButton.isHidden = false
        twoPlayersButton.isHidden = false
        threeDModel.isHidden = false

        
    }
    
    
    /*
     function startChangeScrens:
     this function changes screens after func pressedAnywhere
     */
    func startChangeScreens() {
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(MenuScreen.changeScreens), userInfo: nil, repeats: true)
    }
    
    var changed = false  //check if the screen has changed
    func changeScreens() {
        
        let previewAlpha = previewBG.alpha
        let pressAnywhereAlpha = pressAnywhereToStart.alpha
        let menuAlpha = menuBG.alpha
        
        
        //check to see if the app has already changed screens
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


}

