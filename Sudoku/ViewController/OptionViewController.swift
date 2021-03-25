//
//  OptionViewController.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/25.
//

import UIKit

class OptionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
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
        
        cell.updateUI(indexPath.item)
        
        return cell
    }
}

extension OptionViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
    
    func updateUI(_ i: Int){
        imageView.image = UIImage(systemName: optionImage[i])
        label.text = optionLabel[i]
        
        // imageView.tintColor =
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
