//
//  BoardIndex.swift
//  Chess
//
//  Created by Kousei Richeson on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//
//sructure that contains row and column of the chesss board
struct BoardIndex: Equatable {
    //row and column variable for structure
    var row: Int
    var col: Int
    //create row and columns
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    static func == (lhs: BoardIndex, rhs: BoardIndex) -> Bool {
        return (lhs.row == rhs.row && lhs.col == rhs.col)
    }
    
    
}
