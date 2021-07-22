//
//  SudokuCell.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/07/16.
//

import UIKit

class SudokuCollectionViewCell: UICollectionViewCell{
  static let identifier = "SudokuCollectionViewCell"
  static let count = 81
  
  @IBOutlet weak var memoLabel1: UILabel!
  @IBOutlet weak var memoLabel2: UILabel!
  @IBOutlet weak var memoLabel3: UILabel!
  @IBOutlet weak var memoLabel4: UILabel!
  @IBOutlet weak var memoLabel5: UILabel!
  @IBOutlet weak var memoLabel6: UILabel!
  @IBOutlet weak var memoLabel7: UILabel!
  @IBOutlet weak var memoLabel8: UILabel!
  @IBOutlet weak var memoLabel9: UILabel!
  @IBOutlet weak var numLabel: UILabel!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    // layer를 계속 추가하면 선이 굵어지니 추가한 것들을 삭제해준다.
    for _ in 1...4{
      contentView.layer.sublayers?.removeLast()
    }
  }
  
  func updateMemoUI(_ memoSelect: [Bool]){
    let memoLabels: [UILabel] = [memoLabel1, memoLabel2, memoLabel3, memoLabel4, memoLabel5, memoLabel6, memoLabel7, memoLabel8, memoLabel9]
    for i in 0...8{
      memoLabels[i].isHidden = memoSelect[i] ? false : true
    }
  }
  
  func updateUI(index : Int, sudokuNum: Int, cellType: ClickedCellType, isCorrect: Bool){
    numLabel.text = sudokuNum == 0 ? "" : String(sudokuNum)
    numLabel.textColor = isCorrect ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : UIColor.red
    setBackGroundColor(cellType)
    setEdge(index)
  }
  
  func setBackGroundColor(_ type: ClickedCellType){
    if type == .none{
      contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }else if type == .col || type == .row || type == .rectangle{
      contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4607823897, blue: 0.08191460459, alpha: 0.4498033588)
    }else if type == .sameNum {
      contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4607823897, blue: 0.08191460459, alpha: 0.6607408588)
    }else if type == .current{
      contentView.backgroundColor = #colorLiteral(red: 0.7222955823, green: 0.7224185467, blue: 0.7222794294, alpha: 0.3357780612)
    }
  }
  
  func setEdge(_ i: Int){
    // 행 비교
    var edgeArr: [LayerType] = [.basic,.basic,.basic,.basic]
    if (i / 9 % 3) == 0 { // 3 x 3 중 첫번째 줄
      if i % 3 == 0 { // 위, 왼 굵은선
        edgeArr = [.bold,.basic,.bold,.basic]
      } else if i % 3 == 1 { // 위 굵은선
        edgeArr = [.bold,.basic,.basic,.basic]
      } else{ // 위, 오 굵은선
        edgeArr = [.bold,.basic,.basic,.bold]
      }
    } else if (i / 9 % 3) == 1 { // 3 x 3 중 가운데 줄
      if i % 3 == 0 { // 왼 굵은선
        edgeArr = [.basic,.basic,.bold,.basic]
      } else if i % 3 == 2 { // 오 굵은선
        edgeArr = [.basic,.basic,.basic,.bold]
      }
    } else{ // 3 x 3 중 세번째 줄
      if i % 3 == 0 { // 왼, 아 굵은선
        edgeArr = [.basic,.bold,.bold,.basic]
      } else if i % 3 == 1 { // 아 굵은선
        edgeArr = [.basic,.bold,.basic,.basic]
      } else{ // 아, 오 굵은선
        edgeArr = [.basic,.bold,.basic,.bold]
      }
    }
    contentView.layer.addBorder(edgeArr,1,0.5)
  }
}
