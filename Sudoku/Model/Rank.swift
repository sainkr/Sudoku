//
//  Rank.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/04/01.
//

import Foundation

struct RankInfo{
    var name: String
    var clearCnt: Int
}
struct Rank: Codable {
    var rank: [String: Int]
}

class RankManager{
    static let shared = RankManager()
    
    var rank: [String: Int] = [:]
    var rankInfo: [RankInfo] = []
    
    func setData(_ today: String){
        DataBaseManager.shared.setData(today, ["SA" : 4, "JH": 3, "JW" : 1, "LU" : 2])
    }
    
    func loadData(){
        DataBaseManager.shared.loadData()
    }
    
    func addRank(_ name: String, _ clearCnt: Int, _ today: String){
        rank[name] = clearCnt
        setData(today)
    }
    
    func getSortRank(){
        let sortRank = rank.sorted{$0.value > $1.value}
        rankInfo = []
        for i in sortRank{
            rankInfo.append(RankInfo(name: i.key, clearCnt: Int(i.value)))
        }
    }
    
    func setRank(_ rank : [String: Int]){
        self.rank = rank
        getSortRank()
    }
}
