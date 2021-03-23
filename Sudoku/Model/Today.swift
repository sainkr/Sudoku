//
//  Today.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/22.
//

import Foundation

class TodayManager {
    static let shared = TodayManager()
    
    var todayYear: Int {
        return Calendar.current.component(.year, from: Date())
    }
    
    var todayMonth: Int {
        return Calendar.current.component(.month, from: Date())
    }
    
    var todayDay: Int {
        return Calendar.current.component(.day, from: Date())
    }
    
    var numOfDaysInMonth: [Int] = [31, 30, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    func getDate() -> String {
        return "\(todayYear)년 \(todayMonth)월 \(todayDay)일"
    }

    func setupCalendar(_ currentYear: Int, _ currentMonth: Int) -> [Int]{
        let currentMonthIndex = currentMonth - 1 // month 리턴이 (1 ~ 12)라 1을 빼준다

        // 윤년 체크
        if currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex] = 29
        }
        
        var day: [Int] = []
        let firstWeekDay = getDayOfWeek("\(currentYear)-\(currentMonth)") ?? 1
        
        // 시작하는 요일 전에 남는 공간을 0으로 채워준다
        
        while day.count < firstWeekDay{
            day.append(0)
        }
        
        // 해당 요일만큼 넣준다.
        for i in 1...numOfDaysInMonth[currentMonthIndex]{
            day.append(i)
        }
        
        return day
    }

    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        // Sun = 1, Mon = 2, Tue = 3 ...
        return weekDay - 1
    }
    }
