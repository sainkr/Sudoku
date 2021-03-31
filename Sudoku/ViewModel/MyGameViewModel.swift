//
//  MyGameViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/30.
//

import Foundation

class MyGameViewModel{
    private let manager = MyGameManager.shared
    
    public var myGame: MyGame{
        return manager.myGame
    }
    
    public func saveMyGame(_ myGame: MyGame){
        manager.saveMyGame(myGame)
    }
    
    public func retriveMyGame(){
        manager.retriveMyGame()
    }
    
    public func clearMyGame(){
        manager.clearMyGame()
    }
}
