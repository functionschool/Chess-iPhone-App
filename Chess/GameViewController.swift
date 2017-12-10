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
import SceneKit
let originX:Float = 185.25
let originY:Float = 118
let originZ:Float = 28.4
let distance:Float = 13.85
var first: Bool = true
var Current: SCNNode!
var mainScene:SCNScene!
var board:[[String]] = []
var place:[[SCNNode]] = []
var cameraNode: SCNNode!
class GameViewController: UIViewController {

    var myChessGame: ChessGame3D!
    var textOverlay: TextOverlay!
    var isAgainstAI: Bool!
    
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
        sceneView.allowsCameraControl = true
        //Add a floor
        mainScene!.rootNode.addChildNode(createFloorNode())
        //isAgainstAI = true
        //  Super impose text over screen
        sceneView.overlaySKScene = TextOverlay(size: view.frame.size)
        textOverlay = sceneView.overlaySKScene as! TextOverlay
        myChessGame = ChessGame3D.init(viewController: self)
        myChessGame.SetBoard(rootNode: (mainScene?.rootNode)!)//Set up the grid for the board
        //    Handle taps
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        
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
        floorNode.geometry = SCNFloor()
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
        lightNode.light!.type = SCNLight.LightType.spot
        lightNode.light!.castsShadow = true
        lightNode.light!.color = UIColor(white: 0.8, alpha: 1.8    )
        lightNode.position = SCNVector3Make(150, 400, 60)
        //lightNode.rotation = SCNVector4Make(1, 0, 0, Float(-M_PI/2.8))
        lightNode.rotation = SCNVector4Make(1, 0, 0, Float(-Double.pi/2.8))
        lightNode.light!.spotInnerAngle = 0
        lightNode.light!.spotOuterAngle = 50
        lightNode.light!.shadowColor = UIColor.black
        lightNode.light!.zFar = 500
        lightNode.light!.zNear = 50
        scene.rootNode.addChildNode(lightNode)
    }
    
    func createCamera(){
        //position 1 160.838 237.945 -208.809 2.52834 -0.0076284 3.14159
        //position 2
        //position 3 160.838
        //position 4
        //psoition 5
        let cameraNode = mainScene.rootNode.childNode(withName: "skp_camera_Last_Saved_SketchUp_View", recursively: true)
//        cameraNode?.camera?.zFar = 6000
//        cameraNode?.position.x = 140
//        cameraNode?.position.y = 240
//        cameraNode?.position.z = -142
//        cameraNode?.eulerAngles.x = 2.3
//        cameraNode?.eulerAngles.y = -0.0076
//        cameraNode?.eulerAngles.z = 3.14159
//        cameraNode?.rotation.x = 0.00115949
//        cameraNode?.rotation.y = 0.912763
//        cameraNode?.rotation.z = 0.408487
//
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
        
        //Check for return button push
        if ((p.x>350&&p.x<370) && (p.y>640&&p.y<660)){
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
        
        //Insure object was tapped
        let hitResults = sceneView.hitTest(p, options: [:])
        if hitResults.count > 0{
            //Check if first screen tap
            if first == true{
                let resultchild: AnyObject = hitResults[0]
                let result = resultchild.node.parent
                
                if(myChessGame.validFirstTap(result: result!)){
                    first = false
                    //Set pointer to piece so we can move it later
                    Current = result
                    
                }
                else{
                    print("wrong turn")
                }
                
            }
            else{//If second tap
                //Reset tap count
                first = true
                let resultchild: AnyObject = hitResults[0]
                myChessGame.move(resultchild: resultchild.node)
                //check if game's over
                if myChessGame.isGameOver(){
                    displayWinner()
                    return
                }
                //check if the pawn should be promoted
                if shouldPromotePawn(){
                    promptForPawnPromotion()
                }
                else{
                    resumeGame() //dont prompt for pawn promotion if not possible
                }
                
            }
            
        }
        
    }
    
    
    func resumeGame(){
        //display checks if any
     //   displayCheckFunction()
        
        //display turn on screen
        textOverlay.updateTurnOnScreen(whiteTurn: myChessGame.whiteTurn)
        
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
            
            displayCheckFunction()
            
            textOverlay.updateTurnOnScreen(whiteTurn: myChessGame.whiteTurn)
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
    func displayCheckFunction(){
        let playerChecked = myChessGame.getPlayerChecked()
        
        //display a message that player is checked, if elegible
        if playerChecked != nil {
            textOverlay.display(text: playerChecked! + " is in check!")
        }
        else {
            textOverlay.display(text: "nothing")
        }
    }
    
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
}




