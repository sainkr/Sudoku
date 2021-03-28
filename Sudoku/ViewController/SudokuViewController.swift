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
    
    var isSelected: [Bool] = [false,false,false,false,false,false,false,false,false,
                              false,false,false,false,false,false,false,false,false,
                              false,false,false,false,false,false,false,false,false,
                              false,false,false,false,false,false,false,false,false,
                              false,false,false,false,false,false,false,false,false,
                              false,false,false,false,false,false,false,false,false,
                              false,false,false,false,false,false,false,false,false,
                              false,false,false,false,false,false,false,false,false,
                              false,false,false,false,false,false,false,false,false,]
                               
    var first: Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sudokuViewModel.setLevel(level: 1)
        // print(sudokuViewModel.game_sudoku)
    }
}

extension SudokuViewController{
    func resetisSelected(){
        for i in 0..<81{
            isSelected[i] = false
        }
    }
    
    func setisSelected(_ index: Int){
        resetisSelected()
        
        let start_x = (index / 9) * 9
        let end_x = start_x + 8
        var y = index % 9
        
        for i in start_x...end_x{
            isSelected[i] = true
        }
        
        while y < 81 {
            isSelected[y] = true
            y += 9
        }
        
        first = false
        collectionView.reloadData()
        // print(sudokuViewModel.game_sudoku)
    }
}

extension SudokuViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath) as? SudokuCell else { return UICollectionViewCell() }
        
        if first {
            cell.updateFirstUI(indexPath.item, sudokuViewModel.game_sudoku[indexPath.item / 9][indexPath.item % 9])
        } else {
            cell.updateUI(indexPath.item, sudokuViewModel.game_sudoku[indexPath.item / 9][indexPath.item % 9], isSelected[indexPath.item])
        }
        print(indexPath.item)
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
    
    func updateFirstUI(_ i : Int, _ sudokuNum: Int){
        if sudokuNum > 0 {
            numLabel.text = String(sudokuNum)
        }
        setEdge(i)
    }
    
    func updateUI(_ i : Int,_ sudokuNum: Int, _ isSelect: Bool){
        print(sudokuNum)
        view.layer.sublayers = nil
        if sudokuNum > 0 {
            numLabel.text = String(sudokuNum)
        }
        setEdge(i)
    }
    
    func setSelect(_ isSelect: Bool){
        if isSelect{
            view.backgroundColor = #colorLiteral(red: 0.9516713023, green: 0.3511439562, blue: 0.1586719155, alpha: 0.4391209609)
        }else {
            view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
        
        view.layer.addBorder(edgeArr)
    }
    
    func setMemoLabel(){
        memoLabels = [memoLabel1, memoLabel2,memoLabel3, memoLabel4, memoLabel5, memoLabel6, memoLabel7, memoLabel8, memoLabel9]
    }
}

extension CALayer {
    func addBorder(_ arr_edge: [Int]) {
        
        let boldWidth: CGFloat = 2 // 테두리 두께 2
        let basicWidth: CGFloat = 1 // 테두리 두께 1
        
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


