//
//  MyGame.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/30.
//

import Foundation

struct Game: Codable{
  var level: Int
  var gameSudoku: [[Int]]
  var originalSudoku: [[Int]]
  var time: Double
  var memo: [[Bool]]
  var currectAnswerCount: [Int]
  var clickedCellDB: [ClickedCellDB] // 실행 취소를 위한 db
}
