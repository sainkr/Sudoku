//
//  MyGameViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/30.
//

import Foundation

class DailyGameViewModel{
  func saveDailyGame(today: String, game: Game){
    let dailyGame = DailyGame(date: today, game: game)
    Storage.store(dailyGame, to: .documents, as: "dailygame.json")
  }
  
  func fetchDailyGame() -> DailyGame? {
    guard let dailyGame = Storage.retrive("dailygame.json", from: .documents, as: DailyGame.self) else { return nil }
    return dailyGame
  }
  
  func addDailyGameClear(date: DailyGameClearDate){
    var dailycleargame = fetchDailyGameClear()
    dailycleargame?.append(date)
    Storage.store(dailycleargame, to: .documents, as: "dailygamecleardate.json")
  }
  
  func fetchDailyGameClear() -> [DailyGameClearDate]?{
    guard let date = Storage.retrive("dailygamecleardate.json", from: .documents, as: [DailyGameClearDate].self) else { return [] }
    return date
  }
  
  func dailyToGame(_ dailyGame: DailyGame) -> Game{
    return dailyGame.game
  }
  
  func checkClearDate(dailycleargame: [DailyGameClearDate], date: DailyGameClearDate) -> Bool{
    for i in 0..<dailycleargame.count{
      if dailycleargame[i] == date{
        return true
      }
    }
    return false
  }
  
  func getClearCount(dailycleargame: [DailyGameClearDate], year: Int, month: Int) -> Int{
    var cnt = 0
    for i in 0..<dailycleargame.count{
      if dailycleargame[i].year == year && dailycleargame[i].month == month{
        cnt += 1
      }
    }
    return cnt
  }
  
  func existTodayDailyGame(dailyGame: DailyGame, date: String) -> Bool{
    guard dailyGame.date == date else { return false }
    return true
  }
}
