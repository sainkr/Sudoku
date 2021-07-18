//
//  TodayViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/22.
//

import Foundation

class CalendarViewModel{
  var yearOfToday: Int {
    return Calendar.current.component(.year, from: Date())
  }
  var monthOfToday: Int {
    return Calendar.current.component(.month, from: Date())
  }
  var dayOfToday: Int {
    return Calendar.current.component(.day, from: Date())
  }
  private var numOfDaysInMonth: [Int] = [0, 31, 30, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  
  func date() -> String {
    return "\(yearOfToday)년 \(monthOfToday)월 \(dayOfToday)일"
  }
  
  func setDays(_ currentYear: Int, _ currentMonth: Int) -> [Int]{
    let currentMonthIndex = currentMonth
    // 윤년 체크
    if currentYear % 4 == 0 {
      numOfDaysInMonth[currentMonthIndex] = 29
    }
    var day: [Int] = []
    let firstWeekDay = dayOfWeek("\(currentYear)-\(currentMonth)")
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
  
  func dayOfWeek(_ today:String) -> Int{
    let formatter  = DateFormatter()
    formatter.dateFormat = "yyyy-MM"
    guard let todayDate = formatter.date(from: today) else { return 0 }
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: todayDate)
    // Sun = 1, Mon = 2, Tue = 3 ...
    return weekDay - 1
  }
  
  func setYear(_ year: Int,_ month: Int) -> Int{
    if month == 0 {
      return year - 1
    } else if month == 13 {
      return year + 1
    }else {
      return year
    }
  }
  
  func setMonth(_ year: Int, _ month: Int) -> Int{
    if month == 0 {
      return 12
    } else if month == 13 {
      return  1
    }else {
      return month
    }
  }
  
  func setCalendar(_ currentYear: Int,_ currentMonth: Int)-> CurrentCalendar{
    let year = setYear(currentYear, currentMonth)
    let month = setMonth(currentYear, currentMonth)
    let days = setDays(year, month)
    let currentMonth = currentYear == yearOfToday && currentMonth == monthOfToday
    let day = currentMonth ? dayOfToday : 32
    return CurrentCalendar(year: year, month: month, day: day, days: days, currentMonth: currentMonth)
  }
}
