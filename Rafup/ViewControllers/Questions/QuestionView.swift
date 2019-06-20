//
//  TextQuestionView.swift
//  Rafup
//
//  Created by Ashish on 17/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

protocol QuestionViewDelegate {
    func didTapSubmitButton(_ sender: UIButton, view: QuestionView)
}

class QuestionView: UIView {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var questionImagevw: UIImageView!
    @IBOutlet weak var tableVw: UITableView!
    
    // MARK: -  Variable Declaration.
    var questionArray = QuestionModel()
    var answerDelegate: QuestionViewDelegate?
    var isSelected = -1
    
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
    
        //Registor Nib
        tableVw.registerCellNib(TextQuestionCell.self)
        
        //Set delegate and datasource of tableVw
        tableVw.delegate = self
        tableVw.dataSource = self
        
        tableVw.reloadData()
        //startTimerForShowScrollIndicator()
        self.questionLbl.text = questionArray.question ?? ""
        
        if self.questionArray.categotyId ?? 0 == 1 {
            self.questionImagevw.isHidden = true
        } else {
            questionImagevw.setImageWithURL(url: self.questionArray.filePath ?? "", placeholder: #imageLiteral(resourceName: "background_default")) { (image, error) in
                self.questionImagevw.sizeToFit()
            }
            self.questionImagevw.isHidden = false
        }
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func didTapSumitButton(_ sender: UIButton) {
        self.answerDelegate?.didTapSubmitButton(sender, view: self)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource Methods.
extension QuestionView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: TextQuestionCell.className, for: indexPath) as! TextQuestionCell
        
        //Remove selected cell background colour.
        cell.selectionStyle = .none
        
        //===========================
        //        SetUp Cell
        //===========================
        
        cell.questionMarkImageVw.image =  #imageLiteral(resourceName: "unselected_do")
        
        if  questionArray.options.count > indexPath.row {
            let model =  questionArray.options[indexPath.row]
            cell.questionLbl.text = model
        }
        
        if isSelected == indexPath.row {
            cell.borderWidth = 1.0
            cell.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            cell.questionMarkImageVw.image =  #imageLiteral(resourceName: "circle_check")
        } else {
            cell.borderWidth = 0
        }
        if (indexPath.row == 0){
            cell.lblScrollViewIndicator.isHidden = false
        }else{
            cell.lblScrollViewIndicator.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if questionArray.options.count > indexPath.row {
            self.isSelected = indexPath.row
            self.tableVw.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableVw.estimatedRowHeight = 80
        return 58//UITableViewAutomaticDimension
    }
    
}
