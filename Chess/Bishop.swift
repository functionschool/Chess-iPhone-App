//
//  Bishop.swift
//  Chess
//
//  Created by Kousei Richeson & Gilbert Carrillo  on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit


class Bishop: UIChessPiece {
    
    init(frame: CGRect, color: UIColor, vc: GameScreen) {
        
        super.init(frame: frame)
        
        //display two types of bishop pieces
        //one for each player
        if color == UIColor.black {
            self.text = "♝"
        }
        else{
            self.text = "♗"
        }
        //set color, font and
        //let user drag
        self.isOpaque = false
        self.textColor = color
        self.isUserInteractionEnabled = true
        self.textAlignment = .center
        self.font = self.font.withSize(36)
        
        //add to screen
        vc.chessPieces.append(self)
        vc.view.addSubview(self)
        
    }
    
    
    
    //check if the move the user is making, is valid for this certain piece
    func doesMoveSeemFine(fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
        
        if abs(dest.row - source.row) == abs(dest.col - source.col) {
            return true //move is valid
        }
        
        return false //dont move if invalid move is tried
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}
