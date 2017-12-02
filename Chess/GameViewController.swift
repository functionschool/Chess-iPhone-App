//
//  GameViewController.swift
//  test
//
//  Created by Gilbert Carrillo on 10/19/17.
//  Copyright © 2017 Gilbert Carrillo. All rights reserved.
//
import UIKit
import QuartzCore
import SceneKit
class GameViewController: UIViewController {
   var pieceDragged: UIChessPiece!
    var myChessGame: ChessGame!
    var chessPieces: [UIChessPiece]!
    var textOverlay: TextOverlay!
   // var gameView:SCNView!
    var mainScene:SCNScene!
    //var cameraNode:SCNNode!
   // var targetCreationTime:TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScene = createMainScene()
        let sceneView = self.view as! SCNView
        sceneView.scene = mainScene
        
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
        mainScene!.rootNode.addChildNode(createFloorNode())
        sceneView.overlaySKScene = TextOverlay(size: view.frame.size)
        textOverlay = sceneView.overlaySKScene as! TextOverlay
    }
    func createMainScene() -> SCNScene {
        let mainScene = SCNScene(named: "art.scnassets/chesstable.dae")
//        
//        print(mainScene)
        setupLighting(scene: mainScene!)
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
        ambientLight.light!.color = UIColor.green
        scene.rootNode.addChildNode(ambientLight)


        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.spot
        lightNode.light!.castsShadow = true
        lightNode.light!.color = UIColor(white: 0.8, alpha: 1.8	)
        lightNode.position = SCNVector3Make(150, 400, 60)
        lightNode.rotation = SCNVector4Make(1, 0, 0, Float(-M_PI/2.8))
        lightNode.light!.spotInnerAngle = 0
        lightNode.light!.spotOuterAngle = 50
        lightNode.light!.shadowColor = UIColor.black
        lightNode.light!.zFar = 500
        lightNode.light!.zNear = 50
        scene.rootNode.addChildNode(lightNode)
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    
    
    func updateTurnOnScreen() {
        
        //displayTurn.text = myChessGame.isWhiteTurn ? "White's Turn" : "Black's Turn"
        
        //displayTurn.textColor = myChessGame.isWhiteTurn ? UIColor.white : UIColor.black
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}


