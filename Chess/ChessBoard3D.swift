//
//  ChessGame.swift
//  Chess
//
//  Created by Kousei Richeson & Gilbert Carrillo on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit
import SceneKit
class ChessGame3D: NSObject {

    //variables
    var theChessBoard: BoardSetUp!
    var whiteTurn = true
    var winner: String? //displays winner's name
    
    init(viewController: GameViewController) {
        theChessBoard = BoardSetUp.init(viewController: viewController)
    }
    
    

    // this function gets an array of all possible moves for the AI
    func getArrayOfPossibleMoves(piece: SCNNode) -> [[Int]]{

        var arrayOfMoves: [[Int]] = []
        let source = theChessBoard.getIndex(objectToFind: piece)

        //loop through the board, to get possible moves
        for row in 0..<8{
            for col in 0..<8{

                
                //check to see if the possible move is valid
                if isMoveValid(chessPiece: piece,sourcecol: source[1], sourcerow: source[0], destcol: col, destrow: row) {
                    arrayOfMoves.append([row, col]) //if valid, add it to array of possibles
                }
            }
        }

        return arrayOfMoves //return possible moves
    }


    //makes AI move, based off the best move found in the array
    func makeAIMove(){

        //get the white king as possible
        //We assume the AI is always black
        if getPlayerChecked() == "White" {
          //  print("I shouldn't be here")
            for row in 0..<8 {
                for col in 0..<8 {
                    let aChessPiece = place[row][col]
                    if (isWhite(Piece: aChessPiece)) || place[row][col] == mainScene!.rootNode {
                        continue
                    }
                    
                    //move AI
                    let WhiteKing = mainScene.rootNode.childNode(withName: "King_White", recursively: true)!
                    let dest = theChessBoard.getIndex(objectToFind: WhiteKing)
                    if dest[0] == 8 {
                        continue
                    }
                    
                    //check if the move is valid, for the AI
                    if isMoveValid(chessPiece: aChessPiece, sourcecol: col, sourcerow: row, destcol: dest[1], destrow: dest[0]) {
                        Current = aChessPiece
                        move(resultchild: WhiteKing.childNodes[0])
                        print("AI: ATTACK WHITE KING")
                        return
                    }

                }
            }
        }
        
        //attack undefended white piece, if there is no check on the black king
        if getPlayerChecked() == nil {
            if didAttackUndefendedPiece(){
                print("AI: ATTACK UNDEFENDED PIECE")
                return
            }
        }

        var moveFound = false
        var numberOfTriesToEscapeCheck = 0

        searchForMoves: while moveFound == false {
            
            //get random piece
            let randSourceIndexRow = Int(arc4random_uniform(UInt32(8)))
            let randSourceIndexCol = Int(arc4random_uniform(UInt32(8)))
            let chessPieceToMove = place[randSourceIndexRow][randSourceIndexCol]
            //next move for AI
            if ((isWhite(Piece: chessPieceToMove)) || (chessPieceToMove == mainScene!.rootNode) ){
                continue
            }

            //get a random move
            let movesArray = getArrayOfPossibleMoves(piece: chessPieceToMove)
            guard movesArray.isEmpty == false else {
                continue searchForMoves //continue to find a move for the AI
            }
            //make a random move
            let randMovesArrayIndex = Int(arc4random_uniform(UInt32(movesArray.count)))
            //get random desination
            let randDestIndex = movesArray[randMovesArrayIndex]

            //simulate the move on board matrix
            let pieceTaken = place[randDestIndex[0]][randDestIndex[1]]
            place[randDestIndex[0]][randDestIndex[1]] = place[randSourceIndexRow][randSourceIndexCol]
            place[randSourceIndexRow][randSourceIndexCol] = mainScene.rootNode

            if numberOfTriesToEscapeCheck < 1000{
                guard getPlayerChecked() != "Black" else {
                    //undo move
                    place[randSourceIndexRow][randSourceIndexCol] = place[randDestIndex[0]][randDestIndex[1]]
                    place[randDestIndex[0]][randDestIndex[1]] = pieceTaken

                    numberOfTriesToEscapeCheck += 1
                    continue searchForMoves
                }
            }

            //undo move
            place[randSourceIndexRow][randSourceIndexCol] = place[randDestIndex[0]][randDestIndex[1]]
            place[randDestIndex[0]][randDestIndex[1]] = pieceTaken
            
            //try best move, if any good one
            if didBestMoveForAI(forScoreOver: 2){
                print("AI: BEST MOVE")
                return
            }

            //if no move is found for the AI from the array, make a random move
            if numberOfTriesToEscapeCheck == 0 || numberOfTriesToEscapeCheck == 1000 {
                print("AI: SIMPLE RANDOM MOVE")
            }
            else {
                //recongize check and try to escape
                print("AI: RANDOM MOVE TO ESCAPE CHECK")
            }
            Current = chessPieceToMove
            print(randDestIndex[0], randDestIndex[1], chessPieceToMove.name!)
            let tileID = board[randDestIndex[0]][randDestIndex[1]]
            let tile = mainScene.rootNode.childNode(withName: tileID, recursively: true)
            
            move(resultchild: tile!)

            moveFound = true

        }
    }

    //gets the score for the location of the chess piece
    func getScoreForLocation(aChessPiece: SCNNode) -> Int {
        var locationScore = 0
        
        let source = theChessBoard.getIndex(objectToFind: aChessPiece)
        if(source[0] == 8) {
            return 0
        }
        //loop throught the whole board
        for row in 0..<8{
            for col in 0..<8{
                if place[row][col] != mainScene!.rootNode {
                    //check validation
                    if isMoveValid(chessPiece: aChessPiece, sourcecol: source[1], sourcerow: source[0], destcol: col, destrow: row){
                        locationScore += 1
                    }
                }
            }
        }

        return locationScore
        
    }
    //boolean function to check if the AI did the best move possible
    func didBestMoveForAI(forScoreOver limit: Int) -> Bool{
        
        guard getPlayerChecked() != "Black" else{
            return false
        }
        //variables for best move for the AI
        var bestNetScore = -10
        var bestPiece: SCNNode!
        var bestDest: [Int]!
        //move the chess piece based off the best one chosen to move
        for row in 0..<8 {
            for col in 0..<8 {
                let aChessPiece = place[row][col]
                if (isWhite(Piece: aChessPiece)) || place[row][col] == mainScene!.rootNode {
                    continue
                }

            //set location for the best move piece
                let actualLocationScore = getScoreForLocation(aChessPiece: aChessPiece)
                let possibleDestinations = getArrayOfPossibleMoves(piece: aChessPiece)

            for dest in possibleDestinations{

                var nextLocationScore = 0

                //Simulate move on board
                let pieceTaken = place[dest[0]][dest[1]]
                place[dest[0]][dest[1]] = place[row][col]
                place[row][col] = mainScene.rootNode
                print("I'm right here!", row, col)
                nextLocationScore = getScoreForLocation(aChessPiece: aChessPiece)

                let netScore = nextLocationScore - actualLocationScore

                //check for the next best move
                if netScore > bestNetScore {
                    bestNetScore = netScore
                    bestPiece = aChessPiece
                    bestDest = dest
                }

                //undo move
                place[row][col] = place[dest[0]][dest[1]]
                place[dest[0]][dest[1]] = pieceTaken

            }

        }
        }
        if bestNetScore > limit {
            Current = bestPiece
            move(resultchild: mainScene.rootNode.childNode(withName: board[bestDest[0]][bestDest[1]], recursively: true)!)
            print("AI: BEST NET SCORE: \(bestNetScore)")
            return true
        }
        return false
    
    }
    //check to see if the AI move attacked an undefended piece
    func didAttackUndefendedPiece() -> Bool {
       // print("Going In")
        loopThatTraversesChessPieceRow: for row in 0..<8 {
            loopThatTraversesChessPieces: for col in 0..<8 {
                let attackingChessPiece = place[row][col]
                if (isWhite(Piece: attackingChessPiece)) || place[row][col] == mainScene!.rootNode {
                    continue loopThatTraversesChessPieces
                }

            //check possible destinations on the board
                let possibleDestinations = getArrayOfPossibleMoves(piece: attackingChessPiece)

            //check for an undefended piece to mark as the best move
            searchForUndefendedWhitePieces: for attackedIndex in possibleDestinations{
                if !(isWhite(Piece: place[attackedIndex[0]][attackedIndex[1]])){
                    continue searchForUndefendedWhitePieces
                }
                let attackedChessPiece = place[attackedIndex[0]][attackedIndex[1]]
                //loop through the board for possible destinations
                for ro in 0..<8 {
                    for co in 0..<8{
                        if !isWhite(Piece: place[ro][co]){
                            print("defender", ro, co)
                            continue
                        }
                        let defendingChessPiece = place[ro][co]
                        //check if the move is defended
                      //  print("What up", ro, co)
                        if isMoveValid(chessPiece: defendingChessPiece, sourcecol: co, sourcerow: ro, destcol: attackedIndex[0], destrow: attackedIndex[0]){
                            continue searchForUndefendedWhitePieces
                        }
                    }
                }
                //move the best piece for the AI
                Current = attackingChessPiece
                print("Attack index", row, col, attackedIndex[0], attackedIndex[1])
                move(resultchild: attackedChessPiece.childNodes[0])
                return true

            }
            }

        }

        return false
    }
//    //pawn promotion for AI
//    func getPawnToBePromoted() -> Pawn?{
//        for chessPiece in theChessBoard.vc.chessPieces{
//            if let pawn = chessPiece as? Pawn{
//                let pawnIndex = ChessBoard.indexOf(origin: pawn.frame.origin)
//                if pawnIndex.row == 0 || pawnIndex.row == 7{
//                    return pawn
//                }
//            }
//        }
//        return nil
//    }
    
    //player is in check for AI
    func getPlayerChecked() -> String? {
        //initialize whiteking location
        let WhiteKing: SCNNode = mainScene.rootNode.childNode(withName: "King_White", recursively: true)!
        let BlackKing: SCNNode = mainScene.rootNode.childNode(withName: "King_Black", recursively: true)!
        let whiteKingIndex = theChessBoard.getIndex(objectToFind: WhiteKing)

        let blackKingIndex = theChessBoard.getIndex(objectToFind: BlackKing)

        //loop through whole board to get the AI in check
        for row in 0..<8{
            for col in 0..<8{
                if place[row][col] != mainScene.rootNode{
                    let chessPiece = place[row][col]
                    let chessPieceIndex:[Int] = [row, col]

                    if !(isWhite(Piece: chessPiece)) {
                        if isMoveValid(chessPiece: chessPiece,sourcecol: chessPieceIndex[1], sourcerow: chessPieceIndex[0], destcol: whiteKingIndex[1], destrow: whiteKingIndex[0]){
                            print(chessPiece.name!)
                            return "White"
                        }
                    }
                    else {
                        if isMoveValid(chessPiece: chessPiece,sourcecol: chessPieceIndex[1], sourcerow: chessPieceIndex[0], destcol: blackKingIndex[1], destrow: blackKingIndex[0]) {
                            return "Black"
                        }
                    }
                }
            }
        }

        return nil

    }
    //check if somebody won, to end game
    func isGameOver() -> Bool {
        if didSomebodyWin() {
            return true
        }
        return false
    }
    
    //check to see if somebody won, if so
    //set the winner to them
    func didSomebodyWin() -> Bool {
        if (mainScene!.rootNode.childNode(withName: "King_White", recursively: true) == nil){
            winner = "Black"
            return true //return if black won
        }
        
        if (mainScene!.rootNode.childNode(withName: "King_Black", recursively: true) == nil){
            winner = "White"
            return true //return if white won
        }
        
        return false //nobody won
    }
    
    

    //move the chess pieces
        func move(resultchild: SCNNode)-> Bool{
        
                var shouldPlaySoundEffects = false
            
        let result = resultchild.parent
        //Check if tile was tapped
            if(validSecondTap(result: result!)){
            var index:[Int] = []
            //get location of current
            index = theChessBoard.getIndex(objectToFind: Current)
                let cX = index[0]
                let cZ = index[1]
                if result?.name == "group_0"{
            //Get tile location
                index = theChessBoard.getIndex(objectToFind: resultchild)
            }
            else {  //get piece to attack location
                    index = theChessBoard.getIndex(objectToFind: result!)
            }
                let x = index[0]
                let y = index[1]
             //   print("Fancy seeing you here")
            if (x != 8 && isMoveValid(chessPiece: Current, sourcecol: cZ, sourcerow: cX, destcol: y, destrow:x)){
                //Check if there is a piece in location
                print("moved")
                if(isWhite(Piece: place[x][y]) != whiteTurn &&
                    place[x][y] != mainScene.rootNode){
                    //kill piece
                    place[x][y].removeFromParentNode()
                    place[x][y]=mainScene.rootNode
                    shouldPlaySoundEffects = true
                }
                
                //Check if location is empty either cause we killed the other guy or there was never one to begin with
                if (place[x][y]==mainScene.rootNode){
                    //move piece
                    //print("No really")
                    theChessBoard.placePiece(cX: cX, cZ: cZ, x: x, y: y)
                    nextTurn()
                    return true
                }
            }
        }
            return false
    }
    


    func isMoveValid(chessPiece: SCNNode,sourcecol: Int, sourcerow: Int, destcol: Int, destrow:Int) -> Bool {
        //print("here")
     //   print(sourcerow, sourcecol, destrow, destcol)
        //validation moves for every single chess piece
        if ((isWhite(Piece: place[destrow][destcol]) == isWhite(Piece: place[sourcerow][sourcecol])) && place[destrow][destcol] != mainScene!.rootNode){
           // print("No friendly fire",sourcerow, sourcecol, destrow, destcol)
            return false
        }
        if(isPawn(piece: chessPiece.name!)){
            return allowedMovePawn(sourcecol: sourcecol, sourcerow: sourcerow, destcol : destcol, destrow: destrow, color: chessPiece.name!)
        }
        if(isRBQ(piece: chessPiece.name!)){
            return allowedMoveRBQ(sourcecol: sourcecol, sourcerow: sourcerow, destcol : destcol, destrow: destrow, piece: chessPiece)
            }
        if(isKnight(piece: chessPiece.name!)) {
            if !(allowedMoveKnight(sourcecol: sourcecol, sourcerow: sourcerow, destcol : destcol, destrow: destrow)) {
                return false
            }
        }
        if(isKing(piece: chessPiece.name!)) {
            return allowedMoveKing(sourcecol: sourcecol, sourcerow: sourcerow, destcol : destcol, destrow: destrow, king: chessPiece)
        }

        return true
}
    //check validation moves for the pawn piece
    //check if the move the user is making, is valid for this certain piece
    func allowedMovePawn(sourcecol: Int, sourcerow: Int, destcol : Int, destrow:Int, color: String) -> Bool {
        
        //get correct direction of movement
        var moveForward = 0
        
        if color == "Pawn_Black" {
            moveForward = 1
        }
        else {
            moveForward = -1
        }
        
        //check advance by 2
       // print(sourcecol, destcol)
        if sourcecol == destcol {
            if (sourcerow == 1 && destrow == 3 && color == "Pawn_Black") || (sourcerow == 6 && destrow == 4 && color == "Pawn_White" ) {//print("why")
                if(place[destrow][destcol]==mainScene.rootNode && place[destrow-moveForward][destrow] == mainScene.rootNode){
                    return true
                }
              //  print("why")
                return false
            }
        }
        
        
        
        //check advance by 1
        //more validation moves
        
        if destrow == sourcerow + moveForward {
            //non-attacking
            if (destcol == sourcecol){
                return (place[destrow][destcol] == mainScene.rootNode)//Move if space is empty
            }
            //attaattacking
            if (destcol == sourcecol - 1) ||  (destcol == sourcecol + 1) {
                return !(place[destrow][destcol] == mainScene.rootNode) //Move if piece to attack
            }
        }
        
        return false //dont move if invalid move is tried
    }

    //validation moves for rook or bishop
    //validation moves are the same for these two
    func allowedMoveRBQ(sourcecol: Int, sourcerow: Int, destcol : Int, destrow:Int, piece: SCNNode) -> Bool {

            if(piece.name == "Rook_White" || piece.name == "Rook_Black" ){
                if !(allowedMoveRook(sourcecol: sourcecol, sourcerow: sourcerow, destcol : destcol, destrow:destrow)) {
                    return false
                }
            }
            if(piece.name == "Bishop_White" || piece.name == "Bishop_Black" ){
                if !(allowedMoveBishop(sourcecol: sourcecol, sourcerow: sourcerow, destcol : destcol, destrow:destrow)) {
                    return false
                }
            }
            else{
                if !(allowedMoveQueen(sourcecol: sourcecol, sourcerow: sourcerow, destcol : destcol, destrow:destrow)) {
                    return false
                }
            }

        //Queen or bishop from 1, 1 to 3, 3 (1,1 then 2,2 then 3,3)
        //Queen or rook from 1, 5 to 1, 2 (1,5 then 1,4 then 1,3 then 1,2)

        //Increase every row by 1 everytime we make move
        var increaseRow = 0

        //We cant divide by zero so we need to check that
        if destrow - sourcerow != 0 {
            increaseRow = (destrow - sourcerow) / abs(destrow - sourcerow)
        }

        var increaseCol = 0

        if destcol - sourcecol != 0 {
            increaseCol = (destcol - sourcecol) / abs(destcol - sourcecol)
        }

        var nextRow = sourcerow + increaseRow
        var nextCol = sourcecol + increaseCol

        while nextRow != destrow || nextCol != destcol {

            if !(place[nextRow][nextCol] == mainScene.rootNode) {
                return false
            }

            nextRow += increaseRow
            nextCol += increaseCol

        }

        return true

    }
    
    
    func allowedMoveRook(sourcecol: Int, sourcerow: Int, destcol : Int, destrow:Int) -> Bool {
      //  print("Queen")
        if sourcerow == destrow || sourcecol == destcol {
            return true // valid move
        }
        
        return false //move is invalid
        
    }
    
    func allowedMoveBishop(sourcecol: Int, sourcerow: Int, destcol : Int, destrow:Int) -> Bool {
     //   print("Bishop")
        if abs(destrow - sourcerow) == abs(destcol - sourcecol) {
            return true //move is valid
        }
        
        return false //dont move if invalid move is tried
    }
    
    func allowedMoveQueen(sourcecol: Int, sourcerow: Int, destcol : Int, destrow:Int) -> Bool {
      //  print("Queen")
        if sourcerow == destrow || sourcecol == destcol {
            return true //valid move
        }
        
        if abs(destrow - sourcerow) == abs(destcol - sourcecol) {
            return true //valid move
        }
        
        return false //invalid move
        
    }
    
    func allowedMoveKnight(sourcecol: Int, sourcerow: Int, destcol : Int, destrow:Int) -> Bool {
       // print("Knight")
        //check validation moves
        let validMoves = [(sourcerow-1, sourcecol+2), (sourcerow-2, sourcecol+1), (sourcerow-2, sourcecol-1), (sourcerow-1, sourcecol-2), (sourcerow+1, sourcecol-2), (sourcerow+2, sourcecol-1), (sourcerow+2, sourcecol+1), (sourcerow+1, sourcecol+2)]
        
        for(validRow, validCol) in validMoves {
            
            if destrow == validRow && destcol == validCol {
                return true //move is valid
            }
            
        }
        
        return false  //dont move if invalid move is tried
        
    }
    //check validation moves for the king
    func allowedMoveKing(sourcecol: Int, sourcerow: Int, destcol : Int, destrow:Int, king: SCNNode) -> Bool {
        //print("I'm king")
        let differenceInRows = abs(destrow - sourcerow)
        let differenceInCols = abs(destcol - sourcecol)
        print(sourcerow, sourcecol, destrow, destcol )
        if case 0...1 = differenceInRows {
            print("1 up or down")
            if case 0...1 = differenceInCols {
                print("1 to the side")
            }
            else {
                print("not legal")
                return false //invalid move
            }
        }
        
        else {
            print("not legal")
            return false //invalid move
        }

        if isOpponentKing(destcol : destcol, destrow:destrow, movingKing: king){
            return false
        }

        return true

    }
    //check to see if the opponent king is near on the board
    func isOpponentKing(destcol : Int, destrow:Int, movingKing: SCNNode) -> Bool {

        //Find out the opponent king
        var theOpponentKing: SCNNode

        if movingKing.name == "King_White"{
            theOpponentKing = mainScene!.rootNode.childNode(withName: "King_Black", recursively: true)!
        }
        else{
            theOpponentKing = mainScene!.rootNode.childNode(withName: "King_White", recursively: true)!
        }


        //get index of opponent King
        var index = theChessBoard.getIndex(objectToFind: theOpponentKing)

        //compute absolute difference between kings
        let differenceInCols = abs(index[1] - destcol)
        let differenceInRows = abs(index[0] - destrow)

        //if they are too close, the move is invalid
        if case 0...1 = differenceInRows {
            if case 0...1  = differenceInCols {
                return true
            }
        }

        return false

    }

    
    
    //function promote
    //checks if pawn can be promoted, if so display a list
    //and ask user which piece to replace
    func promote(pawnToBePromoted: SCNNode, into pieceName: String){
        
        let pawnColor = isWhite(Piece: pawnToBePromoted)
        let pawnIndex = theChessBoard.getIndex(objectToFind: pawnToBePromoted)
        
        pawnToBePromoted.removeFromParentNode() //remove the piece and replace after promtion
        
        //get every chess piece, for promotion
        switch pieceName {
        case "Queen":
            let node = theChessBoard.createQueenNode(x: pawnColor)
            mainScene.rootNode.addChildNode(node)
            Current = node
        case "Knight":
            let node = theChessBoard.createKnightNode(x: pawnColor)
            mainScene.rootNode.addChildNode(node)
            Current = node

        case "Rook":
            let node = theChessBoard.createRookNode(x: pawnColor)
            mainScene.rootNode.addChildNode(node)
            Current = node

        case "Bishop":
            let node = theChessBoard.createBishopNode(x: pawnColor)
            mainScene.rootNode.addChildNode(node)
            Current = node

        default:
            break
        }
        Current?.runAction(SCNAction.move(to: SCNVector3(originX-distance * Float(pawnIndex[1]), originY, originZ-distance * Float(pawnIndex[0]) ), duration: TimeInterval(0)))
        place[pawnIndex[0]][pawnIndex[1]] = Current
        
    }
    //update turn
    func nextTurn() {

        whiteTurn = !whiteTurn

    }

    //check to see who's turn it is
    func isWhite(Piece: SCNNode) -> Bool{
        if(Piece.name == "King_White" || Piece.name == "Queen_White" ||
            Piece.name == "Rook_White" || Piece.name == "Knight_Whiite" || Piece.name ==
            "Bishop_White" || Piece.name == "Pawn_White"){
            return true
        }
        return false
    }
    func SetBoard(rootNode: SCNNode){
        theChessBoard.SetUp(rootNode: rootNode)
    }
    
    func validFirstTap(result: SCNNode)->Bool{
        if(result.parent?.name == "group_0" && result.name != "frame"){
            let resultIndex = theChessBoard.getIndex(objectToFind: result)
            print(resultIndex[0],resultIndex[1])
            
            
            if (isWhite(Piece: place[resultIndex[0]][resultIndex[1]]) == whiteTurn && place[resultIndex[0]][resultIndex[1]] != mainScene.rootNode){
//                result.geometry?.firstMaterial?.normal.contents = "carpet"
                return true
            }
        
            
        }
        return false
    }
    func validSecondTap(result: SCNNode)->Bool{
        if(result.name != "leg" && result.name != "SketchUp" && result != mainScene.rootNode){
            return true
        }
        return false
    }
    
    func isPawn(piece: String)->Bool{
        if (piece == "Pawn_White" || piece == "Pawn_Black"){
        return true
        }
        return false
    }
    func isRBQ(piece: String)->Bool{
        if((piece == "Rook_White" || piece == "Rook_Black") || (piece == "Bishop_White" || piece == "Bishop_Black") || (piece == "Queen_White" || piece ==  "Queen_Black")){
        return true
        }
        return false
    }
    func isKnight(piece: String)->Bool{
        if (piece == "Knight_Whiite" || piece == "Knight_Black"){
            return true
        }
        return false
    }
    func isKing(piece: String)->Bool{
        if (piece == "King_White" || piece == "King_Black"){
            return true
        }
        return false
    }

    
}


