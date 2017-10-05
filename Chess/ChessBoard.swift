//
//  ChessBoard.swift
//  Chess
//
//  Created by Kousei Richeson on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit

class ChessBoard: NSObject {
    
    var board: [[Piece]]!
    var vc: GameScreen!
    let ROWS = 8
    let COLS = 8
    var whiteKing: King!
    var blackKing: King!
    
    
    func getFrame(forRow row: Int, forCol col: Int) -> CGRect {
        
        let x = CGFloat(GameScreen.SPACE_FROM_LEFT_EDGE + col * GameScreen.TILE_SIZE)
        let y = CGFloat(GameScreen.SPACE_FROM_TOP_EDGE + row * GameScreen.TILE_SIZE)
        
        return CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: GameScreen.TILE_SIZE, height: GameScreen.TILE_SIZE))
        
    }
    
    init(viewController: GameScreen) {
        vc = viewController
        
        //initialize the board matrix with dummies
        let oneRowOfBoard = Array(repeating: Dummy(), count: COLS)
        board = Array(repeating: oneRowOfBoard, count: ROWS)
    }
    
}
