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
    
    var sudokuViewModel = PBSudokuViewModel()
    var myGameViewModel = MyGameViewModel()
    var todayGameViewModel = TodayGameViewModel()
    var rankViewModel = RankViewModel()
    
    let ClickNumberNotification: Notification.Name = Notification.Name("ClickNumberNotification")
    let CheckNumCountNotification: Notification.Name = Notification.Name("CheckNumCountNotification")
    
    var gameType = 0

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sudoku"{
            let destinationVC = segue.destination as? SudokuViewController
            sudokuViewController = destinationVC
        } else if segue.identifier == "option"{
            let destinationVC = segue.destination as? OptionViewController
            optionViewController = destinationVC
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setNumberHidden(_:)), name: CheckNumCountNotification, object: nil)
        
        setView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
        saveSudoku()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        timer?.invalidate()
        saveSudoku()
    }
    
    func setView(){
        if gameType == 0{
            timeCount = myGameViewModel.myGame.time
        } else {
            timeCount = todayGameViewModel.todayGame.time
        }
        timerPlay()
        
        numberCollectionView.reloadData()
        
        if sudokuViewModel.level == 0 {
            levelLabel.text = "쉬움"
        } else if sudokuViewModel.level == 1 {
            levelLabel.text = "보통"
        } else {
            levelLabel.text = "어려움"
        }
    }
}

extension GameViewController {
    @IBAction func isPlayingButtonTapped(_ sender: Any) {
        if isPlaying {
            timerPasue()
            pauseView.isHidden = false
        } else {
            timerPlay()
            pauseView.isHidden = true
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
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
    
    // 숫자 다썼으면 hidden 해주기, 다 채웠으면 끝내기
    @objc func setNumberHidden(_ noti: Notification){
        numberCollectionView.reloadData()
        for i in 1...9{
            if sudokuViewModel.numCount[i] < 9 {
                return
            }
        }
        // 끝내기
        print("----> type : \(gameType)")
        timerPasue()
        if gameType == 0{
            myGameViewModel.clearMyGame()
            
        }else{
            todayGameViewModel.addTodayGameCalendar()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func saveSudoku(){
        // 저장
        print("----> 저장")
        sudokuViewModel.resetisSelected()
        if gameType == 0{
            myGameViewModel.saveMyGame(MyGame(level: sudokuViewModel.level, game_sudoku: sudokuViewModel.game_sudoku, original_sudoku: sudokuViewModel.original_sudoku, time: timeCount, memoArr: sudokuViewModel.memoArr, numCount: sudokuViewModel.numCount))
        }else {
            todayGameViewModel.saveTodayGame(TodayGame(today: todayGameViewModel.todayGame.today, todayDate:todayGameViewModel.todayGame.todayDate, todayGameCalendar: todayGameViewModel.todayGame.todayGameCalendar, level: sudokuViewModel.level, game_sudoku: sudokuViewModel.game_sudoku, original_sudoku: sudokuViewModel.original_sudoku, time: timeCount, memoArr: sudokuViewModel.memoArr, numCount: sudokuViewModel.numCount))
        }
    }
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = numberCollectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as? NumberCell else { return UICollectionViewCell() }
        
        cell.updateUI(indexPath.item + 1, sudokuViewModel.numCount[indexPath.item + 1])
        
        
        cell.clickButtonTapHandler = {
            print("handler")
            NotificationCenter.default.post(name: self.ClickNumberNotification, object: nil, userInfo: ["num" : indexPath.item + 1])

        }
        
        return cell
    }
}

extension GameViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        if numCount == 9 {
            numberButton.isHidden = true
        }else {
            numberButton.isHidden = false
        }
    }
    
    @IBAction func clickButtonTapped(_ sender: Any) {
        clickButtonTapHandler?()
    }
}
