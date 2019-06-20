//
//  QuestionsViewController.swift
//  Rafup
//
//  Created by Ashish on 17/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var questionNumberLbl: UILabel!
    @IBOutlet weak var questionsBackgroundVw: UIView!
    
    // MARK: -  Variable Declaration.
    var questionsViewArray = [QuestionView]()
    var questionsArray     = [QuestionModel]()
    var answersArray       = [[String:String]]()
    var productId =  0
    var ticketId =  0
    var cardIsHiding = false
    var currentQuestionNumber =  1
    
    /// Scale and alpha of successive cards visible to the user
    let cardAttributes: [(downscale: CGFloat, alpha: CGFloat)] = [(1, 1), (0.92, 0.8), (0.84, 0.6), (0.76, 0.4)]
    let cardInteritemSpacing: CGFloat = 20
    
    /// UIKit dynamics variables that we need references to.
    var dynamicAnimator: UIDynamicAnimator!
    var cardAttachmentBehavior: UIAttachmentBehavior!
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupInitailView()
    }
   

    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        //Setup Navigation bar.
        self.setNavigation(title: "Quiz")
        self.navigationController?.removeBackButtonTitle()
        
        self.apiCallForQuestions()
        DispatchQueue.main.async {
            self.view.setGradient(colours: [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) , #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
        }
    }
    
    // MARK: - Setup Questions Cards Method.
    func setUpQuestionsView() {
        
       self.questionNumberLbl.text = "\(self.currentQuestionNumber)/\(self.questionsArray.count)"
        
        DispatchQueue.main.async {
            var index = 0
            for question in self.questionsArray {
                let questionVw =  QuestionView.loadNib()
                questionVw.frame = CGRect(x: 0, y: 0, width: self.questionsBackgroundVw.width, height: self.questionsBackgroundVw.height * 0.8)
                questionVw.answerDelegate = self
                questionVw.questionArray = question
                questionVw.setupInitailView()
                
                self.questionsViewArray.append(questionVw)
                index = index + 1
            }
            
            // 2. layout the first 4 cards for the user
            self.layoutCards()
        }
    }
    
    // MARK: -  Set up the frames, alphas, and transforms of the first 4 cards on the screen
    func layoutCards() {
        // frontmost card (first card of the deck)
        
        if let firstCard = questionsViewArray.first {
            self.view.addSubview(firstCard)
            firstCard.layer.zPosition = CGFloat(self.questionsViewArray.count)
            firstCard.center = self.view.center
            
            // the next 3 cards in the deck
            for i in 1...3 {
                if i > (self.questionsViewArray.count - 1) { continue }
                
                let card = self.questionsViewArray[i]
                
                card.layer.zPosition = CGFloat(self.questionsViewArray.count - i)
                
                // here we're just getting some hand-picked vales from cardAttributes (an array of tuples)
                // which will tell us the attributes of each card in the 4 cards visible to the user
                let downscale = cardAttributes[i].downscale
                let alpha = cardAttributes[i].alpha
                card.transform = CGAffineTransform(scaleX: downscale, y: downscale)
                card.alpha = alpha
                
                // position each card so there's a set space (cardInteritemSpacing) between each card, to give it a fanned out look
                card.center.x = self.view.center.x
                card.frame.origin.y = self.questionsViewArray[0].frame.origin.y - (CGFloat(i) * cardInteritemSpacing)
                // workaround: scale causes heights to skew so compensate for it with some tweaking
                if i == 3 {
                    card.frame.origin.y += 1.5
                }
                
                self.view.addSubview(card)
            }
            
            // make sure that the first card in the deck is at the front
            self.view.bringSubview(toFront: firstCard)
        }
    }
    
    /// This is called whenever the front card is swiped off the screen or is animating away from its initial position.
    /// showNextCard() just adds the next card to the 4 visible cards and animates each card to move forward.
    func showNextCard() {
        let animationDuration: TimeInterval = 0.2
        // 1. animate each card to move forward one by one
        for i in 1...3 {
            if i > (self.questionsViewArray.count - 1) { continue }
            let card = self.questionsViewArray[i]
            let newDownscale = cardAttributes[i - 1].downscale
            let newAlpha = cardAttributes[i - 1].alpha
            UIView.animate(withDuration: animationDuration, delay: (TimeInterval(i - 1) * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                card.transform = CGAffineTransform(scaleX: newDownscale, y: newDownscale)
                card.alpha = newAlpha
                if i == 1 {
                    card.center = self.questionsBackgroundVw.center
                } else {
                    card.center.x = self.questionsBackgroundVw.center.x
                    card.frame.origin.y = self.questionsViewArray[1].frame.origin.y - (CGFloat(i - 1) * self.cardInteritemSpacing)
                }
            }, completion: nil)
            
        }
        
        // 2. add a new card (now the 4th card in the deck) to the very back
        if 4 > (self.questionsViewArray.count - 1) {
            if self.questionsViewArray.count != 1 {
                self.view.bringSubview(toFront: self.questionsViewArray[1])
            }
            return
        }
        let newCard = self.questionsViewArray[4]
        newCard.layer.zPosition = CGFloat(self.questionsViewArray.count - 4)
        let downscale = cardAttributes[3].downscale
        let alpha = cardAttributes[3].alpha
        
        // initial state of new card
        newCard.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        newCard.alpha = 0
        newCard.center.x = self.view.center.x
        newCard.frame.origin.y = self.questionsViewArray[1].frame.origin.y - (4 * cardInteritemSpacing)
        self.view.addSubview(newCard)
        
        // animate to end state of new card
        UIView.animate(withDuration: animationDuration, delay: (3 * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            newCard.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            newCard.alpha = alpha
            newCard.center.x = self.view.center.x
            newCard.frame.origin.y = self.questionsViewArray[1].frame.origin.y - (3 * self.cardInteritemSpacing) + 1.5
        }, completion: { (_) in
            
        })
        // first card needs to be in the front for proper interactivity
        self.view.bringSubview(toFront: self.questionsViewArray[1])
        
    }
    
    /// Whenever the front card is off the screen, this method is called in order to remove the card from our data structure and from the view.
    func removeOldFrontCard() {
        self.questionsViewArray[0].removeFromSuperview()
        self.questionsViewArray.remove(at: 0)
    }
    
    func hideFrontCard() {
        if #available(iOS 10.0, *) {
            var cardRemoveTimer: Timer? = nil
            cardRemoveTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (_) in
                guard self != nil else { return }
                if !(self!.view.bounds.contains(self!.questionsViewArray[0].center)) {
                    cardRemoveTimer!.invalidate()
                    self?.cardIsHiding = true
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                        self?.questionsViewArray[0].alpha = 0.0
                    }, completion: { (_) in
                        self?.removeOldFrontCard()
                        self?.cardIsHiding = false
                    })
                }
            })
        } else {
            // fallback for earlier versions
            UIView.animate(withDuration: 0.2, delay: 1.5, options: [.curveEaseIn], animations: {
                self.questionsViewArray[0].alpha = 0.0
            }, completion: { (_) in
                self.removeOldFrontCard()
            })
        }
    }
    
    // MARK: -  IBAction Methods.
    func didTapSubmitButton(_ sender: UIButton) {
        if self.currentQuestionNumber + 1 > self.questionsArray.count {
            let results = self.answersArray.duplicatesRemoved()
            print(results)
            self.apiCallForSubmitAnswers(result: results)
        } else {
            if let firstCard = questionsViewArray.first {
                UIView.animate(withDuration: 0.5, animations: {
                    firstCard.frame = CGRect.init(x: -firstCard.frame.width, y: firstCard.frame.origin.y - 50 , width: firstCard.frame.width, height: firstCard.frame.height)
                    self.view.layoutIfNeeded()
                }) { (complete) in
                    self.showNextCard()
                    self.hideFrontCard()
                    
                    self.currentQuestionNumber =  self.currentQuestionNumber + 1
                    self.questionNumberLbl.text = "\(self.currentQuestionNumber)/\(self.questionsArray.count)"
                }
            }
        }
    }
    
    
    // MARK: -  Memory warning and handling Method.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        setupInitailView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: -  QuestionViewDelegate Methods.
extension QuestionsViewController: QuestionViewDelegate {
    func didTapSubmitButton(_ sender: UIButton, view: QuestionView) {
        if view.isSelected > -1 {
            if let user = UserProfileModel.getUserLogin(),view.questionArray.options.count > view.isSelected {
                answersArray.append(["QuestionId": "\(view.questionArray.questionId ?? 0)",
                                     "ParticipateId":  "\(user.id ?? 0)",
                                     "TicketId" : "\(ticketId )",
                                     "Answer" : "\(view.questionArray.options[view.isSelected])",
                    ])
                self.didTapSubmitButton(sender)
            }
        } else {
            self.presentAlertWith(message: ConstantsMessages.kQuestionError)
        }
    }
}

// MARK: -  API Calling Methods.
extension QuestionsViewController {
    
    func apiCallForQuestions() {
        
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "ProductId" : self.productId,
                               "ParticipateId" : user.id ?? 0,
                ] as [String : Any]
            Global.showLoadingSpinner()
            ApiManager.apiCallForGetQuestions(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if (error == nil) {
                    if let responseObjects = responseObject {
                        if let datas = responseObjects["Data"] as? [[String:Any]] {
                            for item in datas {
                                 self.questionsArray.append(QuestionModel.init(fromDictionary: item))
                            }
                            DispatchQueue.main.async {
                                self.setUpQuestionsView()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func apiCallForSubmitAnswers(result:[[String:String]]) {
        let parameters = [ "Result" : result,
                           "ProductId" : self.productId
            ] as [String : Any]
        Global.showLoadingSpinner()
        ApiManager.apiCallForSubmitQuestions(parameters: parameters) { (responseObject, error) in
            Global.dismissLoadingSpinner()
            if (error == nil) {
                if let responseObjects = responseObject {
                    var message = ConstantsMessages.kQuestionSubmitted
                    if let datas = responseObjects["Data"] as? String {
                        message = datas
                    }
                    DispatchQueue.main.async {
                        self.presentAlertWith(message: message, oktitle: "Ok", okaction: {
                            
                            if let resultVc = self.storyboard?.instantiateViewController(withIdentifier: ResultViewController.className) as? ResultViewController {
                                resultVc.productId = self.productId
                                resultVc.ticketId = result[0]["TicketId"]!
                                self.navigationController?.pushViewController(resultVc, animated: true)
                            }
                            //self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                }
            }
        }
    }
}
