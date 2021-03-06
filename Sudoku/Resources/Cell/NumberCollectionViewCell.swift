//
//  NumberCell.swift
//  Sudoku
//
//  Created by νμΉμ on 2021/07/16.
//

import UIKit

class NumberCollectionViewCell: UICollectionViewCell{
  static let identifier = "NumberCollectionViewCell"
  static let count = 9
  
  @IBOutlet weak var numberButton: UIButton!
  var clickButtonTapHandler: (() -> Void)?
  
  func updateUI(_ num: Int, _ numCount: Int){
    numberButton.setTitle(String(num), for: .normal)
    numberButton.isHidden = numCount == 9 ? true : false
  }
  
  @IBAction func clickButtonTapped(_ sender: Any) {
    clickButtonTapHandler?()
  }
}
