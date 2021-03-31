//
//  MyGameViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/30.
//

import Foundation

class TodayGameViewModel{
    private let manager = TodayGameManager.shared
    
    public var todayGame: TodayGame{
        return manager.todayGame
    }
    
    public func saveTodayGame(_ todayGame: TodayGame){
        manager.saveTodayGame(todayGame)
    }
    
    public func retriveTodayGame(){
        manager.retriveTodayGame()
    }
    
    public func setToday(_ todayDate: String){
        manager.setToday(todayDate)
    }
}

