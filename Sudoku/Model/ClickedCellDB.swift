//
//  ClickIndex.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/07/08.
//

import Foundation

struct ClickedCellDB: Codable{
  var clickedCellIndex: Int
  var currentNum: [Int]
  var beforeNum: [Int]
  var isMemo: Bool
}
