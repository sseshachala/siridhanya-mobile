//
//  FAQ.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 15/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit
import SwiftSoup
class FAQ: UIViewController {
    
    
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var answerImageView: UIImageView!
    @IBOutlet weak var qusetionLbl: UILabel!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    
    
    
    @IBOutlet weak var noDataFound: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    var dashBoardDataObj = DashBoardModel()
    var faqArray = [FAQModel]()
    var totalPage = 0
    var currentPage = 1
    var next_page_url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.isHidden = true
        titleLbl.text = dashBoardDataObj.menu_name
        noDataFound.isHidden = true
        self.getApiValue()
        // Do any additional setup after loading the view.
    }
    func getApiValue(){
        
        WebService.getAPIWith(api: dashBoardDataObj.service_name, jsonString: [:], header: [:], centerUrl: "", msg: "Loading...", success: { (result, flag) in
           // //print(result)
            
            if let data = result.value(forKeyPath: "data") as? [Any]{
               // self.totalPage = (result.value(forKeyPath: "last_page") as? Int)!
                
                if let totalPage = result.value(forKeyPath: "last_page") as? Int{
                    self.totalPage = totalPage
                }
                
                self.next_page_url = ""
                
                if let nextPage = result.value(forKeyPath: "next_page_url") as? String{
                    self.next_page_url = nextPage
                }
                
                
                for dict in data{
                    
                    var objDashBoardModel = FAQModel()
                    
                    objDashBoardModel = objDashBoardModel.getFAQModelWith(dict: dict as! [String : AnyObject])
                    self.faqArray.append(objDashBoardModel)
                    
                }
            }
            if(self.faqArray.count > 0){
                self.tableView.isHidden = false
                self.noDataFound.isHidden = true
            }else{
                self.tableView.isHidden = true
                self.noDataFound.isHidden = false
            }
            self.tableView.reloadData()
        }) { (error) in
            print(error)
        }
    }
    
    
    
    func getNextPage(Url : String){
        
        WebService.getAPIWith(api: Url, jsonString: [:], header: [:], centerUrl: "", msg: "Loading...", success: { (result, flag) in
            ////print(result)
            
            if let data = result.value(forKeyPath: "data") as? [Any]{
             //   self.totalPage = (result.value(forKeyPath: "last_page") as? Int)!
                
                if let totalPage = result.value(forKeyPath: "last_page") as? Int{
                    self.totalPage = totalPage
                }
                
                self.next_page_url = ""
                
                if let nextPage = result.value(forKeyPath: "next_page_url") as? String{
                    self.next_page_url = nextPage
                }
                
                
                for dict in data{
                    
                    var objDashBoardModel = FAQModel()
                    
                    objDashBoardModel = objDashBoardModel.getFAQModelWith(dict: dict as! [String : AnyObject])
                    self.faqArray.append(objDashBoardModel)
                    
                }
            }
            if(self.faqArray.count > 0){
                self.tableView.isHidden = false
                self.noDataFound.isHidden = true
            }else{
                self.tableView.isHidden = true
                self.noDataFound.isHidden = false
            }
            self.tableView.reloadData()
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func crossButtonPressed(_ sender: Any) {
        self.backView.isHidden = true
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension FAQ : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionAnswerTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerTableViewCell") as! QuestionAnswerTableViewCell
        
        let objData = self.faqArray[indexPath.row]
        
        cell.txtValueLbl.text = objData.question.htmlToString
        
        cell.iconImage.sd_setImage(with: NSURL(string: objData.question_icon )! as URL, placeholderImage: #imageLiteral(resourceName: "q"), options: .retryFailed, completed: nil)
        cell.answerButton.addTarget(self, action: #selector(self.buttonAnswerPressed(_:)), for: .touchUpInside)
        cell.answerButton.tag = indexPath.row
        
        
       
        
        
       
       
        
        
        if indexPath.row == self.faqArray.count - 1 { // last cell
            if Int(totalPage) > currentPage{ // more items to fetch
                currentPage = currentPage + 1
                if(!next_page_url.isEmpty)
                {
                self.getNextPage(Url: next_page_url)
                }
                //  self.getMeetingList(type: self.topBarArray[self.topBarCurrentSelction]["Name"]!, page: currentPage)
                //   self.getList(currentPage: currentPage)
            }
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func buttonAnswerPressed(_ sender: UIButton){
        
        let objData = self.faqArray[sender.tag]
       //answerTextView.isHidden = false
     //   answerExtraImageview.isHidden = true
        //self.answerTextView.text  = ""
        
     /*   var imageURl = ""
        var dataString = ""
        
        do {
            let html: String = objData.answer
            let els: Elements = try SwiftSoup.parse(html).select("img")
            for link: Element in els.array() {
                imageURl = try link.attr("src")
             
                
                dataString = html.withoutHtmlTags
               
                
            }
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
        
        if(dataString.isBlank)
        {
            if(objData.answer.isBlank)
            {
                answerTextView.isHidden = true
            }
            answerTextView.text = objData.answer
        }else{
            answerTextView.text = dataString
            
        }
        if(imageURl.isEmpty){
            answerExtraImageview.isHidden = true
        }else{
            if(dataString.isBlank){
                answerTextView.isHidden = true
            }
            answerExtraImageview.sd_setImage(with: NSURL(string: imageURl )! as URL, placeholderImage: #imageLiteral(resourceName: "A"), options: .retryFailed, completed: nil)
        }*/
        
        
        DispatchQueue.main.async {
        Common_Methods.showHUD(with: "")
            self.webView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.webView.loadHTMLString(objData.answer, baseURL: nil)
          
       /*     let x = "<span style=\"font-family: Roboto-Regular; font-size: 17\">\(objData.answer)</span>"
            
        let htmlData = NSString(string: x).data(using: String.Encoding.unicode.rawValue)
        
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        
            let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 17)!,NSAttributedString.Key.foregroundColor: UIColor.white]
            
            let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
            
            

            self.answerTextView.attributedText = attributedString*/
        Common_Methods.hideHUD()
        }
        answerImageView.sd_setImage(with: NSURL(string: objData.answer_icon )! as URL, placeholderImage: #imageLiteral(resourceName: "A"), options: .retryFailed, completed: nil)
        qusetionLbl.text = objData.question
        questionImageView.sd_setImage(with: NSURL(string: objData.question_icon )! as URL, placeholderImage: #imageLiteral(resourceName: "q"), options: .retryFailed, completed: nil)
        self.backView.isHidden = false
    }
    
}
extension String {
    var withoutHtmlTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options:
            .regularExpression, range: nil).replacingOccurrences(of: "&[^;]+;", with:
                "", options:.regularExpression, range: nil)
    }
}
