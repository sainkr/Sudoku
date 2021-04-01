//
//  Rank.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/04/01.
//

import Foundation

struct RankInfo{
    var name: String
    var time: Double
}
struct Rank: Codable {
    var rank: [String: Double]
}

class RankManager{
    static let shared = RankManager()
    
    var rank: [String: Double] = [:]
    func setData(_ today: String){
        DataBaseManager.shared.setData(today, rank)
    }
    
    func loadData(){
        DataBaseManager.shared.loadData()
    }
    
    func addRank(_ name: String, _ time: Double, _ today: String){
        rank[name] = time
        setData(today)
    }
    
    func getSortRank() -> [RankInfo]{
        let sortRank = rank.sorted{$0.value < $1.value}
        var rankInfo: [RankInfo] = []
        for i in sortRank{
            rankInfo.append(RankInfo(name: i.key, time: i.value))
        }
        return rankInfo
    }
    
    func setRank(_ rank : [String: Double]){
        self.rank = rank
    }
}
