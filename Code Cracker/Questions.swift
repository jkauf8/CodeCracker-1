//
//  Questions.swift
//  Code Cracker
//
//  Created by Justin Zhang on 6/27/20.
//  Copyright © 2020 Justin Zhang Justin Kaufman. All rights reserved.
//


import UIKit

struct Question {
    let imgName: String
    let questionText: String
    let options: [String]
    let correctAns: Int
    var wrongAns: Int
    var isAnswered: Bool
}

class QuizVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var myCollectionView: UICollectionView!
    var questionsArray = [Question]()
    var score: Int = 0
    var currentQuestionNumber = 1
    var start = 0;
    var window: UIWindow?
    var category: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Home"
        self.view.backgroundColor=UIColor.darkGray //change
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        myCollectionView=UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(QuizCVCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.darkGray //change
        myCollectionView.isPagingEnabled = true
        
        self.view.addSubview(myCollectionView)
        
        let jv1 = Question(imgName: "img1", questionText: "What is java1 ?", options: ["2", "4", "8", "6"], correctAns: 1, wrongAns: -1, isAnswered: false)
        let jv2 = Question(imgName: "img2", questionText: "What is java2 ?", options: ["9", "4", "3", "6"], correctAns: 3, wrongAns: -1, isAnswered: false)
        let jv3 = Question(imgName: "img1", questionText: "What is java3 ?", options: ["2", "4", "3", "5"], correctAns: 2, wrongAns: -1, isAnswered: false)
        let jv4 = Question(imgName: "img2", questionText: "What is 2 - 2 ?", options: ["2", "4", "1", "0"], correctAns: 3, wrongAns: -1, isAnswered: false)
        let jv5 = Question(imgName: "img1", questionText: "What is 12 x 2 ?", options: ["24", "40", "26", "34"], correctAns: 0, wrongAns: -1, isAnswered: false)
        let jv6 = Question(imgName: "img2", questionText: "What is the color of sky?", options: ["Violet", "Yellow", "Blue", "White"], correctAns: 2, wrongAns: -1, isAnswered: false)
        let py1 = Question(imgName: "img1", questionText: "What is python1?", options: ["2", "4", "8", "6"], correctAns: 1, wrongAns: -1, isAnswered: false)
        let py2 = Question(imgName: "img2", questionText: "What is python2 ?", options: ["9", "4", "3", "6"], correctAns: 3, wrongAns: -1, isAnswered: false)
        let py3 = Question(imgName: "img1", questionText: "What is asdf3?", options: ["2", "4", "3", "5"], correctAns: 2, wrongAns: -1, isAnswered: false)
        let py4 = Question(imgName: "img2", questionText: "What is 2 - 2asdf ?", options: ["2", "4", "1", "0"], correctAns: 3, wrongAns: -1, isAnswered: false)
        let py5 = Question(imgName: "img1", questionText: "What is 12 x f2 ?", options: ["24", "40", "26", "34"], correctAns: 0, wrongAns: -1, isAnswered: false)
        let py6 = Question(imgName: "img2", questionText: "What is the color of sky?", options: ["Violet", "Yellow", "Blue", "White"], correctAns: 2, wrongAns: -1, isAnswered: false)
        if category == "Python" {
            questionsArray = [py1, py2, py3, py4, py5, py6]
        }
        else if category == "Java" {
            questionsArray = [jv1, jv2, jv3, jv4, jv5, jv6]
        }
        questionsArray = Array(questionsArray[start...])
        setupViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! QuizCVCell
        cell.question=questionsArray[indexPath.row]
        cell.delegate=self
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setQuestionNumber()
    }
    
    func setCategory(cat:String) {
        category = cat
    }
    
    func setQuestionStart(questionNum:Int) {
        start = questionNum
    }
    
    func setQuestionNumber() {
        let x = myCollectionView.contentOffset.x
        let w = myCollectionView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        if currentPage < questionsArray.count {
            lblQueNumber.text = "Question: \(currentPage+1) / \(questionsArray.count)"
            currentQuestionNumber = currentPage + 1
        }
    }
    
   @objc func btnNextAction() {
        if currentQuestionNumber == questionsArray.count {
            let v=ResultVC()
            v.score = score
            v.totalScore = questionsArray.count
            self.navigationController?.pushViewController(v, animated: false)
            return
        }
        
        let collectionBounds = self.myCollectionView.bounds
        var contentOffset: CGFloat = 0
        contentOffset = CGFloat(floor(self.myCollectionView.contentOffset.x + collectionBounds.size.width))
        currentQuestionNumber += currentQuestionNumber >= questionsArray.count + start ? 0 : 1
        self.moveToFrame(contentOffset: contentOffset)
        
    }
    
    func moveToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.myCollectionView.contentOffset.y ,width : self.myCollectionView.frame.width,height : self.myCollectionView.frame.height)
        self.myCollectionView.scrollRectToVisible(frame, animated: true)
    }
    
    func setupViews() {
        myCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive=true
        
        self.view.addSubview(btnNext)
        btnNext.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnNext.widthAnchor.constraint(equalTo: self.view.widthAnchor,multiplier:0.5).isActive=true
        btnNext.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive=true
        btnNext.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive=true
        
    
    }
    
    let btnNext: UIButton = {
        let btn=UIButton()
        btn.setTitle("Next >", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.purple
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnNextAction), for: .touchUpInside)
        return btn
    }()
    
    let lblQueNumber: UILabel = {
        let lbl=UILabel()
        lbl.text="0 / 0"
        lbl.textColor=UIColor.green
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblScore: UILabel = {
        let lbl=UILabel()
        lbl.text="0 / 0"
        lbl.textColor=UIColor.gray
        lbl.textAlignment = .right
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
}

extension QuizVC: QuizCVCellDelegate {
    func didChooseAnswer(btnIndex: Int) {
        let centerIndex = getCenterIndex()
        guard let index = centerIndex else { return }
        questionsArray[index.item].isAnswered=true
        if questionsArray[index.item].correctAns != btnIndex {
            questionsArray[index.item].wrongAns = btnIndex
            score -= 1
        } else {
            score += 1
        }
        lblScore.text = "Score: \(score) / \(questionsArray.count)"
        myCollectionView.reloadItems(at: [index])
    }
    
    func getCenterIndex() -> IndexPath? {
        let center = self.view.convert(self.myCollectionView.center, to: self.myCollectionView)
        let index = myCollectionView!.indexPathForItem(at: center)
        print(index ?? "index not found")
        return index
    }
}















