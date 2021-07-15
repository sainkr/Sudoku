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
  
  weak var delegate: CheckNumCountDelegate?
  
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

extension SudokuViewController{
  // 숫자 클릭했을 때 notifi
  @objc func clickNumberNotification(_ noti: Notification){
    guard let num = noti.userInfo?["num"] as? Int else { return }
    sudokuViewModel.setNum(num: num)
    DispatchQueue.main.async {
      self.collectionView.reloadData()
      self.collectionView.reloadData()
    }
    
    if !sudokuViewModel.isMemoOptionSelected{
      delegate?.checkNumCount()
    }
  }
  // 옵션 클릭했을 때 notifi
  @objc func optionNotification(_ noti: Notification){
    DispatchQueue.main.async {
      self.collectionView.reloadData()
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

class SudokuCell: UICollectionViewCell{
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
    
    setEdge(index)
    setTextColor(isCorrect)
    setBackGroundColor(cellType)
  }
  
  func setTextColor(_ isCorrect: Bool){
    if isCorrect{
      numLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }else{
      numLabel.textColor = UIColor.red
    }
  }
  
  func setBackGroundColor(_ type: ClickedCellType){
    if type == .none{
      contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }else if type == .col || type == .row || type == .rectangle || type == .sameNum{
      contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4607823897, blue: 0.08191460459, alpha: 0.4498033588)
    }else{ 
      contentView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.3357780612)
    }
  }
  
  func setEdge(_ i: Int){
    // 행 비교
    var edgeArr: [Int] = [0,0,0,0]
    
    if (i / 9 % 3) == 0 {
      if i % 3 == 0 { // 위, 왼 굵은선
        edgeArr = [1,0,1,0]
      } else if i % 3 == 1 { // 위 굵은선
        edgeArr = [1,0,0,0]
      } else{ // 위, 오 굵은선
        edgeArr = [1,0,0,1]
      }
    } else if (i / 9 % 3) == 1 {
      if i % 3 == 0 { // 왼 굵은선
        edgeArr = [0,0,1,0]
      } else if i % 3 == 2 { // 오 굵은선
        edgeArr = [0,0,0,1]
      }
    } else{
      if i % 3 == 0 { // 왼, 아 굵은선
        edgeArr = [0,1,1,0]
      } else if i % 3 == 1 { // 아 굵은선
        edgeArr = [0,1,0,0]
      } else{ // 아, 오 굵은선
        edgeArr = [0,1,0,1]
      }
    }
    
    contentView.layer.addBorder(edgeArr,1,0.5)
  }
}

extension CALayer {
  func addBorder(_ arr_edge: [Int], _ boldWidth : CGFloat, _ basicWidth: CGFloat) {
    let boldWidth: CGFloat = boldWidth // 테두리 두께
    let basicWidth: CGFloat = basicWidth // 테두리 두께
    
    // .top : CGRect.init(x: 0, y: 0, width: frame.width, height: boldWidth)
    // .bottom : CGRect.init(x: 0, y: frame.height - boldWidth, width: frame.width, height: boldWidth)
    // .left : CGRect.init(x: 0, y: 0, width: boldWidth, height: frame.height)
    // .right : CGRect.init(x: frame.width - boldWidth, y: 0, width: boldWidth, height: frame.height)
    
    // 굵은 선
    let boldCgRect: [CGRect] = [CGRect.init(x: 0, y: 0, width: frame.width, height: boldWidth), CGRect.init(x: 0, y: frame.height - boldWidth, width: frame.width, height: boldWidth), CGRect.init(x: 0, y: 0, width: boldWidth, height: frame.height), CGRect.init(x: frame.width - boldWidth, y: 0, width: boldWidth, height: frame.height)]
    // 회색 선
    let basicCgRect: [CGRect] = [CGRect.init(x: 0, y: 0, width: frame.width, height: basicWidth), CGRect.init(x: 0, y: frame.height - basicWidth, width: frame.width, height: basicWidth), CGRect.init(x: 0, y: 0, width: basicWidth, height: frame.height), CGRect.init(x: frame.width - basicWidth, y: 0, width: basicWidth, height: frame.height)]
    
    for j in 0...3 {
      let border = CALayer()
      if arr_edge[j] == 0 {
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


