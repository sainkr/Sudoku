//
//  CollectionVIewType.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/07/22.
//

import Foundation

enum CollectionViewType: Int{
  case sudoku = 1
  case option = 2
  case number = 3
  
  init?(collectionViewTag: Int) {
    guard let type = CollectionViewType(rawValue: collectionViewTag) else { return nil }
    self = type
  }
  
  var cellCount: Int{
    switch self {
    case .sudoku:
      return SudokuCollectionViewCell.count
    case .option:
      return OptionCollectionViewCell.count
    case .number:
      return NumberCollectionViewCell.count
    }
  }
}
