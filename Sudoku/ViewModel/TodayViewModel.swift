//
//  TodayViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/22.
//

import Foundation

class TodayViewModel {
    private let manager = TodayManager.shared
    
    var yearOfToday: Int {
        return manager.yearOfToday
    }
    
    var monthOfToday: Int {
        return manager.monthOfToday
    }
    
    var dayOfToday: Int {
        return manager.dayOfToday
    }

    func getDate() -> String {
        return manager.getDate()
    }
    
    func getCalendar(_ currentYear: Int, _ currentMonth : Int) -> [Int]{
        return manager.setupCalendar(currentYear, currentMonth)
    }
}
