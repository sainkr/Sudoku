//
//  OptionViewController.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/25.
//

import UIKit

class OptionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let OptionNotification: Notification.Name = Notification.Name("OptionNotification")
    let CheckNumCountNotification: Notification.Name = Notification.Name("CheckNumCountNotification")
    let sudokuViewModel = SudokuViewModel()
    var memoSelect = false
    
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
        
        cell.updateUI(indexPath.item, sudokuViewModel.isMemoSelected)
        
        return cell
    }
}

extension OptionViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sudokuViewModel.setOption(optionNum: indexPath.item)
        if indexPath.item == 2 {
            collectionView.reloadData()
        }else if indexPath.item == 3{
            NotificationCenter.default.post(name: CheckNumCountNotification, object: nil, userInfo: nil)
        }
        
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

class OptionCell: UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    let optionImage: [String] = ["arrow.counterclockwise","trash", "highlighter", "lightbulb"]
    let optionLabel: [String] = ["실행 취소", "지우기", "메모", "힌트"]
    
    func updateUI(_ i: Int, _ memoSelect: Bool){
        imageView.image = UIImage(systemName: optionImage[i])
        if i == 2 && memoSelect{
            imageView.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
            imageView.tintColor = #colorLiteral(red: 0.9516713023, green: 0.3511439562, blue: 0.1586719155, alpha: 1)
        }
        label.text = optionLabel[i]
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
