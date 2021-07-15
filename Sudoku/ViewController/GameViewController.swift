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
    @IBOutlet weak var missCountLabel: UILabel!
    
    @IBOutlet weak var numberCollectionView: UICollectionView!
    
    var sudokuViewController: SudokuViewController!
    var optionViewController: OptionViewController!
    
    var timer: Timer?
    var timeCount: Double = 0
    
    var isPlaying: Bool = true
    
    var sudokuViewModel = SudokuViewModel()
    var gameViewModel = GameViewModel()
    var dailyGameViewModel = DailyGameViewModel()
    let calendarViewModel = CalendarViewModel()
    
    let ClickNumberNotification: Notification.Name = Notification.Name("ClickNumberNotification")
    
    var gameType: GameType = .newGame
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sudoku"{
            let destinationVC = segue.destination as? SudokuViewController
            destinationVC?.delegate = self
            sudokuViewController = destinationVC
        } else if segue.identifier == "option"{
            let destinationVC = segue.destination as? OptionViewController
            destinationVC?.delegate = self
            optionViewController = destinationVC
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
        if !sudokuViewModel.gameOver(){
            saveSudoku()
        }
    }
    
    func setView(){
      timeCount = sudokuViewModel.time()
        if gameType == .continueGame{
            timeCount = gameViewModel.loadGame()?.time ?? 0
        } else if gameType == .dailyGame {
            timeCount = dailyGameViewModel.loadDailyGame()?.game.time ?? 0
        }
        timerPlay()
        
        numberCollectionView.reloadData()
        
        levelLabel.text = sudokuViewModel.level()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    func saveSudoku(){
        if gameType == .dailyGame{
            dailyGameViewModel.saveDailyGame(today: calendarViewModel.getDate(), game: sudokuViewModel.addTimeToGame(time: timeCount))
        }else{
            gameViewModel.saveGame(game: sudokuViewModel.addTimeToGame(time: timeCount))
        }
    }
}

extension GameViewController: CheckNumCountDelegate{
    func checkNumCount() {
        numberCollectionView.reloadData()
        
        if !sudokuViewModel.gameOver(){ return }
        // 끝내기
        timerPasue()
        if gameType == .dailyGame{
            dailyGameViewModel.addDailyGameClear(date: DailyGameClearDate(year: calendarViewModel.yearOfToday, month: calendarViewModel.monthOfToday, day: calendarViewModel.dayOfToday))
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


extension GameViewController: UICollectionViewDataSource { // 맨 밑에 숫자 누르는 것임 ..
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = numberCollectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as? NumberCell else { return UICollectionViewCell() }
        cell.updateUI(indexPath.item + 1, sudokuViewModel.currectAnswerCount(index: indexPath.item + 1))
        cell.clickButtonTapHandler = {
            NotificationCenter.default.post(name: self.ClickNumberNotification, object: nil, userInfo: ["num" : indexPath.item + 1])
        }
        return cell
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 10
        let width: CGFloat = (collectionView.bounds.width - margin) / 9
        return CGSize(width: width, height: width)
    }
}

class NumberCell: UICollectionViewCell{
    @IBOutlet weak var numberButton: UIButton!
    var clickButtonTapHandler: (() -> Void)?
    
    func updateUI(_ num: Int, _ numCount: Int){
        numberButton.setTitle(String(num), for: .normal)
        numberButton.isHidden = numCount == 9 ? true : false
    }
    
    @IBAction func clickButtonTapped(_ sender: Any) {
        clickButtonTapHandler?()
    }
}
