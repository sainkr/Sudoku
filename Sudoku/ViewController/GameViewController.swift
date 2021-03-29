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
    
    @IBOutlet weak var numberCollectionView: UICollectionView!
    
    var sudokuViewController: SudokuViewController!
    var optionViewController: OptionViewController!
    
    var timer: Timer?
    var count: Double = 0
    
    var isPlaying: Bool = true
    
    var cellisHidden: [Int] = [0,0,0,0,0,0,0,0,0]
    
    var sudokuViewModel = PBSudokuViewModel()
    
    var difficulty: Int = -1
    
    let ClickNumberNotification: Notification.Name = Notification.Name("ClickNumberNotification")
    let CheckNumCountNotification: Notification.Name = Notification.Name("CheckNumCountNotification")

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
        
        timerPlay()
        
        for i in 1...9{
            if sudokuViewModel.numCount[i] == 9 {
                cellisHidden[i-1] = 1
            }
        }
        
        numberCollectionView.reloadData()
        
        if difficulty == 0 {
            levelLabel.text = "쉬움"
        } else if difficulty == 1 {
            levelLabel.text = "보통"
        } else {
            levelLabel.text = "어려움"
        }
        
        sudokuViewModel.setLevel(level: difficulty)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
    }
}

extension GameViewController {
    
    @IBAction func isPlayingButtonTapped(_ sender: Any) {
        if isPlaying {
            timerPasue()
        } else {
            timerPlay()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    func timerPlay(){
        isPlayingButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        pauseView.isHidden = true
        isPlaying = true
        // timeInterval : 간격, target : 동작될 View, selector : 실행할 함수, userInfo : 사용자 정보, repeates : 반복
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
    }
    
    func timerPasue(){
        isPlayingButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        pauseView.isHidden = false
        
        isPlaying = false
        timer?.invalidate()
    }
    
    @objc func setTime(){
        timerLabel.text = secondsToString(sec: count)
        count += 1
    }
    
    func secondsToString(sec: Double) -> String {
        guard sec != 0 else { return "00 : 00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d : %02d", min, seconds)
    }
    
    // 숫자 다썼으면 hidden 해주기
    @objc func setNumberHidden(_ noti: Notification){
        guard let num = noti.userInfo?["num"] as? Int else { return }
        
        cellisHidden[num-1] = 1
        
        var cnt = 0
        for i in cellisHidden{
            if i == 1 {
                cnt += 1
            }
        }
        
        if cnt == 9 {
            timerPasue()
        }
        
        numberCollectionView.reloadData()
    }
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = numberCollectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as? NumberCell else { return UICollectionViewCell() }
        
        if cellisHidden[indexPath.item] == 1 {
            cell.updateHidden()
        } else {
            cell.updateUI(indexPath.item + 1)
        }
        
        cell.clickButtonTapHandler = {
            if self.cellisHidden[indexPath.item] == 0{
                NotificationCenter.default.post(name: self.ClickNumberNotification, object: nil, userInfo: ["num" : indexPath.item + 1])
            }
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
    
    func updateHidden(){
        numberButton.isHidden = true
    }
    
    func updateUI(_ num: Int){
        numberButton.setTitle(String(num), for: .normal)
    }
    
    @IBAction func clickButtonTapped(_ sender: Any) {
        clickButtonTapHandler?()
    }
}
