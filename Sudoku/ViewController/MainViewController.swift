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
    @IBOutlet weak var todayGameButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    
    var todayViewModel = TodayViewModel()
    var myGameViewModel = MyGameViewModel()
    var sudokuViewModel = PBSudokuViewModel()
    
    var currentYear: Int = 0
    var currentMonth: Int = 0
    var currentDay: Int = 0
    var currentCalendarDay: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCurrentCalendar(todayViewModel.yearOfToday, todayViewModel.monthOfToday)
        
        setView()
        
        myGameViewModel.retriveMyGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if myGameViewModel.myGame.level != -1 {
            myGameViewModel.retriveMyGame()
        }
    }
    func setView(){
        // 오늘 날짜 설정
        todayDateLabel.text = todayViewModel.getDate()
        
        // 뷰 둥글게
        calendarView.layer.cornerRadius = 17
        
        // 버튼 둥글게
        todayGameButton.layer.cornerRadius = 17
        continueButton.layer.cornerRadius = 17
        newGameButton.layer.cornerRadius = 17
    }
    
    func setCurrentCalendar(_ year : Int, _ month: Int){
        if month == 0 {
            currentYear = year - 1
            currentMonth = 12
        } else if month == 13 {
            currentYear = year + 1
            currentMonth = 1
        }
        else {
            currentYear = year
            currentMonth = month
        }
        
        if year == todayViewModel.yearOfToday && month == todayViewModel.monthOfToday{
            nextMonthButton.isHidden = true
            currentDay = todayViewModel.dayOfToday
        }else {
            nextMonthButton.isHidden = false
            currentDay = 32
        }
        
        currentCalendarDay = todayViewModel.getCalendar(currentYear, currentMonth)
        
        monthLabel.text = "\(currentMonth)월"
        collectionView.reloadData()
    }
}

extension MainViewController {
    // 저번달 버튼
    @IBAction func backCalendarButtonTapped(_ sender: Any) {
        setCurrentCalendar(currentYear, currentMonth - 1)
    }
    
    // 다음달 버튼
    @IBAction func nextCalendarButtonTapped(_ sender: Any) {
        setCurrentCalendar(currentYear, currentMonth + 1)
    }
    
    // 오늘의 게임 버튼
    @IBAction func todayGameButtonTapped(_ sender: Any) {
        
    }
    
    // 이어하기 버튼
    @IBAction func continueButtonTapped(_ sender: Any) {
        if myGameViewModel.myGame.level > -1 {
            continueGame()
        } else {
            newGame()
        }
    }
    
    // 새 게임 버튼
    @IBAction func newGameButtonTapped(_ sender: Any) {
        newGame()
    }
    
    // 랭킹 버튼
    @IBAction func rankingButtonTapped(_ sender: Any) {
        
    }
    
    // 환경설정 버튼
    @IBAction func setupButtonTapped(_ sender: Any) {
        
    }
    
    func continueGame(){
        sudokuViewModel.setSudoku(myGameViewModel.myGame)
        let gameStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
        guard let gameVC = gameStoryboard.instantiateViewController(identifier: "GameViewController") as? GameViewController else { return }
        gameVC.modalPresentationStyle = .fullScreen
        self.present(gameVC, animated: true, completion: nil)
    }
    
    func newGame(){
        
        let gameStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
        guard let gameVC = gameStoryboard.instantiateViewController(identifier: "GameViewController") as? GameViewController else { return }
        gameVC.modalPresentationStyle = .fullScreen
        
        let actionsheetConroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let easy = UIAlertAction(title: "쉬움", style: .default) { action in
            self.sudokuViewModel.setLevel(level: 0)
            self.present(gameVC, animated: true, completion: nil)
        }
        let medium = UIAlertAction(title: "보통", style: .default) { action in
            self.sudokuViewModel.setLevel(level: 1)
            self.present(gameVC, animated: true, completion: nil)
        }
        let hard = UIAlertAction(title: "어려움", style: .default) { action in
            self.sudokuViewModel.setLevel(level: 2)
            self.present(gameVC, animated: true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionsheetConroller.addAction(easy)
        actionsheetConroller.addAction(medium)
        actionsheetConroller.addAction(hard)
        actionsheetConroller.addAction(actionCancel)
        
        present(actionsheetConroller, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCalendarDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else { return UICollectionViewCell() }
        
        cell.updateUI(currentCalendarDay[indexPath.item], currentDay)
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (collectionView.bounds.width - 30) / 7
        
        return CGSize(width: width, height: width)
    }
}

class CalendarCell: UICollectionViewCell{
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    func updateUI(_ day: Int, _ currentDay: Int){
        if day > 0 {
            dayLabel.text = "\(day)"
        }else {
            dayLabel.text = " "
        }
        
        if day <= currentDay {
            dayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else {
            dayLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }
    
    // 배경색 업데이트
    func updateBackground(){
        view.backgroundColor = #colorLiteral(red: 0.9516713023, green: 0.3511439562, blue: 0.1586719155, alpha: 1)
        view.layer.cornerRadius = 20
    }
}
