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
  
  private var timer: Timer?
  private var timeCount: Double = 0
  private var isPlaying: Bool = true
  
  private var sudokuViewModel = SudokuViewModel()
  private var gameViewModel = GameViewModel()
  private var dailyGameViewModel = DailyGameViewModel()
  private let calendarViewModel = CalendarViewModel()
  
  private let ClickNumberNotification: Notification.Name = Notification.Name("ClickNumberNotification")
  
  var gameType: GameType = .newGame
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setCollectionViewTag()
    configureView()
    registerSudokuCollectionViewCell()
    registerOptionCollectionViewCell()
    registerNumberCollectionViewCell()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    timer?.invalidate()
    saveSudoku()
  }
  
  @IBAction func backButtonTapped(_ sender: Any) {
    dismiss(animated: false, completion: nil)
  }
}

extension GameViewController{
  private func configureView(){
    timeCount = sudokuViewModel.time()
    timerPlay()
    numberCollectionView.reloadData()
    levelLabel.text = sudokuViewModel.level()
  }
  
  private func setCollectionViewTag(){
    sudokuCollectionView.tag = 1
    optionCollectionView.tag = 2
    numberCollectionView.tag = 3
  }
  
  private func registerSudokuCollectionViewCell(){
    let sudokuCollectionViewCellNib = UINib(nibName: SudokuCollectionViewCell.identifier, bundle: nil)
    sudokuCollectionView.register(sudokuCollectionViewCellNib, forCellWithReuseIdentifier: SudokuCollectionViewCell.identifier)
  }
  
  private func registerOptionCollectionViewCell(){
    let optionCollectionViewCellNib = UINib(nibName: OptionCollectionViewCell.identifier, bundle: nil)
    optionCollectionView.register(optionCollectionViewCellNib, forCellWithReuseIdentifier: OptionCollectionViewCell.identifier)
  }
  
  private func registerNumberCollectionViewCell(){
    let numberCollectionViewCellNib = UINib(nibName: NumberCollectionViewCell.identifier, bundle: nil)
    numberCollectionView.register(numberCollectionViewCellNib, forCellWithReuseIdentifier: NumberCollectionViewCell.identifier)
  }
  
  private func saveSudoku(){
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
  
  private func numberButtonTapped(_ index: Int){
    sudokuViewModel.setNum(num: index)
    numberCollectionView.reloadData()
    sudokuCollectionView.reloadData()
    if sudokuViewModel.gameOver(){
      endGame()
    }
  }
  
  private func endGame() {
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
  
  private func timerPlay(){
    isPlayingButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    isPlaying = true
    // timeInterval : 간격, target : 동작될 View, selector : 실행할 함수, userInfo : 사용자 정보, repeates : 반복
    timer = Timer.scheduledTimer(
      timeInterval: 1.0,
      target: self,
      selector: #selector(setTime),
      userInfo: nil,
      repeats: true)
  }

  private func timerPasue(){
    isPlayingButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    isPlaying = false
    timer?.invalidate()
  }

  @objc func setTime(){
    timerLabel.text = secondsToString(sec: timeCount)
    timeCount += 1
  }

  private func secondsToString(sec: Double) -> String {
    guard sec != 0 else { return "00 : 00" }
    let totalSeconds = Int(sec)
    let minute = totalSeconds / 60
    let seconds = totalSeconds % 60
    return String(format: "%02d : %02d", minute, seconds)
  }
}

// MARK: - UICollectionViewDataSource
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

// MARK: - UICollectionViewDelegate
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
