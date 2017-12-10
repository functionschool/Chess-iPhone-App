//
//  BoardSetUp.swift
//  Chess
//
//  Created by Gilbert Carrillo on 12/6/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//
import UIKit
import Foundation
import SceneKit
class BoardSetUp : NSObject{
    
 //   var board:[[String]] = []
    var vc: GameViewController!
    var r0:[SCNNode] = []
    var r1:[SCNNode] = []
    var r2:[SCNNode] = []
    var r3:[SCNNode] = []
    var r4:[SCNNode] = []
    var r5:[SCNNode] = []
    var r6:[SCNNode] = []
    var r7:[SCNNode] = []
    //var place:[[SCNNode]] = []
    func getIndex(objectToFind: SCNNode)->[Int]{
            //get index for every chess piece
            var x = 0
            var y = 0
            var index: [Int] = [8,8]
            // Get location of next potential move
            while( x != 8 && objectToFind != place[x][y] && objectToFind.name != board[x][y] ){
             //   print(x, y)
                if(y==7){
                    x+=1
                    y=0
                }
                else{
                    y+=1
                }
            }
            index[0] = x
            index[1] = y
            return index
            
        }
        
        //place the chess pieces on the board
    func placePiece(cX: Int, cZ: Int, x: Int, y: Int) {
        let action = SCNAction.move(to: SCNVector3(originX-distance * Float(y), originY, originZ-distance * Float(x) ), duration: TimeInterval(1.0))
        Current?.runAction(action)//if not move to location and kill piece
        //  chessPiece.removeFromParentNode()
            //update grid
            place[cX][cZ] = mainScene.rootNode
            place[x][y] = Current
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
    
    func SetUpBoard(z: Float, rootNode: SCNNode, white: Bool) {
        //Add in the pieces from left to right
        var x:Float=0
        var node:SCNNode
        node = createRookNode(x: white)
        rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        if z == 0{
            r0.append(node)
        }
        else{
            r7.append(node)
        }
        x+=1
        node = createKnightNode(x: white)
        rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        if z == 0{
            r0.append(node)
        }
        else{
            r7.append(node)
        }
        x+=1
        node = createBishopNode(x: white)
        rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        if z == 0{
            r0.append(node)
        }
        else{
            r7.append(node)
        }
        x+=1
        node = createQueenNode(x: white)
        rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        if z == 0{
            r0.append(node)
        }
        else{
            r7.append(node)
        }
        x+=1
        node = createKingNode(x: white)
        rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        if z == 0{
            r0.append(node)
        }
        else{
            r7.append(node)
        }
        x+=1
        node = createBishopNode(x: white)
        rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        if z == 0{
            r0.append(node)
        }
        else{
            r7.append(node)
        }
        x+=1
        node = createKnightNode(x: white)
        rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        if z == 0{
            r0.append(node)
        }
        else{
            r7.append(node)
        }
        x+=1
        node = createRookNode(x: white)
        rootNode.addChildNode(node)
        node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
        if z == 0{
            r0.append(node)
        }
        else{
            r7.append(node)
        }
    }
    
    func SetUp(rootNode: SCNNode){
        var z:Float=0
        var x:Float=0
        var node:SCNNode
        SetUpBoard(z: z, rootNode: (mainScene?.rootNode)!, white: false)
  
        //Change row selection
        z = 7
        
        //set up the rest of the matrix for the rows in between
        place+=[r0, r1, r2, r3, r4, r5, r6]
        for i in 1...6 {
            for _ in 0...7 {
                place[i].append(mainScene!.rootNode)
            }
        }
        
        //Load in the top row, on the white side
        SetUpBoard(z: z, rootNode: (mainScene?.rootNode)!, white: true)
        
        place.append(r7)
        //Load in the black pawns
        z=1
        for i in 0...7 {
            node = createPawnNode(x: false)
            mainScene!.rootNode.addChildNode(node)
            node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
            place[1][i] = node
            x+=1
        }
        z=6
        x=0
        
        //Load in the white pawns
        for i in 0...7 {
            node = createPawnNode(x: true)
            mainScene!.rootNode.addChildNode(node)
            node.runAction(SCNAction.move(to: SCNVector3(originX-distance * x,originY,originZ-distance * z ), duration: 0))
            place[6][i] = node
            x+=1
        }
        
    }
    

        init(viewController: GameViewController) {
            vc = viewController
            //Create Matrix
            var row0:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
            var row1:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
            var row2:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
            var row3:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
            var row4:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
            var row5:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
            var row6:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
            var row7:[String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
            board += [row0, row1, row2, row3, row4, row5, row6, row7]
            
            //Set all tile IDs to corrsponding spot on the grid, for piece movement
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
            print("All set up")

    }

}
