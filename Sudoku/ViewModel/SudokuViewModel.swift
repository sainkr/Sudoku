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
  
  private var game = Game(
    level: -1,
    gameSudoku: [],
    originalSudoku: [],
    time: 0,
    memo: [],
    currectAnswerCount: [],
    clickedCellDB: [])
  var isMemoOptionSelected: Bool = false
  private var isCellSelected: [ClickedCellType] = []
  private var currentClickIndex = 0
  
  func setSudoku(_ myGame: Game){ // 이전 게임 데이터를 불러옴
    game = myGame
    isMemoOptionSelected = false
    isCellSelected = Array(repeating: .none, count: 81)
    currentClickIndex = 0
    setisSelected(0)
  }
  
  func setSudoku(level : Int){ // 새로운 게임 생성
    // PBSudoku 라이브러리 사용
    sudoku.setLevel(level: level)
    game =  Game(
      level: level,
      gameSudoku: sudoku.game_sudoku,
      originalSudoku: sudoku.original_sudoku,
      time: 0,
      memo: Array(repeating: Array(repeating: false, count: 9), count: 81),
      currectAnswerCount: Array(repeating: 0, count: 10),
      clickedCellDB: [])
    isMemoOptionSelected = false
    isCellSelected = Array(repeating: .none, count: 81)
    currentClickIndex = 0
    setisSelected(0)
  }
  
  func currectAnswerCount(){ // 정답 숫자의 갯수를 체크함
    game.currectAnswerCount = [0,0,0,0,0,0,0,0,0,0,0]
    for i in game.gameSudoku.indices{
      for j in game.gameSudoku[i].indices{
        game.currectAnswerCount[game.gameSudoku[i][j]] += 1
      }
    }
  }
  
  func setNum(num: Int){ // 스도쿠 판 숫자 설정
    if isCorrect(index: currentClickIndex){ return }
    let i = currentClickIndex / 9
    let j = currentClickIndex % 9
    if !isMemoOptionSelected || num == 0{
      var currentNum = [num]
      var beforeNum = [game.gameSudoku[i][j]]
      // 메모 숫자를 띄운 상태에서 메모 옵션을 취소하고 일반 숫자를 입력하는 경우
      if game.memo[currentClickIndex] != Array(repeating: false, count: 9){
        currentNum = [-1]
        beforeNum = []
        for i in game.memo[currentClickIndex].indices{
          if game.memo[currentClickIndex][i]{
            beforeNum.append(i)
          }
        }
      }
      if num != game.originalSudoku[i][j]{ // 선택한 숫자가 정답이 아니면
        game.clickedCellDB.append(ClickedCellDB(
                                    clickedCellIndex: currentClickIndex,
                                    currentNum: currentNum,
                                    beforeNum: beforeNum,
                                    isMemo: false))
      }
      // 메모 초기화
      game.memo[currentClickIndex] = Array(repeating: false, count: 9)
      // gameSudoku 값 변경
      game.gameSudoku[i][j] = num
      setisSelected(currentClickIndex)
      currectAnswerCount()
    }else{ // 메모 옵션을 눌렀을 시
      // 해당 숫자의 메모여부를 true로 설정
      game.memo[currentClickIndex][num - 1] = true
      var beforeNum = -1 // 이 전에도 메모 옵션이였다면 -1
      // 메모 옵션을 취소하고 일반 숫자를 누른다면 game.gameSudoku[i][j]
      if game.clickedCellDB.last?.isMemo == false{
        beforeNum = game.gameSudoku[i][j]
        game.gameSudoku[i][j] = 0
      }
      game.clickedCellDB.append(ClickedCellDB(
                                  clickedCellIndex: currentClickIndex,
                                  currentNum: [num],
                                  beforeNum: [beforeNum],
                                  isMemo: true))
    }
  }
  
  func clickIndex(index: Int){ // 클릭한 셀의 인덱스를 받아옴
    currentClickIndex = index
    setisSelected(index)
  }
  
  func setisSelected(_ index: Int){ // 선택된 칸과 관련된 칸들의 배경색 변경을 위해 isCellSelected 설정
    isCellSelected = Array(repeating: .none, count: 81)
    // 선택한 칸을 포함하는 사각형
    let rectX = index / 9 / 3 * 3
    let rectY = index % 9 / 3 * 3
    for i in rectX...(rectX+2){
      for j in 0..<3{
        isCellSelected[9 * i + rectY + j] = .rectangle
      }
    }
    // 선택된 칸과 같은 행
    let row = (index / 9) * 9
    for i in row...row + 8{
      isCellSelected[i] = .row
    }
    // 선택된 칸과 같은 열
    var col = index % 9
    for _ in 1...9 {
      isCellSelected[col] = .col
      col += 9
    }
    // 선택한 칸의 숫자와 같은 숫자
    let num = game.gameSudoku[index / 9][index % 9]
    if num != 0{
      for i in 0...8{
        for j in 0...8{
          if game.gameSudoku[i][j] == num{
            isCellSelected[i * 9 + j] = .sameNum
          }
        }
      }
    }
    // 현재 선택된 칸
    isCellSelected[index] = .current
  }
  
  func undo(){ // 실행 취소
    guard let clickedCell = game.clickedCellDB.last else { return }
    let i = clickedCell.clickedCellIndex / 9
    let j = clickedCell.clickedCellIndex % 9
    if clickedCell.isMemo{
      game.memo[clickedCell.clickedCellIndex][clickedCell.currentNum[0] - 1] = false
      if clickedCell.beforeNum != [-1]{ // 메모에서 일반일 경우
        game.gameSudoku[i][j] = clickedCell.beforeNum[0]
      }
    }else{
      if clickedCell.currentNum == [-1]{ // 일반에서 메모일 경우
        game.gameSudoku[i][j] = 0
        for num in clickedCell.beforeNum.indices{
          game.memo[clickedCell.clickedCellIndex][clickedCell.beforeNum[num]] = true
        }
      }else{
        game.gameSudoku[i][j] = clickedCell.beforeNum[0]
      }
    }
    setisSelected(clickedCell.clickedCellIndex)
    game.clickedCellDB.removeLast()
  }
  
  func clear(){
    setNum(num: 0)
  }
  
  func hint(){
    let i = currentClickIndex / 9
    let j = currentClickIndex % 9
    
    if game.gameSudoku[i][j] != game.originalSudoku[i][j]{
      print("진입 -- ")
      let isMemo = isMemoOptionSelected
      isMemoOptionSelected = false
      setNum(num: game.originalSudoku[i][j])
      isMemoOptionSelected = isMemo
    }
    currectAnswerCount()
  }
  
  func setOption(optionNum: Int){
    if optionNum == 0 { // 실행 취소
      undo()
    } else if optionNum == 1{ // 지우기
      clear()
    } else if optionNum == 2 { // 메모
      isMemoOptionSelected = !isMemoOptionSelected
    } else { // 힌트
      hint()
    }
  }
  
  func level() -> String{
    if game.level == 1 {
      return "쉬움"
    } else if game.level == 2 {
      return "보통"
    } else {
      return "어려움"
    }
  }
  
  func gameOver() -> Bool{
    return game.gameSudoku == game.originalSudoku ? true : false
  }
  
  func addTimeToGame(time: Double)->Game{
    game.time = time
    return game
  }
  
  func memo(index: Int)-> [Bool]{
    return game.memo[index]
  }
  
  func gameSudoku(index: Int)-> Int{
    return game.gameSudoku[index / 9][index % 9]
  }
  
  func isCorrect(index: Int)-> Bool{
    return game.gameSudoku[index / 9][index % 9] == game.originalSudoku [index / 9][index % 9] ? true: false
  }
  
  func selected(index: Int)-> ClickedCellType{
    return isCellSelected[index]
  }
  
  func currectAnswerCount(index: Int)-> Int{
    return game.currectAnswerCount[index]
  }
  
  func time()-> Double{
    return game.time
  }
}

class SudokuViewModel{
  private let manager = SudokuManager.shared
  
  var isMemoOptionSelected: Bool{
    return manager.isMemoOptionSelected
  }
  
  func selected(index: Int)-> ClickedCellType{
    return manager.selected(index: index)
  }
  
  func currectAnswerCount(index: Int)-> Int{
    return manager.currectAnswerCount(index: index)
  }
  
  func time()-> Double{
    return manager.time()
  }
  
  func memo(index: Int)-> [Bool]{
    return manager.memo(index: index)
  }
  
  func gameSudoku(index: Int)-> Int{
    return manager.gameSudoku(index: index)
  }
  
  func isCorrect(index: Int)-> Bool{
    return manager.isCorrect(index: index)
  }
  
  func setSudoku(level : Int){
    manager.setSudoku(level: level)
  }
  
  func setSudoku(_ game: Game){
    manager.setSudoku(game)
  }
  
  func setNum(num: Int){
    manager.setNum(num: num)
  }
  
  func clickIndex(index: Int){
    manager.clickIndex(index: index)
  }
  
  func setOption(optionNum: Int){
    manager.setOption(optionNum: optionNum)
  }
  
  func level() -> String{
    return manager.level()
  }
  
  func gameOver() -> Bool{
    return manager.gameOver()
  }
  
  func addTimeToGame(time: Double) -> Game{
    return manager.addTimeToGame(time: time)
  }
}
