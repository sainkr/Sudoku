//
//  DailyGameClear.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/07/08.
//

import Foundation

struct DailyGameClearDate: Codable, Equatable{
  var year: Int
  var month: Int
  var day: Int
  
  static func == (lhs: DailyGameClearDate, rhs: DailyGameClearDate) -> Bool {
    return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
  }
}
