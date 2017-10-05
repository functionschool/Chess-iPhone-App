//
//  ChessBoard.swift
//  Chess
//
//  Created by Kousei Richeson on 10/3/17.
//  Copyright © 2017 Kousei Richeson. All rights reserved.
//

import UIKit

class ChessBoard: NSObject {
    
    var board: [[Piece]]!
    var vc: GameScreen!
    let ROWS = 8
    let COLS = 8
    var whiteKing: King!
    var blackKing: King!
    
    
    static func getFrame(forRow row: Int, forCol col: Int) -> CGRect {
        
        let x = CGFloat(GameScreen.SPACE_FROM_LEFT_EDGE + col * GameScreen.TILE_SIZE)
        let y = CGFloat(GameScreen.SPACE_FROM_TOP_EDGE + row * GameScreen.TILE_SIZE)
        
        return CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: GameScreen.TILE_SIZE, height: GameScreen.TILE_SIZE))
        
    }
    
    init(viewController: GameScreen) {
        vc = viewController
        
        //initialize the board matrix with dummies
        let oneRowOfBoard = Array(repeating: Dummy(), count: COLS)
        board = Array(repeating: oneRowOfBoard, count: ROWS)
        
        for row in 0 ..< ROWS {
            for col in 0 ..< COLS {
                switch row {
                
                //We only need case 0, 1, 6, 7 because thats the only rows pieces go on
                case 0:
                    
                    switch col {
                    case 0:
                        board[row][col] = Rook(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.black, vc: vc)
                    case 1:
                        board[row][col] = Knight(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.black, vc: vc)
                    case 2:
                        board[row][col] = Bishop(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.black, vc: vc)
                    case 3:
                        board[row][col] = Queen(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.black, vc: vc)
                    case 4:
                        blackKing = King(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.black, vc: vc)
                        board[row][col] = blackKing
                    case 5:
                        board[row][col] = Bishop(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.black, vc: vc)
                    case 6:
                        board[row][col] = Knight(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.black, vc: vc)
                    //case 7
                    default:
                        board[row][col] = Rook(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.black, vc: vc)
                    }
                    
                case 1:
                    board[row][col] = Pawn(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.black, vc: vc)
                
                case 6:
                    board[row][col] = Pawn(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.white, vc: vc)
                case 7:
                    
                    switch col {
                    case 0:
                        board[row][col] = Rook(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.white, vc: vc)
                    case 1:
                        board[row][col] = Knight(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.white, vc: vc)
                    case 2:
                        board[row][col] = Bishop(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.white, vc: vc)
                    case 3:
                        board[row][col] = Queen(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.white, vc: vc)
                    case 4:
                        whiteKing = King(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.white, vc: vc)
                        board[row][col] = whiteKing
                    case 5:
                        board[row][col] = Bishop(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.white, vc: vc)
                    case 6:
                        board[row][col] = Knight(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.white, vc: vc)
                    default:
                        board[row][col] = Rook(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: UIColor.white, vc: vc)
                    }
                    
                
                default:
                    board[row][col] = Dummy(frame: ChessBoard.getFrame(forRow: row, forCol: col))
                
                }
            }
        }
    }
    
}
