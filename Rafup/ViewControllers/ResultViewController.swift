//
//  ResultViewController.swift
//  Rafup
//
//  Created by Ashish Soni on 31/01/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var btnWrong: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var lblTotalQuestion: UILabel!
    // MARK: -  Variable Declaration.
    var productId = 0
    var ticketId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Result"
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated:true);
        apiCallForShowResult()
        
        DispatchQueue.main.async {
            self.view.setGradient(colours: [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) , #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resultDoneBtnPress(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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

// MARK: -  API Calling Methods.
extension ResultViewController {
    
    func apiCallForShowResult() {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "ProductId" : self.productId,
                               "UserId" : user.id ?? 0,
                               "TicketId" : self.ticketId
                ] as [String : Any]
            Global.showLoadingSpinner()
            ApiManager.apiCallForShowResult(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if (error == nil) {
                    if let responseObjects = responseObject {
                        if let datas = responseObjects["Data"] as? [[String:Any]] {
                            DispatchQueue.main.async {
                                self.lblTotalQuestion.text = String.init(format: "%@ %@", "Total Questions", datas[0]["total"]! as! CVarArg)
                                let right  = String.init(format: "%@", datas[0]["correct"]! as! CVarArg)
                                let wrong  = String.init(format: "%@", datas[0]["inCorrect"]! as! CVarArg)
                                self.btnRight.setTitle(right , for: UIControlState.normal)
                                self.btnWrong.setTitle(wrong, for: UIControlState.normal)
                            }
                        }
                    }
                }
            }
        }
    }
}
