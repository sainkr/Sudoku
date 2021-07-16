//
//  MainViewController.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/22.
//

import UIKit

class MainViewController: UIViewController{
  @IBOutlet weak var todayDateLabel: UILabel!
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var calendarView: UIView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var todayGameButton: UIButton!
  @IBOutlet weak var continueButton: UIButton!
  @IBOutlet weak var newGameButton: UIButton!
  @IBOutlet weak var nextMonthButton: UIButton!
  @IBOutlet weak var beforeMonthButton: UIButton!
  
  var calendarViewModel = CalendarViewModel()
  var gameViewModel = GameViewModel()
  var sudokuViewModel = SudokuViewModel()
  var dailyGameViewModel = DailyGameViewModel()
  
  var currentYear: Int = 0
  var currentMonth: Int = 0
  var currentDay: Int = 0
  var currentCalendarDay: [Int] = []
  
  var dailygamecleardate: [DailyGameClearDate]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setCurrentCalendar(calendarViewModel.yearOfToday, calendarViewModel.monthOfToday)
    setView()
    gameViewModel.clearGame()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    loadData()
    collectionView.reloadData()
  }
}

extension MainViewController{
  func setView(){
    todayDateLabel.text = calendarViewModel.getDate() // 오늘 날짜 설정
    calendarView.layer.cornerRadius = 17 // 뷰 둥글게
    // 버튼 둥글게
    todayGameButton.layer.cornerRadius = 17
    continueButton.layer.cornerRadius = 17
    newGameButton.layer.cornerRadius = 17
  }
  
  func setCurrentCalendar(_ year : Int, _ month: Int){
    currentYear = calendarViewModel.setCurrentDay(year, month)[0]
    currentMonth = calendarViewModel.setCurrentDay(year, month)[1]
    // 이번년도만
    if year == calendarViewModel.yearOfToday && month == calendarViewModel.monthOfToday{
      nextMonthButton.isHidden = true
      currentDay = calendarViewModel.dayOfToday
    }else {
      nextMonthButton.isHidden = false
      currentDay = 32
    }
    
    currentCalendarDay = calendarViewModel.setupCalendar(currentYear, currentMonth)
    monthLabel.text = "\(currentMonth)월"
    collectionView.reloadData()
  }
  
  func presentGameVC(_ gameType: GameType){
    let gameStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
    guard let gameVC = gameStoryboard.instantiateViewController(identifier: "GameViewController") as? GameViewController else { return }
    gameVC.modalPresentationStyle = .fullScreen
    gameVC.gameType = gameType
    if gameType == .newGame { presentNewGame(gameVC); return }
    present(gameVC, animated: true, completion: nil)
  }
  
  func loadData(){
    dailygamecleardate = dailyGameViewModel.loadDailyGameClear()
  }
  
  func presentNewGame(_ gameVC: GameViewController){
    let actionsheetConroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let easy = UIAlertAction(title: "쉬움", style: .default) { action in
      self.sudokuViewModel.setSudoku(level: 1)
      self.present(gameVC, animated: true, completion: nil)
    }
    let medium = UIAlertAction(title: "보통", style: .default) { action in
      self.sudokuViewModel.setSudoku(level: 2)
      self.present(gameVC, animated: true, completion: nil)
    }
    let hard = UIAlertAction(title: "어려움", style: .default) { action in
      self.sudokuViewModel.setSudoku(level: 3)
      self.present(gameVC, animated: true, completion: nil)
    }
    let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    
    actionsheetConroller.addAction(easy)
    actionsheetConroller.addAction(medium)
    actionsheetConroller.addAction(hard)
    actionsheetConroller.addAction(actionCancel)
    
    present(actionsheetConroller, animated: true)
  }
  
  func setAlert(_ msg: String){
    let nameAlert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
    let nameOK = UIAlertAction(title: "확인", style: .default ){ (ok) in
      self.dismiss(animated: true, completion: nil)
    }
    nameAlert.addAction(nameOK)
    self.present(nameAlert, animated: true, completion: nil)
  }
}
// MARK:- Action
extension MainViewController {
  @IBAction func backCalendarButtonTapped(_ sender: Any) {  // 저번달 버튼
    setCurrentCalendar(currentYear, currentMonth - 1)
  }
  
  @IBAction func nextCalendarButtonTapped(_ sender: Any) { // 다음달 버튼
    setCurrentCalendar(currentYear, currentMonth + 1)
  }
  
  @IBAction func todayGameButtonTapped(_ sender: Any) { // 오늘의 게임 버튼
    if let dailyGame = dailyGameViewModel.loadDailyGame(), dailyGame.date == calendarViewModel.getDate(){
      sudokuViewModel.setSudoku(dailyGameViewModel.dailyToGame(dailyGame))
    }else{
      self.sudokuViewModel.setSudoku(level: Int(arc4random_uniform(3) + 1))
    }
    if sudokuViewModel.gameOver(){ setAlert("이미 오늘의 게임을 클리어하셨습니다. 👏🏻"); return }
    presentGameVC(.dailyGame)
  }
  
  @IBAction func continueButtonTapped(_ sender: Any) { // 이어하기 버튼
    guard let game = gameViewModel.loadGame() else { presentGameVC(.newGame); return }
    sudokuViewModel.setSudoku(game)
    presentGameVC(.continueGame)
  }
  
  @IBAction func newGameButtonTapped(_ sender: Any) { // 새 게임 버튼
    presentGameVC(.newGame)
  }
}

extension MainViewController: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentCalendarDay.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else { return UICollectionViewCell() }
    
    var success = false
    // 현재 표시된 달력에 클리어한 날짜가 있으면
    if dailyGameViewModel.isContain(dailycleargame: dailygamecleardate, date: DailyGameClearDate(year: currentYear, month: currentMonth, day: currentCalendarDay[indexPath.item])) {
      success = true
    }
    cell.updateUI(currentCalendarDay[indexPath.item], currentDay, success)
    
    return cell
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
  
  func updateUI(_ day: Int, _ currentDay: Int, _ success: Bool){
    dayLabel.text = day > 0 ? "\(day)" : " "
    dayLabel.textColor = day <= currentDay ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    if success{
      view.backgroundColor = #colorLiteral(red: 0.9516713023, green: 0.3511439562, blue: 0.1586719155, alpha: 1)
      view.layer.cornerRadius = 20
    }else {
      view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
  }
}
