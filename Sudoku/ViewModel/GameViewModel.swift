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
    
    func removeGame(){
        InnerDB.remove("mygame.json", from: .documents)
    }
}
