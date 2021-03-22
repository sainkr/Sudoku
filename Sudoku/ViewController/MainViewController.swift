//
//  MainViewController.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/22.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    
    var todayViewModel = TodayViewModel()
    var currentYear: Int = 0
    var currentMonth: Int = 0
    var currentDay: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentYear = todayViewModel.todayYear
        currentMonth = todayViewModel.todayMonth
        currentDay = todayViewModel.getCalendar(currentYear, currentMonth)
        
        print(currentDay)
        setView()
    }
    
    func setView(){
        // 오늘 날짜 설정
        todayDateLabel.text = todayViewModel.getDate()
        
        // 이번 달 설정
        monthLabel.text = "\(todayViewModel.todayMonth)월"
        
        // 뷰 둥글게
        calendarView.layer.cornerRadius = 17
        
        // 버튼 둥글게
        continueButton.layer.cornerRadius = 17
        newGameButton.layer.cornerRadius = 17
    }
}

extension MainViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else { return UICollectionViewCell() }
        
        if currentDay[indexPath.item] > 0 {
            cell.update("\(currentDay[indexPath.item])")
        } else {
            cell.update(" ")
        }
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width / 7)
        let height: CGFloat = 20
        
        return CGSize(width: width, height: height)
    }
}

class CalendarCell: UICollectionViewCell{
    @IBOutlet weak var dayLabel: UILabel!
    
    func update(_ day: String){
        dayLabel.text = day
    }
}
