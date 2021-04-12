//
//  MainViewController.swift
//  Sudoku
//
//  Created by 홍승아 on 2021/03/22.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var todayGameButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var beforeMonthButton: UIButton!
    
    var todayViewModel = TodayViewModel()
    var myGameViewModel = MyGameViewModel()
    var sudokuViewModel = PBSudokuViewModel()
    var todayGameViewModel = TodayGameViewModel()
    var rankViewModel = RankViewModel()
    var profileViewModel = ProfileViewModel()
    
    var currentYear: Int = 0
    var currentMonth: Int = 0
    var currentDay: Int = 0
    var currentCalendarDay: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCurrentCalendar(todayViewModel.yearOfToday, todayViewModel.monthOfToday)
       
        // 클리어 ----> 
        // myGameViewModel.clearMyGame()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        myGameViewModel = MyGameViewModel()
        todayGameViewModel = TodayGameViewModel()

        loadGame()
        
        collectionView.reloadData()
    }
}

extension MainViewController{
    func setView(){
        // 오늘 날짜 설정
        todayDateLabel.text = todayViewModel.getDate()
        
        // 뷰 둥글게
        calendarView.layer.cornerRadius = 17
        
        // 버튼 둥글게
        todayGameButton.layer.cornerRadius = 17
        continueButton.layer.cornerRadius = 17
        newGameButton.layer.cornerRadius = 17
    }
    
    func setCurrentCalendar(_ year : Int, _ month: Int){
        
        if month == 0 {
            currentYear = year - 1
            currentMonth = 12
        } else if month == 13 {
            currentYear = year + 1
            currentMonth = 1
        }
        else {
            currentYear = year
            currentMonth = month
        }
        
        // 이번년도만
        if year == todayViewModel.yearOfToday && month == todayViewModel.monthOfToday{
            nextMonthButton.isHidden = true
            currentDay = todayViewModel.dayOfToday
        }else {
            nextMonthButton.isHidden = false
            currentDay = 32
        }
        
        if month == 1{
            beforeMonthButton.isHidden = true
        }else{
            beforeMonthButton.isHidden = false
        }
        
        currentCalendarDay = todayViewModel.getCalendar(currentYear, currentMonth)
        
        monthLabel.text = "\(currentMonth)월"
        collectionView.reloadData()
    }
    
    func todayGame(){
        let gameStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
        guard let gameVC = gameStoryboard.instantiateViewController(identifier: "GameViewController") as? GameViewController else { return }
        gameVC.modalPresentationStyle = .fullScreen
        gameVC.gameType = 1
        self.present(gameVC, animated: true, completion: nil)
    }
    
    func continueGame(){
        sudokuViewModel.setSudoku(myGameViewModel.myGame)
        let gameStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
        guard let gameVC = gameStoryboard.instantiateViewController(identifier: "GameViewController") as? GameViewController else { return }
        gameVC.modalPresentationStyle = .fullScreen
        self.present(gameVC, animated: true, completion: nil)
    }
    
    func newGame(){
        let gameStoryboard = UIStoryboard.init(name: "Game", bundle: nil)
        guard let gameVC = gameStoryboard.instantiateViewController(identifier: "GameViewController") as? GameViewController else { return }
        gameVC.modalPresentationStyle = .fullScreen
        
        let actionsheetConroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let easy = UIAlertAction(title: "쉬움", style: .default) { action in
            self.sudokuViewModel.setLevel(level: 0)
            self.present(gameVC, animated: true, completion: nil)
        }
        let medium = UIAlertAction(title: "보통", style: .default) { action in
            self.sudokuViewModel.setLevel(level: 1)
            self.present(gameVC, animated: true, completion: nil)
        }
        let hard = UIAlertAction(title: "어려움", style: .default) { action in
            self.sudokuViewModel.setLevel(level: 2)
            self.present(gameVC, animated: true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionsheetConroller.addAction(easy)
        actionsheetConroller.addAction(medium)
        actionsheetConroller.addAction(hard)
        actionsheetConroller.addAction(actionCancel)
        
        present(actionsheetConroller, animated: true)
    }
    
    func loadGame(){
        myGameViewModel.loadMyGame()
        todayGameViewModel.loadTodayGame()
        rankViewModel.loadData()
        profileViewModel.loadProfile()
    }
    
    func presentRank(){
        let rankStoryboard = UIStoryboard.init(name: "Rank", bundle: nil)
        guard let rankVC = rankStoryboard.instantiateViewController(identifier: "RankViewConroller") as? RankViewController else { return }
        rankVC.modalPresentationStyle = .fullScreen
        self.present(rankVC, animated: true, completion: nil)
    }
    
    func setAlert(_ msg: String){
        let nameAlert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let nameOK = UIAlertAction(title: "확인", style: .default ){ (ok) in
            self.dismiss(animated: true, completion: nil)
        }
        nameAlert.addAction(nameOK)
        self.present(nameAlert, animated: true, completion: nil)
    }
}
extension MainViewController {
    // 저번달 버튼
    @IBAction func backCalendarButtonTapped(_ sender: Any) {
        setCurrentCalendar(currentYear, currentMonth - 1)
    }
    
    // 다음달 버튼
    @IBAction func nextCalendarButtonTapped(_ sender: Any) {
        setCurrentCalendar(currentYear, currentMonth + 1)
    }
    
    // 오늘의 게임 버튼
    @IBAction func todayGameButtonTapped(_ sender: Any) {
        let todayDate = "\(todayViewModel.yearOfToday)\(todayViewModel.monthOfToday)\(todayViewModel.dayOfToday)"
        if todayGameViewModel.todayGame.today == todayDate {
            if todayGameViewModel.todayGame.numCount.count > 0 && todayGameViewModel.todayGame.numCount[0] > 0 {
                sudokuViewModel.setSudoku(MyGame(level: todayGameViewModel.todayGame.level, game_sudoku: todayGameViewModel.todayGame.game_sudoku, original_sudoku: todayGameViewModel.todayGame.original_sudoku, time: todayGameViewModel.todayGame.time , memoArr: todayGameViewModel.todayGame.memoArr, numCount: todayGameViewModel.todayGame.numCount))
                todayGame()
            }
        }else {
            todayGameViewModel.setToday(todayViewModel.yearOfToday, todayViewModel.monthOfToday, todayViewModel.dayOfToday )
            self.sudokuViewModel.setLevel(level: Int(arc4random_uniform(3)))
            todayGame()
        }
    }
    
    // 이어하기 버튼
    @IBAction func continueButtonTapped(_ sender: Any) {
        print("---> \(myGameViewModel.myGame)")
        if myGameViewModel.myGame.numCount.count > 0 && myGameViewModel.myGame.numCount[0] > 0 {
            continueGame()
        } else {
            newGame()
        }
    }
    
    // 새 게임 버튼
    @IBAction func newGameButtonTapped(_ sender: Any) {
        newGame()
    }
    
    // 랭킹 버튼
    @IBAction func rankingButtonTapped(_ sender: Any) {
        if profileViewModel.profile.name == "-"{ // 닉네임이 등록되어있지 않으면
            let alert = UIAlertController(title: nil, message: "랭킹을 확인하려면 닉네임을 입력하세요.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default){ (ok) in
                if let name = alert.textFields?[0].text {
                    if name != ""{
                        if self.rankViewModel.rank[name] == nil{ // 닉네임 중복 여부 체크
                            self.profileViewModel.saveProfile(Profile(name: name))
                            let clearCnt = self.todayGameViewModel.todayGame.todayGameCalendar[self.todayViewModel.monthOfToday - 1].count
                            let todayDate = "\(self.todayViewModel.yearOfToday)\(self.todayViewModel.monthOfToday)"
                            if clearCnt > 0 {
                                self.rankViewModel.addRank(alert.textFields?[0].text ?? "-", clearCnt, todayDate)
                            }
                            self.dismiss(animated: true, completion: nil)
                            self.presentRank()
                        }else{ // 존재하면
                            self.setAlert("이미 존재하는 닉네임입니다. 다시 입력해주세요.")
                        }
                    }
                    else{ // 그냥 빈칸이면 !!
                        self.setAlert("닉네임을 입력해주세요.")
                    }
                }
            }
            
            let cancle = UIAlertAction(title: "취소", style: .cancel){ (cancle) in
                self.dismiss(animated: true, completion: nil)
            }

            alert.addAction(cancle)
            alert.addAction(ok)
            alert.addTextField()

            present(alert, animated: true, completion: nil)
        } else{
            presentRank()
        }
        rankViewModel.loadData()
    }
    
    // 환경설정 버튼
    @IBAction func setupButtonTapped(_ sender: Any) {
        
    }
}

extension MainViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCalendarDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else { return UICollectionViewCell() }
        
        var success = false
        if todayGameViewModel.todayGame.todayGameCalendar[currentMonth-1].contains(currentCalendarDay[indexPath.item]) {
            success = true
        }else{
            success = false
        }
        cell.updateUI(currentCalendarDay[indexPath.item], currentDay, success)
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (collectionView.bounds.width - 30) / 7
        
        return CGSize(width: width, height: width)
    }
}

class CalendarCell: UICollectionViewCell{
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    func updateUI(_ day: Int, _ currentDay: Int, _ success: Bool){
        if day > 0 {
            dayLabel.text = "\(day)"
        }else {
            dayLabel.text = " "
        }
        
        if day <= currentDay {
            dayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else {
            dayLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
        if success{
            updateBackground()
        }else {
            view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    // 배경색 업데이트
    func updateBackground(){
        view.backgroundColor = #colorLiteral(red: 0.9516713023, green: 0.3511439562, blue: 0.1586719155, alpha: 1)
        view.layer.cornerRadius = 20
    }
}
