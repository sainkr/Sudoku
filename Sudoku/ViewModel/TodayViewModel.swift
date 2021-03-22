//
//  TodayViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/22.
//

import Foundation

class TodayViewModel {
    private let manager = TodayManager.shared
    
    var todayYear: Int {
        return manager.todayYear
    }
    
    var todayMonth: Int {
        return manager.todayMonth
    }
    
    var todayDay: Int {
        return manager.todayDay
    }

    func getDate() -> String {
        return manager.getDate()
    }
    
    func getCalendar(_ currentYear: Int, _ currentMonth : Int) -> [Int]{
        return manager.setupCalendar(currentYear, currentMonth)
    }
}
