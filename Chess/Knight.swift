//
//  Knight.swift
//  Chess
//
//  Created by Kousei Richeson on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit

class Knight: UIChessPiece {
    
    init(frame: CGRect, color: UIColor, vc: GameScreen) {
        
        super.init(frame: frame)
        
        if color == UIColor.black {
            self.text = "♞"
        }
        else{
            self.text = "♘"
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
        let validMoves = [(source.row - 1, source.col + 2), (source.row - 2, source.col + 1), (source.row - 2, source.col - 1),(source.row - 1, source.col - 2), (source.row + 1, source.col - 2), (source.row + 2, source.col - 1), (source.row + 2, source.col + 1),(source.row + 1, source.col + 2)]
        
        for(validRow, validCol) in validMoves{
            if dest.row == validRow && dest.col == validCol{
                return true
            }
        }
        
        return false
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}
