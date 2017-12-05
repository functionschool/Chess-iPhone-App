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
let originX:Float = 185.25
let originY:Float = 118
let originZ:Float = 28.4
let distance:Float = 13.85
var first: Bool = true
var Current: SCNNode!
var mainScene:SCNScene!
var whiteTurn: Bool = true
class GameViewController: UIViewController {
    var myChessGame: ChessGame!
    var textOverlay: TextOverlay!
   // var mainScene:SCNScene!
    var isAgainstAI: Bool!
    var r0:[SCNNode] = []
    var r1:[SCNNode] = []
    var r2:[SCNNode] = []
    var r3:[SCNNode] = []
    var r4:[SCNNode] = []
    var r5:[SCNNode] = []
    var r6:[SCNNode] = []
    var r7:[SCNNode] = []
    var ro0:[Bool] = []
    var ro1:[Bool] = []
    var ro2:[Bool] = []
    var ro3:[Bool] = []
    var ro4:[Bool] = []
    var ro5:[Bool] = []
    var ro6:[Bool] = []
    var ro7:[Bool] = []
    var place:[[SCNNode]] = []
    var iswhite:[[Bool]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScene = createMainScene()
        let sceneView = self.view as! SCNView
        sceneView.scene = mainScene
        
        sceneView.showsStatistics = false
        sceneView.allowsCameraControl = true
        mainScene!.rootNode.addChildNode(createFloorNode())

        sceneView.overlaySKScene = TextOverlay(size: view.frame.size)
        textOverlay = sceneView.overlaySKScene as! TextOverlay
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        
    }
        
    func createMainScene() -> SCNScene {
        let mainScene = SCNScene(named: "art.scnassets/chesstable.dae")
        var x:Float=0
        var z:Float=0
        var node:SCNNode
        node = createRookNode(x: false)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r0.append(node)
        x+=1
        node = createKnightNode(x: false)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r0.append(node)
        x+=1
        node = createBishopNode(x: false)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r0.append(node)
        x+=1
        node = createQueenNode(x: false)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r0.append(node)
        x+=1
        node = createKingNode(x: false)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r0.append(node)
        x+=1
        node = createBishopNode(x: false)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r0.append(node)
        x+=1
        node = createKnightNode(x: false)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r0.append(node)
        x+=1
        node = createRookNode(x: false)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r0.append(node)
        z=7
        x=0
        ro0+=[false, false,false, false,false, false,false, false]
        place+=[r0, r1, r2, r3, r4, r5, r6]
        iswhite+=[ro0, ro1, ro2, ro3, ro4, ro5, ro6]
        for i in 1...6 {
            for _ in 0...7 {
                place[i].append(mainScene!.rootNode)
                iswhite[i].append(false)
            }
        }
        node = createRookNode(x: true)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r7.append(node)
        x+=1
        node = createKnightNode(x: true)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r7.append(node)
        x+=1
        node = createBishopNode(x: true)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r7.append(node)
        x+=1
        node = createQueenNode(x: true)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r7.append(node)
        x+=1
        node = createKingNode(x: true)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r7.append(node)
        x+=1
        node = createBishopNode(x: true)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r7.append(node)
        x+=1
        node = createKnightNode(x: true)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r7.append(node)
        x+=1
        node = createRookNode(x: true)
        mainScene!.rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        r7.append(node)
        z=1
        x=0
        place.append(r7)
        ro7+=[true, true,true, true,true, true,true, true]
        iswhite.append(ro7)
        for i in 0...7 {
            node = createPawnNode(x: false)
            mainScene!.rootNode.addChildNode(node)
            node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
            place[1][i] = node
            iswhite[1][i] = false
            x+=1
        }
        z=6
        x=0
        for i in 0...7 {
            node = createPawnNode(x: true)
            mainScene!.rootNode.addChildNode(node)
            node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
            place[6][i] = node
            iswhite[6][i] = true
            x+=1
        }
 
//        setupLighting(scene: mainScene!)
        return mainScene!
    }
    func createFloorNode() -> SCNNode {
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "floor"
        return floorNode
    }
    
    
func createKingNode(x: Bool) -> SCNNode{
    let Scene = SCNScene(named: "art.scnassets/pieces.dae")
    if(x==false){
        let Bnode = Scene!.rootNode.childNode(withName: "King_Black", recursively: true)!
         return Bnode
    }
    else{
        let Wnode = Scene!.rootNode.childNode(withName: "King_White", recursively: true)!
         return Wnode

    }
    
    }

func createQueenNode(x: Bool) -> SCNNode{
    let Scene = SCNScene(named: "art.scnassets/pieces.dae")
    var node: SCNNode
    if(x==false){
        node = Scene!.rootNode.childNode(withName: "Queen_Black", recursively: true)!
    }
    else{
        node = Scene!.rootNode.childNode(withName: "Queen_White", recursively: true)!
        
    }
    
    return node
}

func createRookNode(x: Bool) -> SCNNode{
    let Scene = SCNScene(named: "art.scnassets/pieces.dae")
    var node: SCNNode
    if(x==false){
        node = Scene!.rootNode.childNode(withName: "Rook_Black", recursively: true)!
    }
    else{
        node = Scene!.rootNode.childNode(withName: "Rook_White", recursively: true)!
        
    }
    
    return node
}

func createKnightNode(x: Bool) -> SCNNode{
    let Scene = SCNScene(named: "art.scnassets/pieces.dae")
    var node: SCNNode
    if(x==false){
        node = Scene!.rootNode.childNode(withName: "Knight_Black", recursively: true)!
    }
    else{
        node = Scene!.rootNode.childNode(withName: "Knight_Whiite", recursively: true)!
        
    }
    
    return node
}

func createBishopNode(x: Bool) -> SCNNode{
    let Scene = SCNScene(named: "art.scnassets/pieces.dae")
    var node: SCNNode
    if(x==false){
        node = Scene!.rootNode.childNode(withName: "Bishop_Black", recursively: true)!
    }
    else{
        node = Scene!.rootNode.childNode(withName: "Bishop_White", recursively: true)!
        
    }
    
    return node
}
    func createPawnNode(x: Bool) -> SCNNode{
        let Scene = SCNScene(named: "art.scnassets/pieces.dae")
        var node: SCNNode
        if(x==false){
            node = Scene!.rootNode.childNode(withName: "Pawn_Black", recursively: true)!
        }
        else{
            node = Scene!.rootNode.childNode(withName: "Pawn_White", recursively: true)!
            
        }
        
        return node
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
        lightNode.light!.color = UIColor(white: 0.8, alpha: 1.8	)
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


    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer){
        
        var row0:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
        var row1:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
        var row2:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
        var row3:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
        var row4:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
        var row5:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
        var row6:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
        var row7:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
        var board:[[String]] = [row0, row1, row2, row3, row4, row5, row6, row7]
        
        board[7][7]="ID202"; board[7][6]="ID210";board[7][5]="ID218"; board[7][4]="ID226"; board[7][3]="ID234";
        board[7][2]="ID274";board[7][1]="ID266"; board[7][0]="ID186"

        board[6][7]="ID314"; board[6][6]="ID346";board[6][5]="ID306"; board[6][4]="ID370"; board[6][3]="ID418";
        board[6][2]="ID426";board[6][1]="ID378"; board[6][0]="ID330"

        board[5][7]="ID322"; board[5][6]="ID362";board[5][5]="ID386"; board[5][4]="ID410"; board[5][3]="ID394";
        board[5][2]="ID354";board[5][1]="ID402"; board[5][0]="ID338"

        board[4][7]="ID53"; board[4][6]="ID106";board[4][5]="ID98"; board[4][4]="ID90"; board[4][3]="ID82";
        board[4][2]="ID61";board[4][1]="ID40"; board[4][0]="ID74"

        board[3][7]="ID458"; board[3][6]="ID474";board[3][5]="ID466"; board[3][4]="ID522"; board[3][3]="ID498";
        board[3][2]="ID530";board[3][1]="ID482"; board[3][0]="ID434"

        board[2][7]="ID122"; board[2][6]="ID138";board[2][5]="ID130"; board[2][4]="ID154"; board[2][3]="ID162";
        board[2][2]="ID146";board[2][1]="ID170"; board[2][0]="ID114"

        board[1][7]="ID178"; board[1][6]="ID290";board[1][5]="ID298"; board[1][4]="ID250"; board[1][3]="ID282";
        board[1][2]="ID258";board[1][1]="ID242"; board[1][0]="ID194"

        board[0][7]="ID442"; board[0][6]="ID514";board[0][5]="ID490"; board[0][4]="ID506"; board[0][3]="ID554";
        board[0][2]="ID546";board[0][1]="ID538"; board[0][0]="ID450"
        
        let sceneView = self.view as! SCNView
        let p = gestureRecognize.location(in: sceneView)
        if ((p.x>350&&p.x<370) && (p.y>640&&p.y<660)){
      
            self.dismiss(animated: true, completion: nil)
        }
        print(p)
        let hitResults = sceneView.hitTest(p, options: [:])
        if hitResults.count > 0{
            if first == true{
            let resultchild: AnyObject = hitResults[0]
            let result = resultchild.node.parent

            if(result!.name != "leg" && result!.name != "group_0" && result!.name != "SketchUp"){
                first = false
                Current = result
                
           // let action = SCNAction.move(to: SCNVector3(currentX!, currentY!, currentZ! + 10), duration: TimeInterval(1.0));
          //  result?.runAction(action)
            }
            
        }
            else{
                first = true
                let resultchild: AnyObject = hitResults[0]
                let result = resultchild.node.parent
                
                if(result?.name == "group_0"){
                    var cX = 0
                    var cZ = 0
                    while( cX != 8 && Current != place[cX][cZ] ){
                        print(cX, cZ)
                        if(cZ==7){
                            cX+=1
                            cZ=0
                        }
                        else{
                            cZ+=1
                        }
                    }
                    var x = 0
                    var y = 0
                while( x != 8 && resultchild.node?.name != board[x][y] ){

                    if(y==7){
                        x+=1
                        y=0
                    }
                    else{
                    y+=1
                    }
                }
                    if x != 8{
                    let action = SCNAction.move(to: SCNVector3(originX-distance * Float(y), originY, originZ-distance * Float(x) ), duration: TimeInterval(1.0))
                      Current?.runAction(action)
                        place[cX][cZ] = mainScene.rootNode
                        place[x][y] = Current
                        iswhite[x][y] = whiteTurn
                        if whiteTurn == true{
                            whiteTurn = false
                        }
                        else {
                            whiteTurn = true
                        }
                       
                    }
                
            }
                else if(result?.name != "leg" && result!.name != "SketchUp" ){
                    var cX = 0
                    var cZ = 0
                    while( cX != 8 && Current != place[cX][cZ] ){
                        
                        if(cZ==7){
                            cX+=1
                            cZ=0
                        }
                        else{
                            cZ+=1
                        }
                    }
                    var x = 0
                    var y = 0
                    
                    while( x != 8 && result != place[x][y] ){
                        print(x, y)
                        if(y==7){
                            x+=1
                            y=0
                        }
                        else{
                            y+=1
                        }
                    }
                        if (x != 8 && (iswhite[x][y] == whiteTurn)){
                            let action = SCNAction.move(to: SCNVector3(originX-distance * Float(y), originY, originZ-distance * Float(x) ), duration: TimeInterval(1.0))
                            Current?.runAction(action)
                            result?.removeFromParentNode()
                            place[cX][cZ] = mainScene.rootNode
                            place[x][y] = Current
                        }
                    
                }
            }
        
    }
        
    }
}


