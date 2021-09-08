//
//  NumberCollectionViewCell.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/09/08.
//

import UIKit

class NumberCollectionViewCell: UICollectionViewCell {
  static let identifier = "NumberCollectionViewCell"
  static let count = 9
  
  @IBOutlet weak var numberButton: UIButton!
  
  var clickButtonTapHandler: (() -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func updateUI(_ num: Int, _ numCount: Int){
    numberButton.setTitle(String(num), for: .normal)
    numberButton.isHidden = numCount == 9 ? true : false
  }
  
  @IBAction func clickButtonTapped(_ sender: Any) {
    clickButtonTapHandler?()
  }
}
