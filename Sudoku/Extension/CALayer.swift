//
//  CALayer.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/07/16.
//

import UIKit

extension CALayer{
  func addBorder(_ arr_edge: [LayerType], _ boldWidth : CGFloat, _ basicWidth: CGFloat) {
    let boldWidth: CGFloat = boldWidth // 테두리 두께
    let basicWidth: CGFloat = basicWidth // 테두리 두께
    
    // .top : CGRect.init(x: 0, y: 0, width: frame.width, height: 테두리Width)
    // .bottom : CGRect.init(x: 0, y: frame.height - 테두리Width, width: frame.width, height: 테두리Width)
    // .left : CGRect.init(x: 0, y: 0, width: 테두리Width, height: frame.height)
    // .right : CGRect.init(x: frame.width - 테두리Width, y: 0, width: 테두리Width, height: frame.height)
    
    // 굵은 선
    let boldCgRect: [CGRect] = [CGRect.init(x: 0, y: 0, width: frame.width, height: boldWidth),
                                CGRect.init(x: 0, y: frame.height - boldWidth, width: frame.width, height: boldWidth),
                                CGRect.init(x: 0, y: 0, width: boldWidth, height: frame.height),
                                CGRect.init(x: frame.width - boldWidth, y: 0, width: boldWidth, height: frame.height)]
    // 회색 선
    let basicCgRect: [CGRect] = [CGRect.init(x: 0, y: 0, width: frame.width, height: basicWidth),
                                 CGRect.init(x: 0, y: frame.height - basicWidth, width: frame.width, height: basicWidth),
                                 CGRect.init(x: 0, y: 0, width: basicWidth, height: frame.height),
                                 CGRect.init(x: frame.width - basicWidth, y: 0, width: basicWidth, height: frame.height)]
    
    for j in 0...3 {
      let border = CALayer()
      if arr_edge[j] == .basic {
        border.frame = basicCgRect[j]
        border.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      }else{
        border.frame = boldCgRect[j]
        border.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.addSublayer(border)
      }
      self.addSublayer(border)
    }
  }
}
