//
//  PBSudokuViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/28.
//

import Foundation

class PBSudokuViewModel{
    private let manager = PBSudokuManager.shared
    
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
}
