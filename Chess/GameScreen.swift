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
    var isAgainstAI: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chessPieces = []
        myChessGame = ChessGame.init(viewController: self)
        print("SINGLEPLAYER: \(isAgainstAI)")
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
                
                //check if game's over
                if myChessGame.isGameOver(){
                    displayWinner()
                    return
                }
                
                if shouldPromotePawn(){
                    promptForPawnPromotion()
                }
                else{
                    resumeGame()
                }
                
            }
            else {
                pieceDragged.frame.origin = sourceOrigin
            }
            
        }

    }
    
    func resumeGame(){
        //display checks if any
        displayCheckFunction()
        
        //Change the turn
        myChessGame.nextTurn()
        
        //display turn on screen
        updateTurnOnScreen()
        
        //make AI move, if necessary
        if isAgainstAI == true && !myChessGame.isWhiteTurn{
            myChessGame.makeAIMove()
            print("AI: -----------------")
            
            if myChessGame.isGameOver() {
                displayWinner()
                return
            }
            
            if shouldPromotePawn(){
                promote(pawn: myChessGame.getPawnToBePromoted()!, into: "Queen")
            }
            
            displayCheckFunction()
            
            myChessGame.nextTurn()
            
            updateTurnOnScreen()
        }
    }
    
    func promote(pawn pawnToBePromoted: Pawn, into pieceName: String){
        
        let pawnColor = pawnToBePromoted.color
        let pawnFrame = pawnToBePromoted.frame
        let pawnIndex = ChessBoard.indexOf(origin: pawnToBePromoted.frame.origin)
        
        myChessGame.theChessBoard.remove(piece: pawnToBePromoted)
        
        switch pieceName {
            case "Queen":
            myChessGame.theChessBoard.board[pawnIndex.row][pawnIndex.col] = Queen(frame: pawnFrame, color: pawnColor, vc: self)
            case "Knight":
                myChessGame.theChessBoard.board[pawnIndex.row][pawnIndex.col] = Knight(frame: pawnFrame, color: pawnColor, vc: self)
            case "Rook":
                myChessGame.theChessBoard.board[pawnIndex.row][pawnIndex.col] = Rook(frame: pawnFrame, color: pawnColor, vc: self)
            case "Bishop":
                myChessGame.theChessBoard.board[pawnIndex.row][pawnIndex.col] = Bishop(frame: pawnFrame, color: pawnColor, vc: self)
            default:
                break
        }
        
    }
    
    func promptForPawnPromotion(){
        if let pawnToPromote = myChessGame.getPawnToBePromoted(){
            
            let box = UIAlertController(title: "Pawn promotion", message: "Choose Piece", preferredStyle: UIAlertControllerStyle.alert)
            
            box.addAction(UIAlertAction(title: "Queen", style: UIAlertActionStyle.default, handler: { action in
                self.promote(pawn: pawnToPromote, into: action.title!)
                self.resumeGame()
            }))
            
            box.addAction(UIAlertAction(title: "Knight", style: UIAlertActionStyle.default, handler: { action in
                self.promote(pawn: pawnToPromote, into: action.title!)
                self.resumeGame()
            }))
            
            box.addAction(UIAlertAction(title: "Rook", style: UIAlertActionStyle.default, handler: { action in
                self.promote(pawn: pawnToPromote, into: action.title!)
                self.resumeGame()
            }))
            
            box.addAction(UIAlertAction(title: "Bishop", style: UIAlertActionStyle.default, handler: { action in
                self.promote(pawn: pawnToPromote, into: action.title!)
                self.resumeGame()
            }))
            
            self.present(box, animated: true, completion: nil)
            
        }
    }
    
    func shouldPromotePawn() -> Bool {
        return (myChessGame.getPawnToBePromoted() != nil)
    }
    
    func displayCheckFunction(){
        let playerChecked = myChessGame.getPlayerChecked()
        
        if playerChecked != nil {
            displayCheck.text = playerChecked! + " is in check!"
        }
        else {
            displayCheck.text = nil
        }
    }
    
    func displayWinner(){
        
        let box = UIAlertController(title: "Game Over", message: "\(myChessGame.winner!) wins", preferredStyle: UIAlertControllerStyle.alert)
        
        box.addAction(UIAlertAction(title: "Back to main menu", style: UIAlertActionStyle.default, handler: { action in self.performSegue(withIdentifier: "backToMainMenu", sender: self) }))
        
        box.addAction(UIAlertAction(title: "Rematch", style: UIAlertActionStyle.default, handler: {
            action in
            
            //clear screen and board matrix
            for chessPiece in self.chessPieces{
                self.myChessGame.theChessBoard.remove(piece: chessPiece)
            }
            
            //create new game
            self.myChessGame = ChessGame(viewController: self)
            
            //update labels with game status
            self.updateTurnOnScreen()
            self.displayCheck.text = nil
        }))
        
        self.present(box, animated: true, completion: nil)
        
    }
    
    func updateTurnOnScreen() {
        
        displayTurn.text = myChessGame.isWhiteTurn ? "White's Turn" : "Black's Turn"
        
        displayTurn.textColor = myChessGame.isWhiteTurn ? UIColor.white : UIColor.black
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    

}
