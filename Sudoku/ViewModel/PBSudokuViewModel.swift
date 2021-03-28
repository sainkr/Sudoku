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
    
    func setLevel(level : Int){
        manager.setLevel(level: level)
    }
}
