//
//  BoardIndex.swift
//  Chess
//
//  Created by Kousei Richeson on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

struct BoardIndex: Equatable {
    
    var row: Int
    var col: Int
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    static func == (lhs: BoardIndex, rhs: BoardIndex) -> Bool {
        return (lhs.row == rhs.row && lhs.col == rhs.col)
    }
    
    
}
