//
//  OptionCell.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/07/16.
//

import UIKit

class OptionCollectionViewCell: UICollectionViewCell{
  static let identifier = "OptionCollectionViewCell"
  static let count = 4
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var label: UILabel!
  
  let optionImage: [String] = ["arrow.counterclockwise","trash", "highlighter", "lightbulb"]
  let optionLabel: [String] = ["실행 취소", "지우기", "메모", "힌트"]
  
  func updateUI(_ i: Int, _ memoSelect: Bool){
    imageView.image = UIImage(systemName: optionImage[i])
    imageView.tintColor = i == 2 && memoSelect ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.9516713023, green: 0.3511439562, blue: 0.1586719155, alpha: 1)
    label.text = optionLabel[i]
  }
}
