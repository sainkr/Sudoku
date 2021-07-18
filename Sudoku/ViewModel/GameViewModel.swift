//
//  MyGameViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/30.
//

import Foundation

class GameViewModel{
  func saveGame(game: Game){
    Storage.store(game, to: .documents, as: "mygame.json")
  }
  
  func fetchGame() -> Game?{
    guard let game: Game = Storage.retrive("mygame.json", from: .documents, as: Game.self) else { return nil }
    return game
  }
  
  func removeGame(){
    Storage.remove("mygame.json", from: .documents)
  }
  
  func clearGame(){
    Storage.clear(.documents)
  }
}
