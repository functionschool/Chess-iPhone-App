//
//  Dummy.swift
//  Chess
//
//  Created by Kousei Richeson & Gilbert Carrillo  on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit

//dummy class


//implements dummy pieces
//a dummy piece is just an invisible piece
//that stays on the empty tiles

class Dummy: Piece {
    
    private var xStorage: CGFloat!
    private var yStorage: CGFloat!
    
    //store dummy pieces on board
    var x: CGFloat {
        get {
            return self.xStorage
        }
        set {
            self.xStorage = newValue
        }
    }
    
    //store dummy pieces on board
    var y: CGFloat {
        get {
            return self.yStorage
        }
        set {
            self.yStorage = newValue
        }
    }
    
    //fill board with dummy pieces on all empty tiles
    init(frame: CGRect) {
        self.xStorage = frame.origin.x
        self.yStorage = frame.origin.y
    }
    
    init(){
        
    }
    
}
