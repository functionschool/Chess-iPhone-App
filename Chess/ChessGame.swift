//
//  ChessGame.swift
//  Chess
//
//  Created by Kousei Richeson on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit

class ChessGame: NSObject {
    
    var theChessBoard: ChessBoard!
    var isWhiteTurn = true
    var winner: String?
    
    init(viewController: GameScreen) {
        theChessBoard = ChessBoard.init(viewController: viewController)
    }
    
    func getArrayOfPossibleMoves(forPiece piece: UIChessPiece) -> [BoardIndex]{
        
        var arrayOfMoves: [BoardIndex] = []
        let source = theChessBoard.getIndex(forChessPiece: piece)!
        
        for row in 0..<theChessBoard.ROWS{
            for col in 0..<theChessBoard.COLS{
                
                let dest = BoardIndex(row: row, col: col)
                
                if isNormalMoveValid(forPiece: piece, fromIndex: source, toIndex: dest){
                    arrayOfMoves.append(dest)
                }
            }
        }
        
        return arrayOfMoves
    }
    
    func makeAIMove(){
        
        //get the white king as possible
        //We assume the AI is always black
        if getPlayerChecked() == "White" {
            for aChessPiece in theChessBoard.vc.chessPieces{
                if aChessPiece.color == UIColor.black {
                    
                    guard let source = theChessBoard.getIndex(forChessPiece: aChessPiece) else {
                        continue
                    }
                    
                    guard let dest = theChessBoard.getIndex(forChessPiece: theChessBoard.whiteKing) else {
                        continue
                    }
                    
                    if isNormalMoveValid(forPiece: aChessPiece, fromIndex: source, toIndex: dest) {
                        move(piece: aChessPiece, fromIndex: source, toIndex: dest, toOrigin: theChessBoard.whiteKing.frame.origin)
                        return
                    }
                    
                }
            }
        }
        
        //attack undefended white piece, if there is no check on the black king
        if getPlayerChecked() == nil {
            if didAttackUndefendedPiece(){
                return
            }
        }
        
        var moveFound = false
        var numberOfTriesToEscapeCheck = 0
        
        searchForMoves: while moveFound == false {
            
            //get random piece
            let randChessPieceArrayIndex = Int(arc4random_uniform(UInt32(theChessBoard.vc.chessPieces.count)))
            let chessPieceToMove = theChessBoard.vc.chessPieces[randChessPieceArrayIndex]
            
            guard chessPieceToMove.color == UIColor.black else{
                continue
            }
            
            //get a random move
            let movesArray = getArrayOfPossibleMoves(forPiece: chessPieceToMove)
            guard movesArray.isEmpty == false else {
                continue searchForMoves
            }
            
            let randMovesArrayIndex = Int(arc4random_uniform(UInt32(movesArray.count)))
            let randDestIndex = movesArray[randMovesArrayIndex]
            let destOrigin = ChessBoard.getFrame(forRow: randDestIndex.row, forCol: randDestIndex.col).origin
            
            guard let sourceIndex = theChessBoard.getIndex(forChessPiece: chessPieceToMove) else {
                continue searchForMoves
            }
            
            //simulate the move on board matrix
            let pieceTaken = theChessBoard.board[randDestIndex.row][randDestIndex.col]
            theChessBoard.board[randDestIndex.row][randDestIndex.col] = theChessBoard.board[sourceIndex.row][sourceIndex.col]
            theChessBoard.board[sourceIndex.row][sourceIndex.col] = Dummy()
            
            if numberOfTriesToEscapeCheck < 1000{
                guard getPlayerChecked() != "Black" else {
                    //undo move
                    theChessBoard.board[sourceIndex.row][sourceIndex.col] = theChessBoard.board[randDestIndex.row][randDestIndex.col]
                    theChessBoard.board[randDestIndex.row][randDestIndex.col] = pieceTaken
                    
                    numberOfTriesToEscapeCheck += 1
                    continue searchForMoves
                }
            }
            
            //undo move
            theChessBoard.board[sourceIndex.row][sourceIndex.col] = theChessBoard.board[randDestIndex.row][randDestIndex.col]
            theChessBoard.board[randDestIndex.row][randDestIndex.col] = pieceTaken

            //try best move, if any good one
            if didBestMoveForAI(forScoreOver: 2){
                return
            }
            
            move(piece: chessPieceToMove, fromIndex: sourceIndex, toIndex: randDestIndex, toOrigin: destOrigin)
            
            moveFound = true
            
        }
    }
    
    func getScoreForLocation(ofPiece aChessPiece: UIChessPiece) -> Int {
        var locationScore = 0
        
        guard let source = theChessBoard.getIndex(forChessPiece: aChessPiece) else {
            return 0
        }
        
        for row in 0..<theChessBoard.ROWS{
            for col in 0..<theChessBoard.COLS{
                if theChessBoard.board[row][col] is UIChessPiece{
                    let dest = BoardIndex(row: row, col: col)
                    if isNormalMoveValid(forPiece: aChessPiece, fromIndex: source, toIndex: dest, canAttackAllies: true){
                        locationScore += 1
                    }
                }
            }
        }
        
        return locationScore
        
    }
    
    func didBestMoveForAI(forScoreOver limit: Int) -> Bool{
        return false
    }
    
    func didAttackUndefendedPiece() -> Bool {
        
        loopThatTraversesChessPieces: for attackingChessPiece in theChessBoard.vc.chessPieces {
            
            guard attackingChessPiece.color == UIColor.black else {
                continue loopThatTraversesChessPieces
            }
            
            guard let source = theChessBoard.getIndex(forChessPiece: attackingChessPiece) else {
                continue loopThatTraversesChessPieces
            }
            
            let possibleDestinations = getArrayOfPossibleMoves(forPiece: attackingChessPiece)
            
            searchForUndefendedWhitePieces: for attackedIndex in possibleDestinations{
                guard let attackedChessPiece = theChessBoard.board[attackedIndex.row][attackedIndex.col] as? UIChessPiece else {
                    continue searchForUndefendedWhitePieces
                }
                
                for row in 0..<theChessBoard.ROWS {
                    for col in 0..<theChessBoard.COLS{
                        guard let defendingChessPiece = theChessBoard.board[row][col] as? UIChessPiece, defendingChessPiece.color == UIColor.white else {
                            continue
                        }
                        
                        let defendingIndex = BoardIndex(row: row, col: col)
                        
                        if isNormalMoveValid(forPiece: defendingChessPiece, fromIndex: defendingIndex, toIndex: attackedIndex, canAttackAllies: true){
                            continue searchForUndefendedWhitePieces
                        }
                    }
                }
                
                move(piece: attackingChessPiece, fromIndex: source, toIndex: attackedIndex, toOrigin: attackedChessPiece.frame.origin)
                return true
                
            }
            
        }
        
        return false
    }
    
    func getPawnToBePromoted() -> Pawn?{
        for chessPiece in theChessBoard.vc.chessPieces{
            if let pawn = chessPiece as? Pawn{
                let pawnIndex = ChessBoard.indexOf(origin: pawn.frame.origin)
                if pawnIndex.row == 0 || pawnIndex.row == 7{
                    return pawn
                }
            }
        }
        return nil
    }
    
    func getPlayerChecked() -> String? {
        
        guard let whiteKingIndex = theChessBoard.getIndex(forChessPiece: theChessBoard.whiteKing)
        else {
            return nil
        }
        
        guard let blackKingIndex = theChessBoard.getIndex(forChessPiece: theChessBoard.blackKing)
            else {
                return nil
        }
        
        for row in 0..<theChessBoard.ROWS{
            for col in 0..<theChessBoard.COLS{
                if let chessPiece = theChessBoard.board[row][col] as? UIChessPiece{
                    let chessPieceIndex = BoardIndex(row: row, col: col)
                    
                    if chessPiece.color == UIColor.black {
                        if isNormalMoveValid(forPiece: chessPiece, fromIndex: chessPieceIndex, toIndex: whiteKingIndex){
                            return "White"
                        }
                    }
                    else {
                        if isNormalMoveValid(forPiece: chessPiece, fromIndex: chessPieceIndex, toIndex: blackKingIndex) {
                            return "Black"
                        }
                    }
                }
            }
        }
        
        return nil
        
    }
    
    func isGameOver() -> Bool {
        if didSomebodyWin() {
            return true
        }
        return false
    }
    
    func didSomebodyWin() -> Bool {
        if !theChessBoard.vc.chessPieces.contains(theChessBoard.whiteKing){
            winner = "Black"
            return true
        }
        
        if !theChessBoard.vc.chessPieces.contains(theChessBoard.blackKing){
            winner = "White"
            return true
        }
        
        return false
    }
    
    func move(piece chessPieceToMove: UIChessPiece, fromIndex sourceIndex: BoardIndex, toIndex destIndex: BoardIndex, toOrigin destOrigin: CGPoint){
        
        //get initial chess piece frame
        let initialChessPieceFrame = chessPieceToMove.frame
        
        //remove piece at the destination
        let pieceToRemove = theChessBoard.board[destIndex.row][destIndex.col]
        theChessBoard.remove(piece: pieceToRemove)
        
        //place the chess piece at destination
        theChessBoard.place(chessPiece: chessPieceToMove, toIndex: destIndex, toOrigin: destOrigin)
        
        //put the dummy piece in the empty source title
        theChessBoard.board[sourceIndex.row][sourceIndex.col] = Dummy(frame: initialChessPieceFrame)
    }
    
    
    func isMoveValid(piece: UIChessPiece, fromIndex sourceIndex: BoardIndex, toIndex destIndex: BoardIndex) -> Bool {
        
        //if conditon is not met we return false
        guard isMoveOnBoard(forPieceFrom: sourceIndex, thatGoesTo: destIndex) else {
            print("MOVE IS NOT ON THE BOARD")
            return false
        }
        
        guard isTurnColor(sameAsPiece: piece) else {
            print("WRONG TURN")
            return false
        }
        
        return isNormalMoveValid(forPiece: piece, fromIndex: sourceIndex, toIndex: destIndex)
    }
    
    func isNormalMoveValid(forPiece piece: UIChessPiece, fromIndex source:BoardIndex, toIndex dest: BoardIndex, canAttackAllies: Bool = false) -> Bool {
        
        guard source != dest else {
            print("MOVING PIECE ON ITS CURRENT POSTITION")
            return false
        }
        
        if !canAttackAllies{
            guard !isAttackingAlliedPiece(sourceChessPiece: piece, destIndex: dest) else {
                print("ATTACKING ALLIED PIECE")
                return false
            }
        }
        
        switch piece {
        case is Pawn:
            return isMoveValid(forPawn: piece as! Pawn, fromIndex: source, toIndex: dest)
        case is Rook, is Bishop, is Queen:
            return isMoveValid(forRookOrBishopOrQueen: piece, fromIndex: source, toIndex: dest)
        case is Knight:
            if !(piece as! Knight).doesMoveSeemFine(fromIndex: source, toIndex: dest) {
                return false
            }
        case is King:
            return isMoveValid(forKing: piece as! King, fromIndex: source, toIndex: dest)
        default:
            break
        }
        
        return true
        
    }
    
    func isMoveValid(forPawn pawn: Pawn, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
        
        if !pawn.doesMoveSeemFine(fromIndex: source, toIndex: dest) {
            return false
        }
        
        //non-attacking move
        if source.col == dest.col {
            
            //advance by 2
            if pawn.triesToAdvanceBy2 {
                var moveForward = 0
                
                if pawn.color == UIColor.black {
                    moveForward = 1
                }
                else {
                    moveForward = -1
                }
                
                if theChessBoard.board[dest.row][dest.col] is Dummy && theChessBoard.board[dest.row - moveForward][dest.col] is Dummy {
                    return true
                }
            }
                
            //advance by 1
            else {
                if theChessBoard.board[dest.row][dest.col] is Dummy {
                    return true
                }
            }
        }
        
        //attacking move
        else {
            if !(theChessBoard.board[dest.row][dest.col] is Dummy) {
                return true
            }
        }
        
        return false
    }
    
    func isMoveValid(forRookOrBishopOrQueen piece: UIChessPiece, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
        
        switch piece {
        case is Rook:
            if !(piece as! Rook).doesMoveSeemFine(fromIndex: source, toIndex: dest) {
                return false
            }
        case is Bishop:
            if !(piece as! Bishop).doesMoveSeemFine(fromIndex: source, toIndex: dest) {
                return false
            }
        default:
            if !(piece as! Queen).doesMoveSeemFine(fromIndex: source, toIndex: dest) {
                return false
            }
        }
        
        //Queen or bishop from 1, 1 to 3, 3 (1,1 then 2,2 then 3,3)
        //Queen or rook from 1, 5 to 1, 2 (1,5 then 1,4 then 1,3 then 1,2)
        
        //Increase every row by 1 everytime we make move
        var increaseRow = 0
        
        //We cant divide by zero so we need to check that
        if dest.row - source.row != 0 {
            increaseRow = (dest.row - source.row) / abs(dest.row - source.row)
        }
        
        var increaseCol = 0
        
        if dest.col - source.col != 0 {
            increaseCol = (dest.col - source.col) / abs(dest.col - source.col)
        }
        
        var nextRow = source.row + increaseRow
        var nextCol = source.col + increaseCol
        
        while nextRow != dest.row || nextCol != dest.col {
            
            if !(theChessBoard.board[nextRow][nextCol] is Dummy) {
                return false
            }
            
            nextRow += increaseRow
            nextCol += increaseCol
            
        }
        
        return true
        
    }
    
    func isMoveValid(forKing king: King, fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
        
        if !(king.doesMoveSeemFine(fromIndex: source, toIndex: dest)) {
            return false
        }
        
        if isOpponentKing(nearKing: king, thatGoesTo: dest){
            return false
        }
        
        return true
        
    }
    
    func isOpponentKing(nearKing movingKing: King, thatGoesTo destIndexOfMovingKing: BoardIndex) -> Bool {
        
        //Find out the opponent king
        var theOpponentKing: King
        
        if movingKing == theChessBoard.whiteKing{
            theOpponentKing = theChessBoard.blackKing
        }
        else{
            theOpponentKing = theChessBoard.whiteKing
        }
        
        //get index of oppenent king
        var indexOfOpponentKing: BoardIndex!
        
        for row in 0..<theChessBoard.ROWS{
            for col in 0..<theChessBoard.COLS {
                if let aKing = theChessBoard.board[row][col] as? King, aKing == theOpponentKing {
                    indexOfOpponentKing = BoardIndex(row: row, col: col)
                }
            }
        }
        
        //compute absolute difference between kings
        let differenceInRows = abs(indexOfOpponentKing.row - destIndexOfMovingKing.row)
        let differenceInCols = abs(indexOfOpponentKing.col - destIndexOfMovingKing.col)
        
        //if they are too close, the move is invalid
        if case 0...1 = differenceInRows {
            if case 0...1  = differenceInCols {
                return true
            }
        }
        
        return false
        
    }
    
    func isAttackingAlliedPiece(sourceChessPiece: UIChessPiece, destIndex: BoardIndex) -> Bool {
        
        let destPiece: Piece = theChessBoard.board[destIndex.row][destIndex.col]
        
        guard !(destPiece is Dummy) else {
            return false
        }
        
        let destChessPiece = destPiece as! UIChessPiece
        
        return (sourceChessPiece.color == destChessPiece.color)
        
    }
    
    func nextTurn() {
        
        isWhiteTurn = !isWhiteTurn
        
    }
    
    func isTurnColor(sameAsPiece piece: UIChessPiece) -> Bool {
        
        if piece.color == UIColor.black {
            
            if !isWhiteTurn {
                return true
            }
            
        }
        
        else {
            
            if isWhiteTurn {
                return true
            }
            
        }
        
        return false
        
    }
    
    func isMoveOnBoard(forPieceFrom sourceIndex: BoardIndex, thatGoesTo destIndex: BoardIndex) -> Bool {
        
        //Is it between rows 0 and 7?
        if case 0 ..< theChessBoard.ROWS = sourceIndex.row {
            if case 0 ..< theChessBoard.COLS = sourceIndex.col {
                if case 0 ..< theChessBoard.ROWS = destIndex.row {
                    if case 0 ..< theChessBoard.COLS = destIndex.col {
                        return true
                    }
                }
            }
        }
        
        return false
        
    }
    
}
