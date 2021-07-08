//
//  MyGame.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/30.
//

import Foundation

struct Game: Codable{
    var level: Int
    var game_sudoku: [[Int]]
    var original_sudoku: [[Int]]
    var time: Double
    var memoArr: [[Int]]
    var numCount: [Int]
    var clickIndex: [ClickIndex]
}
