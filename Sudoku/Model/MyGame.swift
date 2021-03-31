//
//  MyGame.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/30.
//

import Foundation

struct MyGame: Codable{
    var level: Int
    var game_sudoku: [[Int]]
    var original_sudoku: [[Int]]
    var time: Double
    var memoArr: [[Int]]
    var numCount: [Int]
    var missCount: Int
}

class MyGameManager{
    static let shared = MyGameManager()
    
    var myGame: MyGame = MyGame(level: -1, game_sudoku: [[]], original_sudoku: [[]], time: 0, memoArr: [], numCount: [], missCount: 0)
    
    func saveMyGame(_ myGame: MyGame){
        self.myGame = myGame
        InnerDB.store(myGame, to: .documents, as: "mygame.json")
    }
    
    func retriveMyGame(){
        guard let myGame: MyGame = InnerDB.retrive("mygame.json", from: .documents, as: MyGame.self) else { return }
        // print("--> myGame : \(myGame)")
        self.myGame = myGame
    }
    
    func clearMyGame(){
        self.myGame = MyGame(level: -1, game_sudoku: [[]], original_sudoku: [[]], time: 0, memoArr: [], numCount: [], missCount: 0)
        InnerDB.clear(.documents)
    }
}
