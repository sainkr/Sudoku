//
//  GameViewController.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/23.
//

import UIKit

class GameViewController: UIViewController {
  @IBOutlet weak var levelLabel: UILabel!
  @IBOutlet weak var pauseButton: UIButton!
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var isPlayingButton: UIButton!
  @IBOutlet weak var pauseView: UIView!
  
  @IBOutlet weak var sudokuCollectionView: UICollectionView!
  @IBOutlet weak var optionCollectionView: UICollectionView!
  @IBOutlet weak var numberCollectionView: UICollectionView!
  
  var timer: Timer?
  var timeCount: Double = 0
  var isPlaying: Bool = true
  
  var sudokuViewModel = SudokuViewModel()
  var gameViewModel = GameViewModel()
  var dailyGameViewModel = DailyGameViewModel()
  let calendarViewModel = CalendarViewModel()
  
  let ClickNumberNotification: Notification.Name = Notification.Name("ClickNumberNotification")
  
  var gameType: GameType = .newGame
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sudokuCollectionView.tag = 1
    optionCollectionView.tag = 2
    numberCollectionView.tag = 3
    
    setView()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    timer?.invalidate()
    saveSudoku()
  }
}

extension GameViewController{
  @IBAction func backButtonTapped(_ sender: Any) {
    dismiss(animated: false, completion: nil)
  }
  
  func setView(){
    timeCount = sudokuViewModel.time()
    timerPlay()
    numberCollectionView.reloadData()
    levelLabel.text = sudokuViewModel.level()
  }
  
  func saveSudoku(){
    if gameType == .dailyGame{
      dailyGameViewModel.saveDailyGame(
        today: calendarViewModel.date(),
        game: sudokuViewModel.addTimeToGame(time: timeCount))
    }else{
      if !sudokuViewModel.gameOver(){
        gameViewModel.saveGame(game: sudokuViewModel.addTimeToGame(time: timeCount))
      }
    }
  }
  
  func numberButtonTapped(_ index: Int){
    sudokuViewModel.setNum(num: index)
    numberCollectionView.reloadData()
    sudokuCollectionView.reloadData()
    if sudokuViewModel.gameOver(){
      endGame()
    }
  }
  
  func endGame() {
    timerPasue()
    if gameType == .dailyGame{
      dailyGameViewModel.addDailyGameClear(
        date: DailyGameClearDate(
          year: calendarViewModel.yearOfToday,
          month: calendarViewModel.monthOfToday,
          day: calendarViewModel.dayOfToday)
      )
    }else{
      gameViewModel.removeGame()
    }
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - Timer
extension GameViewController {
  
  @IBAction func playButtonTapped(_ sender: Any) {
    timerPlay()
    pauseView.isHidden = true
  }
  
  @IBAction func isPlayingButtonTapped(_ sender: Any) {
    if isPlaying {
      timerPasue()
      pauseView.isHidden = false
    } else {
      timerPlay()
      pauseView.isHidden = true
    }
  }
  
  func timerPlay(){
    isPlayingButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    isPlaying = true
    // timeInterval : 간격, target : 동작될 View, selector : 실행할 함수, userInfo : 사용자 정보, repeates : 반복
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
  }
  
  func timerPasue(){
    isPlayingButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    isPlaying = false
    timer?.invalidate()
  }
  
  @objc func setTime(){
    timerLabel.text = secondsToString(sec: timeCount)
    timeCount += 1
  }
  
  func secondsToString(sec: Double) -> String {
    guard sec != 0 else { return "00 : 00" }
    let totalSeconds = Int(sec)
    let min = totalSeconds / 60
    let seconds = totalSeconds % 60
    return String(format: "%02d : %02d", min, seconds)
  }
}

// MARK: - CollectionView
extension GameViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let collectionView = CollectionViewType(collectionViewTag: collectionView.tag) else { return 0 }
    return collectionView.cellCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let collectionView = CollectionViewType(collectionViewTag: collectionView.tag) else { return UICollectionViewCell() }
    
    switch collectionView {
    case .sudoku:
      guard let cell = sudokuCollectionView.dequeueReusableCell(withReuseIdentifier: SudokuCollectionViewCell.identifier, for: indexPath) as? SudokuCollectionViewCell else { return UICollectionViewCell() }
      cell.updateMemoUI(sudokuViewModel.memo(index: indexPath.item))
      cell.updateUI(
        index: indexPath.item,
        sudokuNum: sudokuViewModel.gameSudoku(index: indexPath.item),
        cellType: sudokuViewModel.selected(index: indexPath.item),
        isCorrect: sudokuViewModel.isCorrect(index: indexPath.item))
      return cell
    case .option:
      guard let cell = optionCollectionView.dequeueReusableCell(withReuseIdentifier: OptionCollectionViewCell.identifier, for: indexPath) as? OptionCollectionViewCell else { return UICollectionViewCell() }
      cell.updateUI(indexPath.item, sudokuViewModel.isMemoOptionSelected)
      return cell
    case .number:
      guard let cell = numberCollectionView.dequeueReusableCell(withReuseIdentifier: NumberCollectionViewCell.identifier, for: indexPath) as? NumberCollectionViewCell else { return UICollectionViewCell() }
      cell.updateUI(indexPath.item + 1, sudokuViewModel.currectAnswerCount(index: indexPath.item + 1))
      cell.clickButtonTapHandler = { self.numberButtonTapped(indexPath.item + 1) }
      return cell
    }
  }
}

extension GameViewController: UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let collectionView = CollectionViewType(collectionViewTag: collectionView.tag) else { return}
    switch collectionView{
    case .sudoku:
      sudokuViewModel.clickIndex(index: indexPath.item)
    case .option:
      sudokuViewModel.setOption(optionNum: indexPath.item)
      if indexPath.item == 2{ optionCollectionView.reloadData() }
      else{ numberCollectionView.reloadData() }
    case .number: break
    }
    sudokuCollectionView.reloadData()
  }
}

extension GameViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionViewWidth = collectionView.bounds.width
    guard let collectionView = CollectionViewType(collectionViewTag: collectionView.tag) else { return CGSize() }
    
    switch collectionView{
    case .sudoku:
      let width: CGFloat =  collectionViewWidth / 9
      return CGSize(width: width , height: width)
    case .option:
      let width: CGFloat = collectionViewWidth / 4
      let height: CGFloat = width * 1.2
      return CGSize(width: width, height: height)
    case .number:
      let margin: CGFloat = 10
      let width: CGFloat = (collectionViewWidth - margin) / 9
      return CGSize(width: width, height: width)
    }
  }
}
