//
//  RankViewController.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/04/01.
//

import UIKit

class RankViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rankingLabel: UILabel!
    
    var rankViewModel = RankViewModel()
    var profileViewModel = ProfileViewModel()
    var todayViewModel = TodayViewModel()
    
    var rankInfo: [RankInfo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rankInfo = rankViewModel.rankInfo
        rankingLabel.text = "\(todayViewModel.monthOfToday)월의 랭킹 🏅"
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension RankViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rankInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankCell", for: indexPath) as? RankCell else { return UICollectionViewCell() }
        let name = rankInfo[indexPath.item].name
        var myScore: Bool = false
        if name == profileViewModel.profile.name{
            myScore = true
        }
        cell.updateUI(indexPath.item + 1, name, rankInfo[indexPath.item].clearCnt, myScore)
        
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
    @IBOutlet weak var view: UIView!
    
    func updateUI(_ rank: Int, _ name: String, _ clearCnt: Int,_ myScore: Bool){
        var rankText = ""
        if rank == 1{
            rankText = "🥇"
        }else if rank == 2{
            rankText = "🥈"
        }else if rank == 3{
            rankText = "🥉"
        }else {
            rankText = "\(rank)."
        }
        
        if myScore{
            view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
            view.layer.cornerRadius = 15
        } else{
            view.backgroundColor = UIColor.clear
        }
        rankLabel.text = rankText
        nameLabel.text = name
        timeLabel.text = "\(clearCnt)"
    }
}
