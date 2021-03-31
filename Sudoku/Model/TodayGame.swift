//
//  TodayGame.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/30.
//

import Foundation

struct TodayGame: Codable{
    var today: String
    var todayGameCalendar: [[Int]]
    var level: Int
    var game_sudoku: [[Int]]
    var original_sudoku: [[Int]]
    var time: Double
    var memoArr: [[Int]]
    var numCount: [Int]
    var missCount: Int
}

class TodayGameManager{
    static var shared = TodayGameManager()
    
    var todayGame: TodayGame = TodayGame(today: "", todayGameCalendar: [], level: -1, game_sudoku: [], original_sudoku: [], time: 0, memoArr: [], numCount: [], missCount: 0)
    
    func saveTodayGame(_ todayGame: TodayGame){
        InnerDB.store(todayGame, to: .documents, as: "todaygame.json")
    }
    
    func retriveTodayGame(){
        guard let todayGame = InnerDB.retrive("todaygame.json", from: .documents, as: TodayGame.self) else { return }
        self.todayGame = todayGame
    }
    
    func setToday(_ todayDate: String){
        todayGame.today = todayDate
    }
    
}
