//
//  SudokuViewController.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/25.
//

import UIKit

class SudokuViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  
  var sudokuViewModel = SudokuViewModel()
  var myGameViewModel = GameViewModel()
  
  let ClickNumberNotification: Notification.Name = Notification.Name("ClickNumberNotification")
  let OptionNotification: Notification.Name = Notification.Name("OptionNotification")
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.clickNumberNotification(_:)), name: ClickNumberNotification , object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.optionNotification(_:)), name: OptionNotification, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    NotificationCenter.default.removeObserver(self)
  }
}
// MARK:- Notification
extension SudokuViewController{
  // 숫자 클릭했을 때 notifi
  @objc func clickNumberNotification(_ noti: Notification){
    guard let num = noti.userInfo?["num"] as? Int else { return }
    sudokuViewModel.setNum(num: num)
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
  // 옵션 클릭했을 때 notifi
  @objc func optionNotification(_ noti: Notification){
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
}

extension SudokuViewController: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 81
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath) as? SudokuCell else { return UICollectionViewCell() }
    
    cell.updateMemoUI(sudokuViewModel.memo(index: indexPath.item))
    cell.updateUI(
      index: indexPath.item,
      sudokuNum: sudokuViewModel.gameSudoku(index: indexPath.item),
      cellType: sudokuViewModel.selected(index: indexPath.item),
      isCorrect: sudokuViewModel.isCorrect(index: indexPath.item))
    
    return cell
  }
}

extension SudokuViewController: UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    sudokuViewModel.clickIndex(index: indexPath.item)
    collectionView.reloadData()
  }
}

extension SudokuViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width: CGFloat = collectionView.bounds.width / 9
    return CGSize(width: width , height: width)
  }
}
