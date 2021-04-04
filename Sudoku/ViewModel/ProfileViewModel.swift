//
//  ProfileViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/04/04.
//

import Foundation

class ProfileViewModel{
    private let manager = ProfileManager.shared
    
    var profile: Profile{
        return manager.profile
    }
    
    func saveProfile(_ profile: Profile){
        manager.saveProfile(profile)
    }
    
    func loadProfile(){
        manager.loadProfile()
    }
}
