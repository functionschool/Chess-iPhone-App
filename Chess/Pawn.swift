//
//  Pawn.swift
//  Chess
//
//  Created by Kousei Richeson on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit

class Pawn: UIChessPiece {
    
    var triesToAdvanceBy2: Bool = false
    
    init(frame: CGRect, color: UIColor, vc: GameScreen) {
        
        super.init(frame: frame)
        
        if color == UIColor.black {
            self.text = "♟"
        }
        else{
            self.text = "♙"
        }
        
        self.isOpaque = false
        self.textColor = color
        self.isUserInteractionEnabled = true
        self.textAlignment = .center
        self.font = self.font.withSize(36)
        
        //add to screen
        vc.chessPieces.append(self)
        vc.view.addSubview(self)
        
    }
    
    func doesMoveSeemFine(fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
        
        //check advance by 2
        if source.col == dest.col {
            if (source.row == 1 && dest.row == 3 && color == UIColor.black) || (source.row == 6 && dest.row == 4 && color != UIColor.black) {
                triesToAdvanceBy2 = true
                return true
            }
        }
        
        triesToAdvanceBy2 = false
        
        //check advance by 1
        var moveForward = 0
        
        if color == UIColor.black {
            moveForward = 1
        }
        else {
            moveForward = -1
        }
        
        if dest.row == source.row + moveForward {
            //diagonal left, forward, diagonal right
            if (dest.col == source.col - 1) || (dest.col == source.col) || (dest.col == source.col + 1) {
                return true
            }
        }
        
        return false
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}
