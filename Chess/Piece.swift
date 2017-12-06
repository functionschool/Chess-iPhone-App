//
//  Piece.swift
//  Chess
//
//  Created by Kousei Richeson on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit

//get the cordinates of every standard chess piece
protocol Piece {
    
    //get coordintates of piece on screen
    var x: CGFloat {get set}  //set the x location
    var y: CGFloat {get set} //set the y location
}
