//
//  PBSudokuViewModel.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/28.
//

import Foundation
import PBSudoku



public class SudokuManager{
    static var shared = SudokuManager()

    var original_sudoku: [[Int]] = []
    var game_sudoku: [[Int]] = []
    var numCount: [Int] = [0,0,0,0,0,0,0,0,0,0]
    var level = -1
    var isSelected: [Int] = Array(repeating: 0, count: 81)
    var memoArr: [[Int]] = []
    
    var isMemoSelected = false
    var clickIndex: [ClickIndex] = []
    var clickI = -1
    var clickJ = -1
    
    func setSudoku(_ myGame: Game){
        original_sudoku = myGame.original_sudoku
        game_sudoku = myGame.game_sudoku
        numCount = myGame.numCount
        level = myGame.level
        memoArr = myGame.memoArr
        clickIndex = myGame.clickIndex
        isSelected = Array(repeating: 0, count: 81)
        isMemoSelected = false
        clickI = -1
        clickJ = -1
    }
    
    func setLevel(level : Int){
        self.level = level
        sudoku.setLevel(level: level)
        original_sudoku = sudoku.original_sudoku
        game_sudoku = sudoku.game_sudoku
        memoArr = Array(repeating: [0,0,0,0,0,0,0,0,0], count: 81)
        isMemoSelected = false
        clickIndex = []
        clickI = -1
        clickJ = -1
    }
    
    func setGameSudoku(_ num: Int, _ x: Int, _ y: Int){
        game_sudoku[x][y] = num
    }
    
    func setisSelected(_ i: Int, _ value: Int){
        isSelected[i] = value
    }
    
    func setNumcount(){
        numCount = [0,0,0,0,0,0,0,0,0,0,0]
        for i in game_sudoku.indices{
            for j in game_sudoku[i].indices{
                numCount[game_sudoku[i][j]] += 1
            }
        }
    }
    // --
    func setNum(num: Int){
        if isMemoSelected{
            memoArr[ clickI * 9 + clickJ % 9 ][num - 1] = 1
            if clickIndex.last?.isMemo == false{ // 기본에서 Memo로 바뀌는 경우
                game_sudoku[clickI][clickJ] = 0
                clickIndex.append(ClickIndex(i: clickI, j: clickJ, currentNum: [num], beforeNum: -1, isMemo: true))
            }else{
                clickIndex.append(ClickIndex(i: clickI, j: clickJ, currentNum: [num], beforeNum: 0, isMemo: true))
            }
        }else{
            if game_sudoku[clickI][clickJ] != original_sudoku[clickI][clickJ] {
                // 1. 메모를 지워야 된다.
                memoArr[clickI * 9 + clickJ % 9] = [0,0,0,0,0,0,0,0,0]
                // 2. 방문 표시
                if num != original_sudoku[clickI][clickJ]{
                    clickIndex.append(ClickIndex(i: clickI, j: clickJ, currentNum: [num], beforeNum: game_sudoku[clickI][clickJ], isMemo: false))
                }else{
                    numCount[num - 1] -= 1
                }
                game_sudoku[clickI][clickJ] = num
            }
            setisSelected(clickI * 9 + clickJ % 9)
            setNumcount()
        }
    }
    
    func clickIndex(index: Int){
        clickI = index / 9
        clickJ = index % 9
        
        setisSelected(index)
    }
    
    func setisSelected(_ index: Int){
        isSelected = Array(repeating: 0, count: 81)
        let start_x = (index / 9) * 9
        let end_x = start_x + 8
        var y = index % 9
        
        // isSeleted = 1 : 행, 열, 사각형
        // 사각형
        var rectX = index / 9
        var rectY = y
        if rectX > 5 {
            rectX = 6
        }else if rectX > 2 {
            rectX = 3
        } else{
            rectX = 0
        }
        
        if rectY > 5 {
            rectY = 6
        }else if rectY > 2 {
            rectY = 3
        } else{
            rectY = 0
        }

        for i in rectX...(rectX+2){
            for j in 0..<3{
                setisSelected(9 * i + rectY + j, 1)
            }
        }
        // 행
        for i in start_x...end_x{
            setisSelected(i, 1)
        }
        // 열
        while y < 81 {
            setisSelected(y, 1)
            y += 9
        }
        // isSeleted = 2 : 같은 숫자
        let num = game_sudoku[index / 9][index % 9]
        if  num != 0{
            for i in 0...8{
                for j in 0...8{
                    if game_sudoku[i][j] == num{
                        setisSelected(i * 9 + j, 2)
                    }
                }
            }
        }
        // isSelected = 3 : 현재 선택된 숫자
        setisSelected(index, 3)
    }
    
    func setOption(optionNum: Int){
        if optionNum == 0 { // 실행 취소
            if let click = clickIndex.last{
                if click.isMemo{
                    if click.beforeNum == -1{ // 메모에서 일반 스도쿠로 실행 취소 되는 경우
                        // 1. 메모를 지우고
                        memoArr[click.i * 9 + click.j % 9] = [0,0,0,0,0,0,0,0,0]
                        // 2. 이전 데이터로 변경
                        game_sudoku[click.i][click.j] = 0
                    }else{ // 메모에서 메모로 실행 취소 되는 경우
                        for i in click.currentNum.indices{
                            memoArr[click.i * 9 + click.j % 9][click.currentNum[i] - 1] = click.beforeNum
                        }
                    }
                }else{
                    game_sudoku[click.i][click.j] = click.beforeNum
                    setNumcount()
                }
                clickIndex.removeLast()
                setisSelected(click.i * 9 + click.j % 9)
            }
            
        } else if optionNum == 1{ // 지우기
            if let click = clickIndex.last{
                if isMemoSelected{
                    var currentNumArr: [Int] = []
                    for i in memoArr[click.i * 9 + click.j % 9].indices{
                        if memoArr[click.i * 9 + click.j % 9][i] == 1{
                            currentNumArr.append(i + 1)
                        }
                    }
                    clickIndex.append(ClickIndex(i: click.i, j: click.j , currentNum: currentNumArr, beforeNum: 1, isMemo: isMemoSelected))
                    memoArr[click.i * 9 + click.j % 9] = [0,0,0,0,0,0,0,0,0]
                }else{
                    setNum(num: 0)
                }
            }
        } else if optionNum == 2 { // 메모
            isMemoSelected = !isMemoSelected
        } else { // 힌트
            if game_sudoku[clickI][clickJ] != original_sudoku[clickI][clickJ]{
                if isMemoSelected{
                    var currentNumArr: [Int] = []
                    for i in memoArr[clickI * 9 + clickJ % 9].indices{
                        if memoArr[clickI * 9 + clickJ % 9][i] == 1{
                            currentNumArr.append(i + 1)
                        }
                    }
                    clickIndex.append(ClickIndex(i: clickI, j: clickJ , currentNum: currentNumArr, beforeNum: 1, isMemo: false))
                    isMemoSelected = false
                    setNum(num: original_sudoku[clickI][clickJ])
                    isMemoSelected = true
                }else{
                    clickIndex.append(ClickIndex(i: clickI, j: clickJ , currentNum: [original_sudoku[clickI][clickJ]], beforeNum: game_sudoku[clickI][clickJ], isMemo: isMemoSelected))
                    setNum(num: original_sudoku[clickI][clickJ])
                }
            }
            setNumcount()
        }
    }
    
    func getLevel() -> String{
        if level == 0 {
            return "쉬움"
        } else if level == 1 {
            return "보통"
        } else {
            return "어려움"
        }
    }
    
    func gameOver() -> Bool{
        if game_sudoku == original_sudoku{
            return true
        }else{
            return false
        }
    }
    func getGame(time: Double) -> Game{
        return Game(level: level, game_sudoku: game_sudoku, original_sudoku: original_sudoku, time: time, memoArr: memoArr, numCount: numCount, clickIndex: clickIndex)
    }
}


class SudokuViewModel{
    private let manager = SudokuManager.shared

    var game_sudoku: [[Int]]{
        return manager.game_sudoku
    }
    var original_sudoku: [[Int]]{
        return manager.original_sudoku
    }
    var memoArr: [[Int]]{
        return manager.memoArr
    }
    var isMemoSelected: Bool{
        return manager.isMemoSelected
    }
    var isSelected: [Int]{
        return manager.isSelected
    }
    var numCount: [Int]{
        return manager.numCount
    }
    
    func setLevel(level : Int){
        manager.setLevel(level: level)
    }
    
    func setGameSudoku(_ num : Int, _ x: Int, _ y: Int){
        manager.setGameSudoku(num, x, y)
    }
    
    func setSudoku(_ game: Game){
        manager.setSudoku(game)
    }
    // ---
    func setNum(num: Int){
        manager.setNum(num: num)
    }
    
    func clickIndex(index: Int){
        manager.clickIndex(index: index)
    }
    
    func setOption(optionNum: Int){
        manager.setOption(optionNum: optionNum)
    }
    
    func getLevel() -> String{
        return manager.getLevel()
    }
    
    func gameOver() -> Bool{
        return manager.gameOver()
    }
    
    func getGame(time: Double) -> Game{
        return manager.getGame(time: time)
    }
}
