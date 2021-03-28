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
        
        timerPlay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
    }
    
    @IBAction func isPlayingButtonTapped(_ sender: Any) {
        if isPlaying {
            timerPasue()
        } else {
            timerPlay()
        }
    }
}

extension GameViewController {
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
        print("\(min) : \(seconds)")
        return String(format: "%02d : %02d", min, seconds)
    }
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = numberCollectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as? NumberCell else { return UICollectionViewCell() }
        cell.updateUI(indexPath.item + 1)
        
        return cell
    }
}

extension GameViewController: UICollectionViewDelegate{
    
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
    
    func updateUI(_ num: Int){
        numberButton.setTitle(String(num), for: .normal)
    }
}
