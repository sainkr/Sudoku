//
//  ClickIndex.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/07/08.
//

import Foundation

struct ClickIndex: Codable{
    var i: Int
    var j: Int
    var currentNum: [Int]
    var beforeNum: Int
    var isMemo: Bool
}
