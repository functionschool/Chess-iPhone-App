//
//  ChessGame.swift
//  Chess
//
//  Created by Kousei Richeson on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit

class ChessGame: NSObject {
    
    var theChessBoard: ChessBoard!
    
    init(viewController: GameScreen) {
        theChessBoard = ChessBoard.init(viewController: viewController)
    }
    
    func isMoveValid(piece: UIChessPiece, fromIndex sourceIndex: BoardIndex, toIndex destIndex: BoardIndex) -> Bool {
        return false
    }
    
}
