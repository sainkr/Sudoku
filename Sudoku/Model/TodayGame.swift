//
//  TodayGame.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/30.
//

import Foundation

struct TodayGame: Codable{
    var today: String
    var todayDate: [Int]
    var todayGameCalendar: [[Int]]
    var level: Int
    var game_sudoku: [[Int]]
    var original_sudoku: [[Int]]
    var time: Double
    var memoArr: [[Int]]
    var numCount: [Int]
}

class TodayGameManager{
    static var shared = TodayGameManager()
    var monthOfToday: Int = 0
    var dayOfToday: Int = 0
    
    var todayGame: TodayGame = TodayGame(today: "", todayDate: [], todayGameCalendar: [[],[],[],[],[],[],[],[],[],[],[],[]], level: -1, game_sudoku: [], original_sudoku: [], time: 0, memoArr: [], numCount: [])
    
    func saveTodayGame(_ todayGame: TodayGame){
        InnerDB.store(todayGame, to: .documents, as: "todaygame.json")
    }
    
    func retriveTodayGame(){
        guard let todayGame = InnerDB.retrive("todaygame.json", from: .documents, as: TodayGame.self) else { return }
        self.todayGame = todayGame
    }
    
    func setToday(_ year: Int, _ month: Int, _ day: Int){
        todayGame.today = "\(year)\(month)\(day)"
        todayGame.todayDate = [year, month, day]
    }
    
    func addTodayGameCalendar(){
        todayGame.todayGameCalendar[todayGame.todayDate[1]-1].append(todayGame.todayDate[2])
    }
}
