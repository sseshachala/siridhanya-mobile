//
//  OthersViewController.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 18/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit
import SafariServices
class OthersViewController: UIViewController {

    @IBOutlet weak var noRecordFound: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    var dashBoardDataObj = DashBoardModel()
     var selectedIndex  = [IndexPath]()
    var modelArray = [OtherModel]()
    var totalPage = 0
    var currentPage = 1
    var next_page_url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = dashBoardDataObj.menu_name
        noRecordFound.isHidden = true
        self.getApiValue(Url: dashBoardDataObj.service_name)
        // Do any additional setup after loading the view.
    }
    func getApiValue(Url : String){
        
        WebService.getAPIWith(api: Url, jsonString: [:], header: [:], centerUrl: "", msg: "Loading...", success: { (result, flag) in
            print(result)
            if let data =  result.value(forKeyPath: "data") as? [Any]{

              //  self.totalPage = (result.value(forKeyPath: "last_page") as? Int)!
                
                if let totalPage = result.value(forKeyPath: "last_page") as? Int{
                    self.totalPage = totalPage
                }
                
                self.next_page_url = ""
                
                if let nextPage = result.value(forKeyPath: "next_page_url") as? String{
                    self.next_page_url = nextPage
                }
                
                
                for dict in data{
                    
                    var objDashBoardModel = OtherModel()
                    
                    objDashBoardModel = objDashBoardModel.getOtherModelWith(dict: dict as! [String : AnyObject])
                    self.modelArray.append(objDashBoardModel)
                    
                }
            }
            if(self.modelArray.count > 0){
                self.tblView.isHidden = false
                self.noRecordFound.isHidden = true
            }else{
                self.tblView.isHidden = true
                self.noRecordFound.isHidden = false
            }
            self.tblView.reloadData()
        }) { (error) in
            print(error)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension OthersViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OtherTableViewCell = self.tblView.dequeueReusableCell(withIdentifier: "OtherTableViewCell") as! OtherTableViewCell
        
        let objData = self.modelArray[indexPath.row]
        cell.nameLbl.text = objData.name.htmlToString
        cell.authorName.text = objData.author.htmlToString
        cell.descriptionlb.text = objData.descriptions.htmlToString
       // cell.moreInfoLbl.text = objData.video_url.htmlToString
        cell.ImageView.sd_setImage(with: NSURL(string: objData.image )! as URL, placeholderImage: #imageLiteral(resourceName: "smallLogoWithBack"), options: .retryFailed, completed: nil)
        
        if(objData.author.isBlank){
            cell.authorNameWidth.constant = 0
            cell.authorNameFixLbl.text = ""
        }else{
            cell.authorNameWidth.constant = 120
            cell.authorNameFixLbl.text = "Author"
        }
    
        
        if(selectedIndex.contains(indexPath)){
            cell.exapndImageView.image = #imageLiteral(resourceName: "ExpandedRed")
            
        }else{
            cell.exapndImageView.image = #imageLiteral(resourceName: "Expanded")
        }
        
        if(objData.video_url.isBlank){
            cell.moreInfoFixLbl.text = ""
            cell.moreInfoLbl.text = ""
        }else{
            cell.moreInfoFixLbl.text = "More Info"
            cell.moreInfoLbl.attributedText = NSAttributedString(string: "Video", attributes:
                [.underlineStyle: NSUnderlineStyle.single.rawValue])
           
        }
        
        if(objData.image.isBlank){
          cell.imageViewHeight.constant = 0
        }else{
            cell.imageViewHeight.constant = 100
        }
     
        
        cell.moreInfoButton.tag = indexPath.row
        cell.authorButton.tag = indexPath.row
        cell.authorButton.addTarget(self, action: #selector(self.buttonAuthorPressed(_:)), for: .touchUpInside)
        cell.moreInfoButton.addTarget(self, action: #selector(self.buttonMoreInfoPressed(_:)), for: .touchUpInside)
        
        
        
       
        
        if indexPath.row == self.modelArray.count - 1 { // last cell
            if Int(totalPage) > currentPage{ // more items to fetch
                currentPage = currentPage + 1
                if(!next_page_url.isEmpty)
                {
                    self.getApiValue(Url: next_page_url)
                    
                }
              
            }
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(selectedIndex.contains(indexPath)){
            let indx = selectedIndex.firstIndex(of: indexPath)
            selectedIndex.remove(at: indx!)
        }else{
            selectedIndex.append(indexPath)
        }
        //tableView.scrollToRow(at: indexPath, at: .none, animated: false)
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        
        tableView.endUpdates()
        //self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataObj = self.modelArray[indexPath.row]
        if(selectedIndex.contains(indexPath)){
            
            // let dataObj = self.nutritionArray[indexPath.row]
            
            
            
            let height = Common_Methods.heightForView(text: dataObj.name.isEmpty ? "-" : dataObj.name , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 241)
            
            let height2 = Common_Methods.heightForView(text: dataObj.author.isEmpty ? "-" : dataObj.author.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 245)
            
            
            var final = height2
            var lessHeight = 0
            if (height > height2){
                final = height
            }
            
            let height3 = Common_Methods.heightForView(text: dataObj.descriptions.isEmpty ? "-" : dataObj.descriptions.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
            
            
            
            if(dataObj.author.isBlank){
                let height = Common_Methods.heightForView(text: dataObj.name.isEmpty ? "-" : dataObj.name , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 90)
                final = height
            }
            
            
            if(dataObj.video_url.isBlank){
               lessHeight =  lessHeight + 65
            }
           
            if(dataObj.image.isBlank){
                lessHeight =  lessHeight + 100
            }
           
            
            return ((final + height3 + 280) - CGFloat(lessHeight))
        }
        
        let height = Common_Methods.heightForView(text: dataObj.name.isEmpty ? "-" : dataObj.name , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 241)
        
        let height2 = Common_Methods.heightForView(text: dataObj.author.isEmpty ? "-" : dataObj.author , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 245)
        var final = height2
        
        if (height > height2){
            final = height
        }
        
        if(dataObj.author.isBlank){
            let height = Common_Methods.heightForView(text: dataObj.name.isEmpty ? "-" : dataObj.name , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 90)
            final = height
        }
        
        return 60 + final
        
     
    }
    @objc func buttonMoreInfoPressed(_ sender: UIButton){
        let obj = self.modelArray[sender.tag]
        self.openSafariView(obj: obj)
    }
    @objc func buttonAuthorPressed(_ sender: UIButton){
        let obj = self.modelArray[sender.tag]
        let email = obj.email
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    func openSafariView(obj : OtherModel){
        
        let safariVC = SFSafariViewController(url: NSURL(string: obj.video_url)! as URL)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
}
extension OthersViewController : SFSafariViewControllerDelegate{
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
