//
//  Profile.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/04/04.
//

import Foundation

struct Profile: Codable{
    var name: String
}

class ProfileManager{
    static let shared = ProfileManager()
    
    var profile: Profile = Profile(name: "SA")
    
    func saveProfile(_ profile: Profile){
        self.profile = profile
        InnerDB.store(profile, to: .documents, as: "profile.json")
    }
    
    func loadProfile(){
        guard let profile: Profile = InnerDB.retrive("profile.json", from: .documents, as: Profile.self) else { return }
        // print("--> myGame : \(myGame)")
        self.profile = profile
    }
}
