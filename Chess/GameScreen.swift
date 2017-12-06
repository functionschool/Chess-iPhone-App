//
//  GameScreen.swift
//  Chess
//
//  Created by Kousei Richeson on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

//game screen

import UIKit

class GameScreen: UIViewController {
    
    //variables
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

    //function to load the game
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chessPieces = []
        myChessGame = ChessGame.init(viewController: self)
        print("SINGLEPLAYER: \(isAgainstAI)")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    //this function lets the user drag all the chess pieces on the board
    func drag(piece: UIChessPiece, usingGestureRecognizer gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        //center the chess piece after it is dropped on the board
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
            
            
            //check for validation moves
            if myChessGame.isMoveValid(piece: pieceDragged, fromIndex: sourceIndex, toIndex: destIndex) {
                
                myChessGame.move(piece: pieceDragged, fromIndex: sourceIndex, toIndex: destIndex, toOrigin: destinationOrigin)
                
                //check if game's over
                if myChessGame.isGameOver(){
                    displayWinner()
                    return
                }
                //check if the pawn should be promoted
                if shouldPromotePawn(){
                    promptForPawnPromotion()
                }
                else{
                    resumeGame() //dont prompt for pawn promotion if not possible
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
            
            //check to see if the game has ended,
            //if so display the winner
            if myChessGame.isGameOver() {
                displayWinner()
                return
            }
            
            if shouldPromotePawn(){
                promote(pawn: myChessGame.getPawnToBePromoted()!, into: "Queen")
            }
            
            displayCheckFunction()
            
            myChessGame.nextTurn() //update turn
            
            updateTurnOnScreen()
        }
    }
    
    //function promote
    //checks if pawn can be promoted, if so display a list
    //and ask user which piece to replace
    func promote(pawn pawnToBePromoted: Pawn, into pieceName: String){
        
        let pawnColor = pawnToBePromoted.color
        let pawnFrame = pawnToBePromoted.frame
        let pawnIndex = ChessBoard.indexOf(origin: pawnToBePromoted.frame.origin)
        
        myChessGame.theChessBoard.remove(piece: pawnToBePromoted) //remove the piece and replace after promtion
        
        //get every chess piece, for promotion
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
    //prompt pawn for promotion func
    //notifies user that pawn can be promoted, and displays an alert
    func promptForPawnPromotion(){
        if let pawnToPromote = myChessGame.getPawnToBePromoted(){
            
            let box = UIAlertController(title: "Pawn promotion", message: "Choose Piece", preferredStyle: UIAlertControllerStyle.alert)
            //ask to promote queen
            box.addAction(UIAlertAction(title: "Queen", style: UIAlertActionStyle.default, handler: { action in
                self.promote(pawn: pawnToPromote, into: action.title!)
                self.resumeGame()
            }))
            //ask to promote knight
            box.addAction(UIAlertAction(title: "Knight", style: UIAlertActionStyle.default, handler: { action in
                self.promote(pawn: pawnToPromote, into: action.title!)
                self.resumeGame()
            }))
            //ask to promote rook
            box.addAction(UIAlertAction(title: "Rook", style: UIAlertActionStyle.default, handler: { action in
                self.promote(pawn: pawnToPromote, into: action.title!)
                self.resumeGame()
            }))
            //ask to promote bishop
            box.addAction(UIAlertAction(title: "Bishop", style: UIAlertActionStyle.default, handler: { action in
                self.promote(pawn: pawnToPromote, into: action.title!)
                self.resumeGame()
            }))
            
            self.present(box, animated: true, completion: nil)
            
        }
    }
    //check to see if pawn can be promoted
    func shouldPromotePawn() -> Bool {
        return (myChessGame.getPawnToBePromoted() != nil)
    }
    //check to see if player is in check
    func displayCheckFunction(){
        let playerChecked = myChessGame.getPlayerChecked()
        
        //display a message that player is checked, if elegible
        if playerChecked != nil {
            displayCheck.text = playerChecked! + " is in check!"
        }
        else {
            displayCheck.text = nil
        }
    }
    
    //func displayWinner
    //this function pops up a box and lets the user
    //know that the game has ended.
    //It displays the winner and asks the user if they would
    //like to rematch or return to the main menu
    func displayWinner(){
        
        //display a game over message
        let box = UIAlertController(title: "Game Over", message: "\(myChessGame.winner!) wins", preferredStyle: UIAlertControllerStyle.alert)
        //display a back to main meny button
        box.addAction(UIAlertAction(title: "Back to main menu", style: UIAlertActionStyle.default, handler: { action in self.performSegue(withIdentifier: "backToMainMenu", sender: self) }))
        //display rematch button
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
    
    //updates turn on scren
    //changes color of text to match the players turn
    func updateTurnOnScreen() {
        
        displayTurn.text = myChessGame.isWhiteTurn ? "White's Turn" : "Black's Turn"
        
        displayTurn.textColor = myChessGame.isWhiteTurn ? UIColor.white : UIColor.black
        
    }
    
    //go back a screen, if the back button is pressed
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    

}
