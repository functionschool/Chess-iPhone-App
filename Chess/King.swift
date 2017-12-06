//
//  King.swift
//  Chess
//
//  Created by Kousei Richeson & Gilbert Carrillo  on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit

class King: UIChessPiece {
    
    init(frame: CGRect, color: UIColor, vc: GameScreen) {
        
        super.init(frame: frame)
        //display two types of king pieces
        //one for each player
        if color == UIColor.black {
            self.text = "♚"
        }
        else{
            self.text = "♔"
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
        
        let differenceInRows = abs(dest.row - source.row)
        let differenceInCols = abs(dest.col - source.col)
        
        if case 0...1 = differenceInRows {
            if case 0...1 = differenceInCols {
                return true //valid move
            }
        }
        
        return false //invalid move
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}
