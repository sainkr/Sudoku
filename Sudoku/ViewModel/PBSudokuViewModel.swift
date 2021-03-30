//
//  PBSudokuViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/28.
//

import Foundation

class PBSudokuViewModel{
    private let manager = PBSudokuManager.shared
    
    var level: Int{
        return manager.level
    }
    var original_sudoku: [[Int]] {
        return manager.original_sudoku
    }
    var game_sudoku: [[Int]] {
        return manager.game_sudoku
    }
    var numCount: [Int] {
        return manager.numCount
    }
    var blankCount: Int {
        return manager.blankCount
    }
    var isSeleted: [Bool]{
        return manager.isSelected
    }
    var memoArr: [[Int]]{
        return manager.memoArr
    }
    
    func setLevel(level : Int){
        manager.setLevel(level: level)
    }
    
    func setGameSudoku(_ num : Int, _ x: Int, _ y: Int){
        manager.setGameSudoku(num, x, y)
    }
    
    func setNumCount(_ i: Int){
        manager.setNumCount(i)
    }
    
    func setBlankCount(){
        manager.setBlankCount()
    }
    
    func setisSelcted(_ i: Int, _ value: Bool){
        manager.setisSelcted(i, value)
    }
    
    func setMemoArr(_ i: Int, _ j: Int,_  value: Int){
        manager.setMemoArr(i, j, value)
    }
    
    func setMemoArr(_ i: Int, _ value: [Int]){
        manager.setMemoArr(i, value)
    }
    
    func setSudoku(_ myGame: MyGame){
        manager.setSudoku(myGame)
    }
}
