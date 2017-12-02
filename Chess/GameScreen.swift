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
        
        chessPieces = []
        myChessGame = ChessGame.init(viewController: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func drag(piece: UIChessPiece, usingGestureRecognizer gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        piece.center = CGPoint(x: translation.x + piece.center.x, y: translation.y + piece.center.y)
        
        //makes piece stay on finger while dragging
        gestureRecognizer.setTranslation(CGPoint.zero, in: view)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        pieceDragged = touches.first!.view as? UIChessPiece
        
        //if we toucheda chess piece
        if pieceDragged != nil {
            
            //We save the location just in case the user did an invalid move
            sourceOrigin = pieceDragged.frame.origin
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if pieceDragged != nil {
            drag(piece: pieceDragged, usingGestureRecognizer: panGesture)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Lets make the piece land in the middle of the square
        //If we dragged a piece,
        if pieceDragged != nil {
            
            let touchLocation = touches.first!.location(in: view)
            
            var x = Int(touchLocation.x)
            var y = Int(touchLocation.y)
            
            x = x - GameScreen.SPACE_FROM_LEFT_EDGE
            y = y - GameScreen.SPACE_FROM_TOP_EDGE
            
            x = (x / GameScreen.TILE_SIZE) * GameScreen.TILE_SIZE
            y = (y / GameScreen.TILE_SIZE) * GameScreen.TILE_SIZE
            
            x = x + GameScreen.SPACE_FROM_LEFT_EDGE
            y = y + GameScreen.SPACE_FROM_TOP_EDGE
            
            destinationOrigin = CGPoint(x: x, y: y)
            
            let sourceIndex = ChessBoard.indexOf(origin: sourceOrigin)
            let destIndex = ChessBoard.indexOf(origin: destinationOrigin)
            
            if myChessGame.isMoveValid(piece: pieceDragged, fromIndex: sourceIndex, toIndex: destIndex) {
                
                myChessGame.move(piece: pieceDragged, fromIndex: sourceIndex, toIndex: destIndex, toOrigin: destinationOrigin)
                
                myChessGame.nextTurn()
                
                updateTurnOnScreen()
                
            }
            else {
                pieceDragged.frame.origin = sourceOrigin
            }
            
        }

    }
    
    func updateTurnOnScreen() {
        
        displayTurn.text = myChessGame.isWhiteTurn ? "White's Turn" : "Black's Turn"
        
        displayTurn.textColor = myChessGame.isWhiteTurn ? UIColor.white : UIColor.black
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    

}
