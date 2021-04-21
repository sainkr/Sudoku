//
//  Sudoku.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/04/21.
//

import Foundation
import PBSudoku

public class SudokuManager{
    
    static let shared = SudokuManager()
    
    var original_sudoku: [[Int]] = []
    var game_sudoku: [[Int]] = []
    var numCount: [Int] = [0,0,0,0,0,0,0,0,0,0]
    var blankCount = 0
    var level = -1
    var isSelected: [Int] = [0,0,0,0,0,0,0,0,0,
                          0,0,0,0,0,0,0,0,0,
                          0,0,0,0,0,0,0,0,0,
                          0,0,0,0,0,0,0,0,0,
                          0,0,0,0,0,0,0,0,0,
                          0,0,0,0,0,0,0,0,0,
                          0,0,0,0,0,0,0,0,0,
                          0,0,0,0,0,0,0,0,0,
                          0,0,0,0,0,0,0,0,0]
    var memoArr: [[Int]] = []
    
    func setSudoku(_ myGame: MyGame){
        self.original_sudoku = myGame.original_sudoku
        self.game_sudoku = myGame.game_sudoku
        self.numCount = myGame.numCount
        self.level = myGame.level
        self.memoArr = myGame.memoArr
    }
    
    func setLevel(level : Int){
        self.level = level
        sudoku.setLevel(level: level)
        self.original_sudoku = sudoku.original_sudoku
        self.game_sudoku = sudoku.game_sudoku
        self.isSelected = [0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0]
        self.memoArr = []
        self.numCount = [0,0,0,0,0,0,0,0,0,0,0]
        for _ in 0...80{
            memoArr.append([0,0,0,0,0,0,0,0,0])
        }
        
        setNumCount()
    }

    
    func setNumCount(){
        self.numCount = [0,0,0,0,0,0,0,0,0,0]
        for i in game_sudoku{
            for j in i{
                numCount[j] += 1
            }
        }
    }
    
    func setGameSudoku(_ num: Int, _ x: Int, _ y: Int){
        game_sudoku[x][y] = num
    }
    
    func setBlankCount(){
        blankCount -= 1
    }
    
    func resetisSelected(){
        self.isSelected = [0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0,
                           0,0,0,0,0,0,0,0,0]
    }
    
    func setisSelected(_ i: Int, _ value: Int){
        isSelected[i] = value
    }
    
    func setMemoArr(_ i: Int, _ j: Int, _ value: Int){
        memoArr[i][j] = value
    }
    
    func setMemoArr(_ i: Int, _ value: [Int]){
        memoArr[i] = value
    }
}
