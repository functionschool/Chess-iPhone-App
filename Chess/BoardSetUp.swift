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
        node.eulerAngles.y = 30
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
            board[7][7]="ID77"; board[7][6]="ID76";board[7][5]="ID75"; board[7][4]="ID74"; board[7][3]="ID73";
            board[7][2]="ID72";board[7][1]="ID71"; board[7][0]="ID70"
            
            board[6][7]="ID67"; board[6][6]="ID66";board[6][5]="ID65"; board[6][4]="ID64"; board[6][3]="ID63";
            board[6][2]="ID62";board[6][1]="ID61"; board[6][0]="ID60"
            
            board[5][7]="ID57"; board[5][6]="ID56";board[5][5]="ID55"; board[5][4]="ID54"; board[5][3]="ID53";
            board[5][2]="ID52";board[5][1]="ID51"; board[5][0]="ID50"
            
            board[4][7]="ID47"; board[4][6]="ID46";board[4][5]="ID45"; board[4][4]="ID44"; board[4][3]="ID43";
            board[4][2]="ID42";board[4][1]="ID41"; board[4][0]="ID40"
            
            board[3][7]="ID37"; board[3][6]="ID36";board[3][5]="ID35"; board[3][4]="ID34"; board[3][3]="ID33";
            board[3][2]="ID32";board[3][1]="ID31"; board[3][0]="ID30"
            
            board[2][7]="ID27"; board[2][6]="ID26";board[2][5]="ID25"; board[2][4]="ID24"; board[2][3]="ID23";
            board[2][2]="ID22";board[2][1]="ID21"; board[2][0]="ID20"
            
            board[1][7]="ID17"; board[1][6]="ID16";board[1][5]="ID15"; board[1][4]="ID14"; board[1][3]="ID13";
            board[1][2]="ID12";board[1][1]="ID11"; board[1][0]="ID10"
            
            board[0][7]="ID07"; board[0][6]="ID06";board[0][5]="ID05"; board[0][4]="ID04"; board[0][3]="ID03";
            board[0][2]="ID02";board[0][1]="ID01"; board[0][0]="ID00"
            print("All set up")

    }

}
