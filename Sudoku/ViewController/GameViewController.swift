//
//  GameViewController.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/23.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var numberCollectionView: UICollectionView!
    
    var sudokuViewController: SudokuViewController!
    var optionViewController: OptionViewController!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sudoku"{
            let destinationVC = segue.destination as? SudokuViewController
            sudokuViewController = destinationVC
        } else if segue.identifier == "option"{
            let destinationVC = segue.destination as? OptionViewController
            optionViewController = destinationVC
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension GameViewController {
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = numberCollectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as? NumberCell else { return UICollectionViewCell() }
        cell.updateUI(indexPath.item + 1)
        
        return cell
    }
}

extension GameViewController: UICollectionViewDelegate{
    
}

extension GameViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 10
        let width: CGFloat = (collectionView.bounds.width - margin) / 9
        
        return CGSize(width: width, height: width)
    }
}

class NumberCell: UICollectionViewCell{
    @IBOutlet weak var numberButton: UIButton!
    
    func updateUI(_ num: Int){
        numberButton.setTitle(String(num), for: .normal)
    }
}
