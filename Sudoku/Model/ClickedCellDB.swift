//
//  ClickIndex.swift
//  Sudoku
//
//  Created by νμΉμ on 2021/07/08.
//

import Foundation

struct ClickedCellDB: Codable{
  var clickedCellIndex: Int
  var currentNum: [Int]
  var beforeNum: [Int]
  var isMemo: Bool
}
