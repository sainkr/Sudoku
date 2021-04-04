//
//  RankViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/04/01.
//

import Foundation

class RankViewModel{
    private let manager = RankManager.shared
    
    var rank: [String: Int]{
        return manager.rank
    }
    
    var rankInfo: [RankInfo]{
        manager.rankInfo
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
    
    func addRank(_ name: String, _ clearCnt: Int, _ today: String){
        manager.addRank(name, clearCnt, today)
    }
}
