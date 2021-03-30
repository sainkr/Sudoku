//
//  TodayGame.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/30.
//

import Foundation

struct TodayGame: Codable{
    var todayGameCalendar: [Int]
    var level: Int
    var game_sudoku: [[Int]]
    var original_sudoku: [[Int]]
    var time: Double
}

class TodayGameManager{
    static var shared = TodayManager()
    
    var todayGame: TodayGame = TodayGame(todayGameCalendar: [],level: -1,game_sudoku: [[]],original_sudoku: [[]],time: 0)
    
    func saveTodayGame(_ todayGame: TodayGame){
        InnerDB.store(todayGame, to: .documents, as: "todaygame.json")
    }
    
    func retriveTodayGame(){
        guard let todayGame = InnerDB.retrive("todaygame.json", from: .documents, as: TodayGame.self) else { return }
        self.todayGame = todayGame
    }
    
}
