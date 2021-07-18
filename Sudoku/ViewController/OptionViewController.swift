//
//  OptionViewController.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/25.
//

import UIKit

class OptionViewController: UIViewController{
  @IBOutlet weak var collectionView: UICollectionView!
  
  let OptionNotification: Notification.Name = Notification.Name("OptionNotification")
  let sudokuViewModel = SudokuViewModel()
  
  weak var delegate: CheckNumCountDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension OptionViewController: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCell", for: indexPath) as? OptionCell else { return UICollectionViewCell() }
    cell.updateUI(indexPath.item, sudokuViewModel.isMemoOptionSelected)
    return cell
  }
}

extension OptionViewController: UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    sudokuViewModel.setOption(optionNum: indexPath.item)
    if indexPath.item == 2 {
      collectionView.reloadData()
    }
    delegate?.checkNumCount()
    NotificationCenter.default.post(name: OptionNotification, object: nil, userInfo: nil)
  }
}

extension OptionViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width: CGFloat = collectionView.bounds.width / 4
    let height: CGFloat = width * 1.2
    return CGSize(width: width, height: height)
  }
}
