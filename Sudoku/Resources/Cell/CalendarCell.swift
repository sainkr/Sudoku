//
//  CalendarCell.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/07/16.
//

import UIKit

class CalendarCell: UICollectionViewCell{
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var view: UIView!
  
  func updateUI(_ day: Int, _ currentDay: Int, _ success: Bool){
    dayLabel.text = day > 0 ? "\(day)" : " "
    dayLabel.textColor = day <= currentDay ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    if success{
      view.backgroundColor = #colorLiteral(red: 0.9516713023, green: 0.3511439562, blue: 0.1586719155, alpha: 1)
      view.layer.cornerRadius = 20
    }else {
      view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
  }
}
