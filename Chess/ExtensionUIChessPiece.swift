//
//  ExtensionUIChessPiece.swift
//  Chess
//
//  Created by Kousei Richeson & Gilbert Carrillo on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//
//extension to UIChessPiece
//referred to as label in other files

import UIKit

typealias UIChessPiece = UILabel

extension UIChessPiece: Piece {
    //mutator and accessor for the x location
    var x: CGFloat {
        
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
        
    }
    
    //mutator and accessor for the y location
    var y: CGFloat {
        
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
        
    }
    
    //get color of UIChessPiece
    var color: UIColor {
        
        get {
            return self.textColor
        }
        
    }
    
}


