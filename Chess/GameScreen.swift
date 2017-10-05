//
//  GameScreen.swift
//  Chess
//
//  Created by Kousei Richeson on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit

class GameScreen: UIViewController {
    
    
    @IBOutlet var displayTurn: UILabel!
    @IBOutlet var displayCheck: UILabel!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    var pieceDragged: UIChessPiece!
    var sourceOrigin: CGPoint!
    var destinationOrigin: CGPoint!
    static var SPACE_FROM_LEFT_EDGE: Int = 35
    static var SPACE_FROM_TOP_EDGE: Int = 181
    static var TILE_SIZE: Int = 38
    var myChessGame: ChessGame!
    var chessPieces: [UIChessPiece]!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    

}
