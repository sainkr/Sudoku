//
//  RankViewController.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/04/01.
//

import UIKit

class RankViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var rankViewModel = RankViewModel()
    var rankInfo: [RankInfo] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        rankInfo = rankViewModel.getSortRank()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func secondsToString(sec: Double) -> String {
        guard sec != 0 else { return "00 : 00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d : %02d", min, seconds)
    }
}

extension RankViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rankInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankCell", for: indexPath) as? RankCell else { return UICollectionViewCell() }
        
        cell.updateUI(indexPath.item + 1, rankInfo[indexPath.item].name, secondsToString(sec: rankInfo[indexPath.item].time))
        
        return cell
    }
}

extension RankViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 50
        
        return CGSize(width: width, height: height)
    }
}
class RankCell: UICollectionViewCell{
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func updateUI(_ rank: Int, _ name: String, _ time: String){
        rankLabel.text = "\(rank)."
        nameLabel.text = name
        timeLabel.text = time
    }
}
