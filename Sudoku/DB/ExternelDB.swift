//
//  DataBaseManager.swift
//  WishList
//
//  Created by 홍승아 on 2021/04/01.
//

import Firebase

class DataBaseManager {
    static let shared = DataBaseManager()
    
    let db =  Database.database().reference().child("Rank")
    
    func setData(_ date: String ,_ rank: [String: Double]){
        print("---> rank : \(rank)")
        db.child(date).setValue(["rank":rank])
    }
    
    func loadData(){
        db.observeSingleEvent(of:.value) { (snapshot) in
            guard let rankValue = snapshot.value as? [String: Any] else {
                return
            }
            print("---> snapshot : \(rankValue.values)")
            
            do {
                let data = try JSONSerialization.data(withJSONObject: Array(rankValue.values), options: [])
                let decoder = JSONDecoder()
            
                let respone = try decoder.decode([Rank].self, from: data)
                
                let rankViewModel = RankViewModel()
                rankViewModel.setRank(respone)
                
                print("---> response : \(respone)")
            }
            catch {
                print("---> error : \(error)")
            }

        }
    }
}


