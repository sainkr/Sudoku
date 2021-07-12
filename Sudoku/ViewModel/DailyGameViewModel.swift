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
        InnerDB.store(dailyGame, to: .documents, as: "dailygame.json")
    }
    
    func loadDailyGame() -> DailyGame? {
        guard let dailyGame = InnerDB.retrive("dailygame.json", from: .documents, as: DailyGame.self) else { return nil }
        return dailyGame
    }
    
    func addDailyGameClear(date: DailyGameClearDate){
        var dailycleargame = loadDailyGameClear()
        dailycleargame?.append(date)
        InnerDB.store(dailycleargame, to: .documents, as: "dailygamecleardate.json")
    }
    
    func loadDailyGameClear() -> [DailyGameClearDate]?{
        guard let date = InnerDB.retrive("dailygamecleardate.json", from: .documents, as: [DailyGameClearDate].self) else { return [] }
        return date
    }
    
    func dailyToGame(_ dailyGame: DailyGame) -> Game{
        return dailyGame.game
    }
    
    func isContain(dailycleargame: [DailyGameClearDate], date: DailyGameClearDate) -> Bool{
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
}
