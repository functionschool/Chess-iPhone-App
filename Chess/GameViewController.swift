//
//  GameViewController.swift
//  test
//
//
//  Created by George Torres  on 10/3/17.
//  All rights reserved.
//

//

/*
 Game View Controller for the 3D model
 
 */

import UIKit
import QuartzCore
import AVFoundation
import SceneKit
let originX:Float = 185.25
let originY:Float = 118
let originZ:Float = 28.4
let distance:Float = 13.98
let hOriginX:Float = 182.314
let hOriginY:Float = 117.5
let hOriginZ:Float = 31.681
var first: Bool = true
var Current: SCNNode!
var mainScene:SCNScene!
var board:[[String]] = []
var place:[[SCNNode]] = []
var cameraNode: SCNNode!
class GameViewController: UIViewController {
//    @IBOutlet var panGesture: UIPanGestureRecognizer!
    var myChessGame: ChessGame3D!
    var textOverlay: TextOverlay!
    var isAgainstAI: Bool!
    var timer = Timer()
    var click1 = AVAudioPlayer()
    var click2 = AVAudioPlayer()
    var slide = AVAudioPlayer()
    var previousLoaction: CGPoint = .zero
    var cameraPosition: SCNVector3? = nil
    var cameraAngle: SCNVector3? = nil
    var movement: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //Import the models
        
        mainScene = createMainScene()
       createCamera()
        cameraNode = mainScene.rootNode.childNode(withName: "skp_camera_Last_Saved_SketchUp_View", recursively: true)
        cameraNode?.camera?.zFar = 6000
        let sceneView = self.view as! SCNView
        //Set scene to the one we created
        sceneView.scene = mainScene
        sceneView.showsStatistics = false
        sceneView.allowsCameraControl = false
        setupLighting(scene: mainScene)
        //Add a floor
        mainScene!.rootNode.addChildNode(createFloorNode())
        //  Super impose text over screen
        sceneView.overlaySKScene = TextOverlay(size: view.frame.size)
        textOverlay = sceneView.overlaySKScene as! TextOverlay
        myChessGame = ChessGame3D.init(viewController: self)
        myChessGame.SetBoard(rootNode: (mainScene?.rootNode)!)//Set up the grid for the board
        //    Handle taps
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action:
            
            #selector(moveCamera(usingGestureRecognizer:)))
        sceneView.addGestureRecognizer(panGesture)
        
        let audioPath01 = Bundle.main.path(forResource: "Click1", ofType: "wav")
        do{
            try click1 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath01!))
        } catch {
            //error
        }
        click1.prepareToPlay()
        
        let audioPath02 = Bundle.main.path(forResource: "Click2", ofType: "wav")
        do{
            try click2 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath02!))
        } catch {
            //error
        }
        click2.prepareToPlay()
        
        let audioPath03 = Bundle.main.path(forResource: "Slide", ofType: "wav")
        do{
            try slide = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath03!))
        } catch {
            //error
        }
        slide.prepareToPlay()
        
        
    }
    
    func createMainScene() -> SCNScene {
        
        let mainScene = SCNScene(named: "art.scnassets/chesstable.dae")
        
        //Load in the top row, on the black side
        //  print(SCNScene(named: "art.scnassets/chesstable.dae")?.rootNode.name!)
        //  myChessGame.SetBoard(rootNode: (mainScene?.rootNode)!)
        
        return mainScene!
    }
    func createFloorNode() -> SCNNode {
        let floorNode = SCNNode()
        let floor = SCNFloor()
        floor.reflectivity = 0
        floorNode.geometry = floor
        floorNode.geometry?.firstMaterial?.diffuse.contents = "floor"
        return floorNode
    }
    
    
    
    func setupLighting(scene:SCNScene){
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light!.type = SCNLight.LightType.ambient
        ambientLight.light!.color = UIColor.white
        scene.rootNode.addChildNode(ambientLight)
        
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.light!.castsShadow = true
        lightNode.light!.color = UIColor(red: 1 ,green: 1,blue: 0.85, alpha: 1    )
        lightNode.position = SCNVector3Make(0, 400, 0)
        lightNode.light!.shadowColor = UIColor.black
        scene.rootNode.addChildNode(lightNode)
    }
    
    func createCamera(){
        //position 1 160.838 237.945 -208.809 2.52834 -0.0076284 3.14159
        //position 2
        //position 3 160.838
        //position 4
        //psoition 5
        let cameraNode = mainScene.rootNode.childNode(withName: "skp_camera_Last_Saved_SketchUp_View", recursively: true)
        cameraNode?.camera?.zFar = 6000
        cameraNode?.position.x = 140
        cameraNode?.position.y = 240
        cameraNode?.position.z = -142
        cameraNode?.eulerAngles.x = 2.3
        cameraNode?.eulerAngles.y = -0.0076
        cameraNode?.eulerAngles.z = 3.14159
        cameraNode?.rotation.x = 0.00115949
        cameraNode?.rotation.y = 0.912763
        cameraNode?.rotation.z = 0.408487
//        cameraNode?.(target: mainScene.rootNode.childNode(withName: "group_0", recursively: true))
//        cameraNode?.position.x = 140
//        cameraNode?.position.y = 240
//        cameraNode?.position.z = 95.2144
//        cameraNode?.eulerAngles.x = -0.819961
//        cameraNode?.eulerAngles.y = 0.011527
//        cameraNode?.eulerAngles.z = -0.00896321
//        cameraNode?.rotation.x = -0.999832
//        cameraNode?.rotation.y = 0.0177412
//        cameraNode?.rotation.z = -0.00454787
        cameraPosition = cameraNode?.position
        cameraAngle = cameraNode?.eulerAngles


    }
    
    
    func changeCamera(){

        let sceneView = self.view as! SCNView
        

        //reset stuff
        sceneView.backgroundColor = UIColor.black
        sceneView.alpha = 1
        isFadingOut = true
        startFadeNumber = 0
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.animateCamera), userInfo: nil, repeats: true)


    }
    
    var isFadingOut = true
    var startFadeNumber = 0
    func animateCamera() {
        
        let timeIncrementer: CGFloat = 0.02
        let sceneView = self.view as! SCNView

        startFadeNumber = startFadeNumber + 1
        
        if(startFadeNumber >= 120) {
        
            if(isFadingOut == true) {
                sceneView.alpha = sceneView.alpha - timeIncrementer
                
                if(sceneView.alpha <= 0) {
                    print(myChessGame.whiteTurn)
                    if(myChessGame.whiteTurn){
                        cameraNode?.position.x = 140
                        cameraNode?.position.y = 240
                        cameraNode?.position.z = -142
                        cameraNode?.eulerAngles.x = 2.3
                        cameraNode?.eulerAngles.y = -0.0076
                        cameraNode?.eulerAngles.z = 3.14159
                        cameraNode?.rotation.x = 0.00115949
                        cameraNode?.rotation.y = 0.912763
                        cameraNode?.rotation.z = 0.408487
                    }
                    else{
                        cameraNode?.position.x = 140
                        cameraNode?.position.y = 240
                        cameraNode?.position.z = 95.2144
                        cameraNode?.eulerAngles.x = -0.819961
                        cameraNode?.eulerAngles.y = 0.011527
                        cameraNode?.eulerAngles.z = -0.00896321
                        
                        cameraNode?.rotation.x = -0.999832
                        cameraNode?.rotation.y = 0.0177412
                        cameraNode?.rotation.z = -0.00454787
                    }
                    isFadingOut = false

                }
                
            }
            
            else{
                
                sceneView.alpha = sceneView.alpha + timeIncrementer
            
                if(sceneView.alpha > 0.9999999){
                    timer.invalidate()
                }
            }
            
        }
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer){
        print("position",cameraNode.position.x, cameraNode.position.y, cameraNode.position.z)
       print("rotation",cameraNode.rotation.x , cameraNode.rotation.y, cameraNode.rotation.z)
        print("angle",cameraNode.eulerAngles.x , cameraNode.eulerAngles.y, cameraNode.eulerAngles.z)
        let sceneView = self.view as! SCNView
        
        //Get location of tap
        let p = gestureRecognize.location(in: sceneView)
        print(p)
//        //Check for return button push
//        if ((p.x>0&&p.x<50) && (p.y>00&&p.y<20)){
//            self.myChessGame.theChessBoard.r0 = []
//            self.myChessGame.theChessBoard.r1 = []
//            self.myChessGame.theChessBoard.r2 = []
//            self.myChessGame.theChessBoard.r3 = []
//            self.myChessGame.theChessBoard.r4 = []
//            self.myChessGame.theChessBoard.r5 = []
//            self.myChessGame.theChessBoard.r6 = []
//            self.myChessGame.theChessBoard.r7 = []
//            place = []
//            self.dismiss(animated: true, completion: nil)
//        }
    
        //Insure object was tapped
        let hitResults = sceneView.hitTest(p, options: [SCNHitTestOption.searchMode: 1, SCNHitTestOption.boundingBoxOnly: 0])
        let button = textOverlay.convertPoint(fromView: p)
        let hitButton = textOverlay.nodes(at: button)
        var c: Int = 0
        var resultchild: AnyObject
        if(hitButton.count > 0){
            pauseScreen()
        }
        print(hitResults.count)
                if(first){
                    while hitResults.count > c {
            //Check if first screen tap
            print("I'm back")
                print("Kill me")
                resultchild = hitResults[c]
                if resultchild.node.parent == mainScene.rootNode{
                    return
                }
//                var result = resultchild.node
                print("I'm just here")
                if(myChessGame.validFirstTap(result: resultchild.node)){
                    print("First tap")
                    click1.play()
                    first = false
                    //Set pointer to piece so we can move it later
                    var index = myChessGame.theChessBoard.getIndex(objectToFind:  resultchild.node)
                    Current = place[index[0]][index[1]]
                    let moveIndex = myChessGame.getArrayOfPossibleMoves(piece: Current)
                    var counter = 0
                    while counter < moveIndex.count{
                        let Scene = SCNScene(named: "art.scnassets/Highlights.dae")
                        if( place[moveIndex[counter][0]][moveIndex[counter][1]] == mainScene.rootNode){
                            let node = Scene?.rootNode.childNode(withName: "Highlight_Moves", recursively: true)
                            node?.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                            mainScene.rootNode.addChildNode(node!)
                            node?.position.x = 182.314 - distance * Float(moveIndex[counter][1])
                            node?.position.y = 117.5
                            node?.position.z = 31.681 - distance * Float(moveIndex[counter][0])
                        }
                        else {
                            let node = Scene?.rootNode.childNode(withName: "Highlight_Check", recursively: true)
                            node?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                            mainScene.rootNode.addChildNode(node!)
                            node?.position.x = 182.314 - distance * Float(moveIndex[counter][1])
                            node?.position.y = 117.5
                            node?.position.z = 31.681 - distance * Float(moveIndex[counter][0])
                        }
                        counter += 1
                    }
                    return
                }
                else{
                    if(resultchild.node.parent?.name! == "group_0"){
                        return
                    }
                    print("wrong turn")
                }
             c += 1
            }
                }
            
            else {//If second tap
                //Reset tap count
                while hitResults.count > c {
            deleteHightLights()
                    print("What up man", c)
                    first = true
                    let resultchild: AnyObject = hitResults[c]
                    c += 1
                    if (resultchild.node == mainScene.rootNode) || resultchild.node.name == nil{
                        print("continue")
                    continue
                    }
                let vaildMove = myChessGame.move(resultchild: resultchild.node)
                
                //check if game's over
                if myChessGame.isGameOver(){
                    displayWinner()
                    return
                }
                //check if the pawn should be promoted
                if shouldPromotePawn(){
                    promptForPawnPromotion()
                }
                else if (vaildMove){
                    print("here")
                    click2.play()
                    slide.play()
                    resumeGame() //dont prompt for pawn promotion if not possible
                    return
                }
                    print(resultchild.node.name!)
              if (resultchild.node.parent?.name! == "group_0") {
                    return
                }
               
        }
        
        }
    }
    func deleteHightLights(){
        while (mainScene.rootNode.childNode(withName: "Highlight", recursively: true) != nil) {
            mainScene.rootNode.childNode(withName: "Highlight", recursively: true)?.removeFromParentNode()
        }
        while (mainScene.rootNode.childNode(withName: "Highlight_Moves", recursively: true) != nil){
            mainScene.rootNode.childNode(withName: "Highlight_Moves", recursively: true)?.removeFromParentNode()
        }
        while (mainScene.rootNode.childNode(withName: "Highlight_Check", recursively: true) != nil){
            mainScene.rootNode.childNode(withName: "Highlight_Check", recursively: true)?.removeFromParentNode()
        }
    }
    
    func resumeGame(){
        //display checks if any
     //   displayCheckFunction()
        
        //display turn on screen
        //textOverlay.updateTurnOnScreen(whiteTurn: myChessGame.whiteTurn)
        changeCamera()
        //make AI move, if necessary
        if isAgainstAI == true && !myChessGame.whiteTurn{
            myChessGame.makeAIMove()
            print("AI: -----------------")
            
            //check to see if the game has ended,
            //if so display the winner
            if myChessGame.isGameOver() {
                displayWinner()
                return
            }
            
            if shouldPromotePawn(){
                myChessGame.promote(pawnToBePromoted: Current, into: "Queen")
            }
            
            //displayCheckFunction()
            
           // textOverlay.updateTurnOnScreen(whiteTurn: myChessGame.whiteTurn)
        }
    }
    
    //prompt pawn for promotion func
    //notifies user that pawn can be promoted, and displays an alert
    func promptForPawnPromotion(){
        let pawnToPromote = Current
        
        let box = UIAlertController(title: "Pawn promotion", message: "Choose Piece", preferredStyle: UIAlertControllerStyle.alert)
        //ask to promote queen
        box.addAction(UIAlertAction(title: "Queen", style: UIAlertActionStyle.default, handler: { action in
            self.myChessGame.promote(pawnToBePromoted: pawnToPromote!, into: action.title!)
            self.resumeGame()
        }))
        //ask to promote knight
        box.addAction(UIAlertAction(title: "Knight", style: UIAlertActionStyle.default, handler: { action in
            self.myChessGame.promote(pawnToBePromoted: pawnToPromote!, into: action.title!)
            self.resumeGame()
        }))
        //ask to promote rook
        box.addAction(UIAlertAction(title: "Rook", style: UIAlertActionStyle.default, handler: { action in
            self.myChessGame.promote(pawnToBePromoted: pawnToPromote!, into: action.title!)
            self.resumeGame()
        }))
        //ask to promote bishop
        box.addAction(UIAlertAction(title: "Bishop", style: UIAlertActionStyle.default, handler: { action in
            self.myChessGame.promote(pawnToBePromoted: pawnToPromote!, into: action.title!)
            self.resumeGame()
        }))
        
        self.present(box, animated: true, completion: nil)
        
    }
    
    //check to see if pawn can be promoted
    func shouldPromotePawn() -> Bool {
        let index = myChessGame.theChessBoard.getIndex(objectToFind: Current)
        if(myChessGame.isPawn(piece: Current.name!)){
            if(myChessGame.isWhite(Piece: Current)){
                if(index[0] == 0){
                    return true
                }
            }
            else{
                if(index[0] == 7){
                    return true
                }
            }
        }
        return false
    }
    
    //check to see if player is in check
//    func displayCheckFunction(){
//        let playerChecked = myChessGame.getPlayerChecked()
//
//        //display a message that player is checked, if elegible
//        if playerChecked != nil {
//            textOverlay.display(text: playerChecked! + " is in check!")
//        }
//        else {
//            textOverlay.display(text: "nothing")
//        }
//    }
    
    //func displayWinner
    //this function pops up a box and lets the user
    //know that the game has ended.
    //It displays the winner and asks the user if they would
    //like to rematch or return to the main menu
    func displayWinner(){
        
        //display a game over message
        let box = UIAlertController(title: "Game Over", message: "\(myChessGame.winner!) wins", preferredStyle: UIAlertControllerStyle.alert)
        //display a back to main meny button
        box.addAction(UIAlertAction(title: "Back to main menu", style: UIAlertActionStyle.default, handler: { action in self.performSegue(withIdentifier: "backToMainMenu", sender: self) }))
        //display rematch button
        box.addAction(UIAlertAction(title: "Rematch", style: UIAlertActionStyle.default, handler: {
            action in
            
            //clear screen and board matrix
            for row in 0..<8 {
                for col in 0..<8 {
                    let removePiece = place[row][col]
                    if removePiece != mainScene!.rootNode {
                        removePiece.removeFromParentNode()
                    }
                }
            }
            
            //create new game
            self.myChessGame.theChessBoard.r0 = []
            self.myChessGame.theChessBoard.r1 = []
            self.myChessGame.theChessBoard.r2 = []
            self.myChessGame.theChessBoard.r3 = []
            self.myChessGame.theChessBoard.r4 = []
            self.myChessGame.theChessBoard.r5 = []
            self.myChessGame.theChessBoard.r6 = []
            self.myChessGame.theChessBoard.r7 = []
            place = []
            self.myChessGame = ChessGame3D(viewController: self)
            self.myChessGame.SetBoard(rootNode: mainScene!.rootNode)
            
            //update labels with game status
            //    self.updateTurnOnScreen()
            //self.displayCheck.text = nil
        }))
        
        self.present(box, animated: true, completion: nil)
        
    }
     @objc func moveCamera(usingGestureRecognizer gestureRecognizer: UIPanGestureRecognizer) {

        switch gestureRecognizer.state{
        case .began:
                    print("here")
            cameraNode.position = cameraPosition!
            cameraNode.eulerAngles = cameraAngle!
            cameraPosition = cameraNode.position
            cameraAngle = cameraNode.eulerAngles
            self.previousLoaction =  .zero
        case .changed:

            let previous = self.previousLoaction
            let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
            let translationDelta = CGPoint(x:translation.x - previous.x, y:translation.y - previous.y)
            let yScalar = Float(translationDelta.x / self.view.bounds.size.width)
            let xScalar = Float(translationDelta.y / self.view.bounds.size.width)
            if(cameraNode.position.x + yScalar*1.5 < 245 && cameraNode.position.x + yScalar*1.5 > 38){
            cameraNode.position.x = cameraNode.position.x + yScalar*1.5
            }
            if(cameraNode.position.y + xScalar*2 - abs(yScalar) > 138 && cameraNode.position.y + xScalar*2 - abs(yScalar) < 330){
            cameraNode.position.y = cameraNode.position.y + xScalar*2 - abs(yScalar)
            }
            if(cameraNode.eulerAngles.y + yScalar/60 > -1.5 && cameraNode.eulerAngles.y + yScalar/60 < 1.5){
            cameraNode.eulerAngles.y = cameraNode.eulerAngles.y + yScalar/60
            }
            if(myChessGame.whiteTurn){
                if(cameraNode.position.z + xScalar*2.5 + abs(yScalar) > -160 && cameraNode.position.z + xScalar*2.5 + abs(yScalar) < -33){
                cameraNode.position.z = cameraNode.position.z + xScalar*2.5 + abs(yScalar)
                }
                if(cameraNode.eulerAngles.x - xScalar/60 + abs(yScalar/240) < 3.16 && cameraNode.eulerAngles.x - xScalar/60 + abs(yScalar/240) > 1.6){
                cameraNode.eulerAngles.x = cameraNode.eulerAngles.x - xScalar/60 + abs(yScalar/240)
                }
            }
            else{
                cameraNode.position.z = cameraNode.position.z - abs(xScalar)*2 - abs(yScalar)*2
                cameraNode.eulerAngles.x = cameraNode.eulerAngles.x - xScalar/60 - abs(yScalar/240)
            }

        case .ended:
            print(cameraNode.position.x, cameraNode.position.y, cameraNode.position.z)
            print(cameraNode.eulerAngles.x, cameraNode.eulerAngles.y, cameraNode.eulerAngles.z)
//            return
            cameraNode.position = cameraPosition!
            cameraNode.eulerAngles = cameraAngle!
        case .possible:
            cameraNode.position = cameraPosition!
            cameraNode.eulerAngles = cameraAngle!
        case .cancelled:
            cameraNode.position = cameraPosition!
            cameraNode.eulerAngles = cameraAngle!
        case .failed:
            cameraNode.position = cameraPosition!
            cameraNode.eulerAngles = cameraAngle!
        }
//        let translation = gestureRecognizer.translation(in: view)
    }

//
    func pauseScreen() {
        
        dismiss()
        
    }
    
    func dismiss() {
        
        self.myChessGame.theChessBoard.r0 = []
        self.myChessGame.theChessBoard.r1 = []
        self.myChessGame.theChessBoard.r2 = []
        self.myChessGame.theChessBoard.r3 = []
        self.myChessGame.theChessBoard.r4 = []
        self.myChessGame.theChessBoard.r5 = []
        self.myChessGame.theChessBoard.r6 = []
        self.myChessGame.theChessBoard.r7 = []
        place = []
        self.dismiss(animated: true, completion: nil)
        
    }
    
}




