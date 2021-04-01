//
//  SudokuViewController.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/25.
//

import UIKit

class SudokuViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sudokuViewModel = PBSudokuViewModel()
    var myGameViewModel = MyGameViewModel()
    
    let ClickNumberNotification: Notification.Name = Notification.Name("ClickNumberNotification")
    let OptionNotification: Notification.Name = Notification.Name("OptionNotification")
    let CheckNumCountNotification: Notification.Name = Notification.Name("CheckNumCountNotification")
    
    var isMemoSelected = false
    var memoNum = -1
    
    var clickIndex: [Int] = [-1, -1, -1, -1]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clickNumberNotification(_:)), name: ClickNumberNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.optionNotification(_:)), name: OptionNotification, object: nil)
        
    }
}

extension SudokuViewController{
    func setisSelected(_ index: Int){
        sudokuViewModel.resetisSelected()
        
        clickIndex[0] = index / 9
        clickIndex[1] = index % 9
        clickIndex[2] = index
        clickIndex[3] = sudokuViewModel.game_sudoku[clickIndex[0]][clickIndex[1]]
        
        let start_x = (index / 9) * 9
        let end_x = start_x + 8
        var y = index % 9
        
        // isSeleted = 1 : 행, 열, 사각형
        // 사각형
        var rectX = index / 9
        var rectY = y
        if rectX > 5 {
            rectX = 6
        }else if rectX > 2 {
            rectX = 3
        } else{
            rectX = 0
        }
        
        if rectY > 5 {
            rectY = 6
        }else if rectY > 2 {
            rectY = 3
        } else{
            rectY = 0
        }

        for i in rectX...(rectX+2){
            for j in 0..<3{
                sudokuViewModel.setisSelcted(9 * i + rectY + j, 1)
            }
        }
        
        // 행
        for i in start_x...end_x{
            sudokuViewModel.setisSelcted(i, 1)
        }
        
        // 열
        while y < 81 {
            sudokuViewModel.setisSelcted(y, 1)
            y += 9
        }
        
        // isSeleted = 2 : 같은 숫자
        for i in 0...8{
            for j in 0...8{
                if clickIndex[3] != 0 && clickIndex[3] == sudokuViewModel.game_sudoku[i][j]{
                    sudokuViewModel.setisSelcted(i * 9 + j, 2)
                }
            }
        }
        
        // isSelected = 3 : 현재 선택된 숫자
        sudokuViewModel.setisSelcted(index, 3)
        
        collectionView.reloadData()
    }
    
    // 숫자 클릭했을 때 notifi
    @objc func clickNumberNotification(_ noti: Notification){
        guard let num = noti.userInfo?["num"] as? Int else { return }
        
        if isMemoSelected{
            if sudokuViewModel.game_sudoku[clickIndex[0]][clickIndex[1]] != sudokuViewModel.original_sudoku[clickIndex[0]][clickIndex[1]]{
                if sudokuViewModel.game_sudoku[clickIndex[0]][clickIndex[1]] == 0 {
                    sudokuViewModel.setMemoArr(clickIndex[2], num - 1, 1)
                    memoNum = num - 1
                }
            }
        } else {
            if clickIndex[0] != -1 && clickIndex[1] != -1 {
                if sudokuViewModel.game_sudoku[clickIndex[0]][clickIndex[1]] != sudokuViewModel.original_sudoku[clickIndex[0]][clickIndex[1]]{
                    sudokuViewModel.setMemoArr(clickIndex[2], [0,0,0,0,0,0,0,0,0]) // 일단 메모 다 지우기
                    sudokuViewModel.setGameSudoku(num, clickIndex[0], clickIndex[1])
                    
                    if num == sudokuViewModel.original_sudoku[clickIndex[0]][clickIndex[1]]{
                        sudokuViewModel.setNumCount()
                        if sudokuViewModel.numCount[num] == 9 {
                            NotificationCenter.default.post(name: CheckNumCountNotification, object: nil, userInfo: nil)
                        }
                    }
                    
                    setisSelected(clickIndex[2])
                }
            }
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // 옵션 클릭했을 때 notifi
    @objc func optionNotification(_ noti: Notification){
        guard let optionNum = noti.userInfo?["optionNum"] as? Int else { return }
        
        if clickIndex[0] != -1 && clickIndex[1] != -1 {
            if optionNum == 0 { // 실행 취소
                if memoNum > 0 {
                    sudokuViewModel.setMemoArr(clickIndex[2], memoNum, 0)
                }
            
                if sudokuViewModel.game_sudoku[clickIndex[0]][clickIndex[1]] != sudokuViewModel.original_sudoku[clickIndex[0]][clickIndex[1]]{
                    if sudokuViewModel.game_sudoku[clickIndex[0]][clickIndex[1]] != 0 {
                        sudokuViewModel.setGameSudoku(0, clickIndex[0], clickIndex[1])
                    }
                }
            } else if optionNum == 1{ // 지우기
                if !isMemoSelected{
                    if sudokuViewModel.game_sudoku[clickIndex[0]][clickIndex[1]] != sudokuViewModel.original_sudoku[clickIndex[0]][clickIndex[1]]{
                        if sudokuViewModel.game_sudoku[clickIndex[0]][clickIndex[1]] != 0 {
                            sudokuViewModel.setGameSudoku(0, clickIndex[0], clickIndex[1])
                        }
                    }
                }
                sudokuViewModel.setMemoArr(clickIndex[2], [0,0,0,0,0,0,0,0,0])
            } else if optionNum == 2 { // 메모
                if isMemoSelected{
                    isMemoSelected = false
                } else {
                    isMemoSelected = true
                }
                print(isMemoSelected)
            } else { // 힌트
                if sudokuViewModel.game_sudoku[clickIndex[0]][clickIndex[1]] != sudokuViewModel.original_sudoku[clickIndex[0]][clickIndex[1]]{
                    sudokuViewModel.setGameSudoku(sudokuViewModel.original_sudoku[clickIndex[0]][clickIndex[1]], clickIndex[0], clickIndex[1])
                    sudokuViewModel.setNumCount()
                    
                    if sudokuViewModel.numCount[sudokuViewModel.original_sudoku[clickIndex[0]][clickIndex[1]]] == 9 {
                        NotificationCenter.default.post(name: CheckNumCountNotification, object: nil, userInfo: nil)
                    }
                    
                    setisSelected(clickIndex[2])
                }
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension SudokuViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath) as? SudokuCell else { return UICollectionViewCell() }
        
        
        cell.updateMemoUI(sudokuViewModel.memoArr[indexPath.item])
    
        // i : setEdge , sudokuNum : 숫자, isSeleted: 행, 열, 사각형 isCorrect : 오답, checkIndex : 현재 위치 색, 같은 숫자 색
        let i = indexPath.item
        let gameSudokuNum = sudokuViewModel.game_sudoku[indexPath.item / 9][indexPath.item % 9]
        let originSudokuNum = sudokuViewModel.original_sudoku[indexPath.item / 9][indexPath.item % 9]
        let isSelected = sudokuViewModel.isSeleted[indexPath.item]
        let isCorrect =  gameSudokuNum != originSudokuNum && gameSudokuNum != 0 ? false : true

        cell.updateUI( i, gameSudokuNum , isSelected , isCorrect)
        
        
        return cell
    }
}

extension SudokuViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setisSelected(indexPath.item)
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
    
    var memoLabels: [UILabel] = []
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    func updateMemoUI(_ memoSelect: [Int]){
        setMemoLabel()
        
        for i in 0...8{
            if memoSelect[i] == 1 {
                memoLabels[i].isHidden = false
            }else {
                memoLabels[i].isHidden = true
            }
        }
    }
    
    func updateUI(_ i : Int,_ sudokuNum: Int, _ isSelect: Int, _ isCorrect: Bool){
        if sudokuNum == 0 {
            numLabel.text = ""
        } else {
            numLabel.text = String(sudokuNum)
        }
        setEdge(i)
        setTextColor(isCorrect)
        setBackGroundColor(isSelect)
    }
    
    func setTextColor(_ isCorrect: Bool){
        if isCorrect{
            numLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else{
            numLabel.textColor = UIColor.red
        }
    }
    
    func setBackGroundColor(_ isSelect: Int){
        if isSelect == 0{
            view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else if isSelect == 1{ // 선택된 행, 열, 사각형
            view.backgroundColor = #colorLiteral(red: 1, green: 0.4607823897, blue: 0.08191460459, alpha: 0.4498033588)
        } else if isSelect == 2{ // 선택된 숫자와 같은 숫자
            view.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 0.5745907738)
        } else{ // 현재 선택된 숫자
            view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.3357780612)
        }
    }
    
    func setEdge(_ i: Int){
        // 행 비교
        var edgeArr: [Int] = [0,0,0,0]
        // top bottom left right 순
        if (i / 9 % 3) == 0 {
            if i % 3 == 0 { // 위, 왼
                edgeArr = [1,0,1,0]
            } else if i % 3 == 1 { // 위
                edgeArr = [1,0,0,0]
            } else{ // 위, 오
                edgeArr = [1,0,0,1]
            }
        } else if (i / 9 % 3) == 1 {
            if i % 3 == 0 { // 왼
                edgeArr = [0,0,1,0]
            } else if i % 3 == 2 { // 오
                edgeArr = [0,0,0,1]
            }
        } else{
            if i % 3 == 0 { // 왼, 아
                edgeArr = [0,1,1,0]
            } else if i % 3 == 1 { // 아
                edgeArr = [0,1,0,0]
            } else{ // 아, 오
                edgeArr = [0,1,0,1]
            }
        }
        if view.layer.sublayers?.count == 18 {
            for _ in 1...8{
                view.layer.sublayers?.removeLast()
            }
        }
        view.layer.addBorder(edgeArr,1,0.5)
    }
    
    func setMemoLabel(){
        memoLabels = [memoLabel1, memoLabel2, memoLabel3, memoLabel4, memoLabel5, memoLabel6, memoLabel7, memoLabel8, memoLabel9]
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
        
        let boldCgRect: [CGRect] = [CGRect.init(x: 0, y: 0, width: frame.width, height: boldWidth), CGRect.init(x: 0, y: frame.height - boldWidth, width: frame.width, height: boldWidth), CGRect.init(x: 0, y: 0, width: boldWidth, height: frame.height), CGRect.init(x: frame.width - boldWidth, y: 0, width: boldWidth, height: frame.height)]
        let basicCgRect: [CGRect] = [CGRect.init(x: 0, y: 0, width: frame.width, height: basicWidth), CGRect.init(x: 0, y: frame.height - basicWidth, width: frame.width, height: basicWidth), CGRect.init(x: 0, y: 0, width: basicWidth, height: frame.height), CGRect.init(x: frame.width - basicWidth, y: 0, width: basicWidth, height: frame.height)]
        
        for j in 0...3 {
            let border = CALayer()
            if arr_edge[j] == 0 {
                border.frame = basicCgRect[j]
                border.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
            self.addSublayer(border)
        }
        for j in 0...3 {
            let border = CALayer()
            if arr_edge[j] == 1 {
                border.frame = boldCgRect[j]
                border.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            self.addSublayer(border)
        }
    }
}


