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
    var isSelected: [Bool]
    var memoArr: [[Int]]
    var numCount: [Int]
    // 힌트 사용 횟수
    // 실패 횟수
}

class MyGameManager{
    static let shared = MyGameManager()
    
    var myGame: MyGame = MyGame(level: -1, game_sudoku: [[]], original_sudoku: [[]], time: 0, isSelected: [], memoArr: [], numCount: [])
    
    func saveMyGame(_ myGame: MyGame){
        self.myGame = myGame
        InnerDB.store(myGame, to: .documents, as: "mygame.json")
    }
    
    func retriveMyGame(){
        guard let myGame: MyGame = InnerDB.retrive("mygame.json", from: .documents, as: MyGame.self) else { return }
        print("--> myGame : \(myGame)")
        self.myGame = myGame
    }
}
