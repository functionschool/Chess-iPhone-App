//
//  Dummy.swift
//  Chess
//
//  Created by Kousei Richeson on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit


class Dummy: Piece {
    
    private var xStorage: CGFloat!
    private var yStorage: CGFloat!
    
    
    var x: CGFloat {
        get {
            return self.xStorage
        }
        set {
            self.xStorage = newValue
        }
    }
    
    
    var y: CGFloat {
        get {
            return self.yStorage
        }
        set {
            self.yStorage = newValue
        }
    }
    
    init(frame: CGRect) {
        self.xStorage = frame.origin.x
        self.yStorage = frame.origin.y
    }
    
    init(){
        
    }
    
}
