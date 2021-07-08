//
//  MyGameViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/30.
//

import Foundation

class GameViewModel{
    func saveGame(game: Game){
        InnerDB.store(game, to: .documents, as: "mygame.json")
    }
    
    func loadGame() -> Game?{
        guard let game: Game = InnerDB.retrive("mygame.json", from: .documents, as: Game.self) else { return nil }
        return game
    }
    
    func clearGame(){
        InnerDB.clear(.documents)
    }
}

/*class MyGameViewModel{
    private let manager = MyGameManager.shared
    
    public var myGame: MyGame{
        return manager.myGame
    }
    
    public func saveMyGame(_ myGame: MyGame){
        manager.saveMyGame(myGame)
    }
    
    public func loadMyGame(){
        manager.loadMyGame()
    }
    
    public func clearMyGame(){
        manager.clearMyGame()
    }
}*/
