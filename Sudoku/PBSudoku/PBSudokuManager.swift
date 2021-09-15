//
//  PBSudokuManager.swift
//  PBSudoku
//
//  Created by 홍승아 on 2021/03/18.
//

import Foundation

public class PBSudokuManager{
    public var sudoku: [[[Int]]] = []
    
    public var original_sudoku: [[Int]] = []
    public var game_sudoku: [[Int]] = []
    
    public init() {
    }
    
    public func setLevel(level : Int){
        self.sudoku = PBSudoku.shared.getSudoku(level: level)
        self.original_sudoku = sudoku[0]
        self.game_sudoku = sudoku[1]
    }
}
