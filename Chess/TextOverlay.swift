//
//  TextOverlay.swift
//  Chess
//
//  Created by Kousei Richeson on 12/1/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

class TextOverlay: SKScene{
//    var turnNode: SKLabelNode!
    var checkNode: SKLabelNode!
    var buttonNode: SKSpriteNode!
    override init(size: CGSize){
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .resizeFill
        buttonNode = SKSpriteNode(imageNamed: "HomeButton.png")
        buttonNode.position = CGPoint(x:-size.width/2 + 30, y: size.height/2 - 30 )
        buttonNode.xScale = 0.1
        buttonNode.yScale = 0.1
        buttonNode.name = "pause"
//        checkNode = SKLabelNode(fontNamed: "Avenir-Bold")
//        checkNode.text = nil
//        checkNode.fontColor = .white
//        checkNode.horizontalAlignmentMode = .right
//        checkNode.verticalAlignmentMode = .bottom
//        //turnNode.position = CGPoint(x: -size.width/2 + 20, y: size.height/2 - 40)
//        checkNode.position = CGPoint(x: -size.width/4, y: -size.height/2 + 20)
//        checkNode.name = "check"
        addChild(buttonNode)
    }
//    func updateTurnOnScreen(whiteTurn: Bool){
//        if whiteTurn{
//            turnNode.text = "White's turn"
//            turnNode.fontColor = .white
//        }
//        else{
//            turnNode.text = "Black's turn"
//            turnNode.fontColor = .black
//        }
//    }
    
    
//    func display(text: String){
//        if text == "nothing"{
//            checkNode.text = nil
//        }
//        else{
//            checkNode.text = text
//        }
//    }
    
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}
