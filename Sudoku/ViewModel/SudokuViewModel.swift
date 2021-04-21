//
//  PBSudokuViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/28.
//

import Foundation

class SudokuViewModel{
    private let manager = SudokuManager.shared
    
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
    var isSeleted: [Int]{
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
    
    func setNumCount(){
        manager.setNumCount()
    }
    
    func setBlankCount(){
        manager.setBlankCount()
    }
    
    func resetisSelected(){
        manager.resetisSelected()
    }
    
    func setisSelcted(_ i: Int, _ value: Int){
        manager.setisSelected(i, value)
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
