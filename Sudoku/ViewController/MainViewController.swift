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
  
  private var calendarViewModel = CalendarViewModel()
  private  var gameViewModel = GameViewModel()
  private var sudokuViewModel = SudokuViewModel()
  private var dailyGameViewModel = DailyGameViewModel()
  
  private var currentYear: Int = 0
  private var currentMonth: Int = 0
  private var currentDay: Int = 0
  private var currentCalendarDay: [Int] = []
  
  private var dailyGameClearDate: [DailyGameClearDate] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    registerCalendarCollectionViewCell()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    loadData()
  }
}

extension MainViewController{
  private func configureView(){
    todayDateLabel.text = calendarViewModel.date() // 오늘 날짜 설정
    calendarView.layer.cornerRadius = 17
    todayGameButton.layer.cornerRadius = 17
    continueButton.layer.cornerRadius = 17
    newGameButton.layer.cornerRadius = 17
    configureCurrentCalendar(calendarViewModel.yearOfToday, calendarViewModel.monthOfToday)
  }
  
  private func configureCurrentCalendar(_ year : Int, _ month: Int){
    let calendar = calendarViewModel.setCalendar(year, month)
    currentYear = calendar.year
    currentMonth = calendar.month
    currentDay = calendar.day
    currentCalendarDay = calendar.days
    nextMonthButton.isHidden = calendar.currentMonth ? true : false
    monthLabel.text = "\(currentMonth)월"
    collectionView.reloadData()
  }
  
  private func loadData(){
    dailyGameClearDate = dailyGameViewModel.fetchDailyGameClear() ?? []
    collectionView.reloadData()
  }
  
  private func registerCalendarCollectionViewCell(){
    let calendarCollectionViewCellNib = UINib(nibName: CalendarCollectionViewCell.identifier, bundle: nil)
    collectionView.register(calendarCollectionViewCellNib, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
  }

  private func presentGameVC(_ gameType: GameType){
    let gameStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
    guard let gameVC = gameStoryboard.instantiateViewController(identifier: "GameViewController") as? GameViewController else { return }
    gameVC.modalPresentationStyle = .fullScreen
    gameVC.gameType = gameType
    if gameType == .newGame { presentNewGame(gameVC); return }
    present(gameVC, animated: true, completion: nil)
  }
  
  private func presentNewGame(_ gameVC: GameViewController){
    let actionsheetConroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let easy = uiAlertAction(title: "쉬움", level: 1, gameVC: gameVC)
    let medium = uiAlertAction(title: "보통", level: 2, gameVC: gameVC)
    let hard = uiAlertAction(title: "어려움", level: 3, gameVC: gameVC)
    let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    
    actionsheetConroller.addAction(easy)
    actionsheetConroller.addAction(medium)
    actionsheetConroller.addAction(hard)
    actionsheetConroller.addAction(actionCancel)
    
    present(actionsheetConroller, animated: true)
  }
  
  private func uiAlertAction(title: String, level: Int, gameVC: GameViewController) -> UIAlertAction{
    return UIAlertAction(title: title, style: .default) { action in
      self.sudokuViewModel.setNewGameSudoku(level: level)
      self.present(gameVC, animated: true, completion: nil)
    }
  }
  
  private func alert(_ msg: String){
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
    configureCurrentCalendar(currentYear, currentMonth - 1)
  }
  
  @IBAction func nextCalendarButtonTapped(_ sender: Any) { // 다음달 버튼
    configureCurrentCalendar(currentYear, currentMonth + 1)
  }
  
  @IBAction func todayGameButtonTapped(_ sender: Any) { // 오늘의 게임 버튼
    if let dailyGmae = dailyGameViewModel.fetchDailyGame(),
       dailyGameViewModel.existTodayDailyGame(dailyGame: dailyGmae, date: calendarViewModel.date()){
      self.sudokuViewModel.setOldGameSudoku(game: dailyGameViewModel.dailyToGame(dailyGmae))
    } else{
      self.sudokuViewModel.setNewGameSudoku(level: Int(arc4random_uniform(3) + 1))
    }
    if sudokuViewModel.gameOver(){ alert("이미 오늘의 게임을 클리어하셨습니다. 👏🏻"); return }
    presentGameVC(.dailyGame)
  }
  
  @IBAction func continueButtonTapped(_ sender: Any) { // 이어하기 버튼
    guard let game = gameViewModel.fetchGame() else { presentGameVC(.newGame); return }
    sudokuViewModel.setOldGameSudoku(game: game)
    presentGameVC(.continueGame)
  }
  
  @IBAction func newGameButtonTapped(_ sender: Any) { // 새 게임 버튼
    presentGameVC(.newGame)
  }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentCalendarDay.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
    let success = dailyGameViewModel.checkClearDate(dailycleargame: dailyGameClearDate,
                                    date: DailyGameClearDate(
                                      year: currentYear,
                                      month: currentMonth,
                                      day: currentCalendarDay[indexPath.item]))
    cell.updateUI(currentCalendarDay[indexPath.item], currentDay, success)
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width: CGFloat = (collectionView.bounds.width - 30) / 7
    return CGSize(width: width, height: width)
  }
}
