//
//  RankViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/04/01.
//

import Foundation

class RankViewModel{
    private let manager = RankManager.shared
    
    var rank: [String: Double]{
        return manager.rank
    }
    
    func setData(_ today: String){
        manager.setData(today)
    }
    
    func loadData(){
        manager.loadData()
    }
    
    func setRank(_ rank: [Rank]){
        manager.setRank(rank[0].rank)
    }
    
    func getSortRank() -> [RankInfo]{
        return manager.getSortRank()
    }
    
    func addRank(_ name: String, _ time: Double, _ today: String){
        manager.addRank(name, time, today)
    }
}
