//
//  OthersViewController.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 18/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit
import SafariServices
import WebKit
class OthersViewController: UIViewController {
    
    @IBOutlet weak var noRecordFound: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    fileprivate var uiWebViewHeight: CGFloat = 20
    var dashBoardDataObj = DashBoardModel()
    var selectedIndex  = IndexPath()
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
          //  //print(result)
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

extension OthersViewController : UITableViewDelegate , UITableViewDataSource,UIWebViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OtherTableViewCell = self.tblView.dequeueReusableCell(withIdentifier: "OtherTableViewCell") as! OtherTableViewCell
        
        let objData = self.modelArray[indexPath.row]
        cell.nameLbl.text = objData.name.htmlToString
        cell.authorName.text = objData.author.htmlToString
        //  cell.descriptionlb.text = objData.descriptions.htmlToString
        cell.moreInfoLbl.text = objData.video_url.htmlToString
        
        
        
        /*   let htmlData = NSString(string: x).data(using: String.Encoding.unicode.rawValue)
         
         let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
         
         let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 17)!,NSAttributedString.Key.foregroundColor: UIColor.white]
         
         let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
         */
        
        
        
        
        
        cell.ImageView.sd_setImage(with: NSURL(string: objData.image )! as URL, placeholderImage: #imageLiteral(resourceName: "smallLogoWithBack"), options: .retryFailed, completed: nil)
        
        if(objData.author.isBlank){
            cell.authorNameWidth.constant = 0
            cell.authorNameFixLbl.text = ""
        }else{
            cell.authorNameWidth.constant = 120
            cell.authorNameFixLbl.text = "Author"
        }
        
        
        if(selectedIndex == indexPath){
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
        
        cell.webView.delegate = nil
        
        if(selectedIndex == indexPath){
            if(uiWebViewHeight == 20)
            {
                DispatchQueue.main.async {
                    cell.webView.loadHTMLString(objData.descriptions, baseURL: nil)
                    cell.webView.tag = indexPath.row
                    cell.webView.delegate = self
                    cell.webViewHeight.constant = self.uiWebViewHeight
                }
            }else{
               cell.webView.loadHTMLString(objData.descriptions, baseURL: nil)
                
                cell.webViewHeight.constant = uiWebViewHeight
            }
            
            
        }
        
        
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
        uiWebViewHeight = 20
        if(selectedIndex == indexPath){
            let inx = NSIndexPath(row: -1, section: 0)
            selectedIndex = inx as IndexPath
            
        }else{
            selectedIndex = indexPath
        }
        //tableView.scrollToRow(at: indexPath, at: .none, animated: false)
        
        
        //  tableView.reloadRows(at: [indexPath], with: .none)
        
        
        self.tblView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataObj = self.modelArray[indexPath.row]
        if(selectedIndex == indexPath){
            
            
            
            
            
            let height = Common_Methods.heightForView(text: dataObj.name.isEmpty ? "-" : dataObj.name , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 241)
            
            let height2 = Common_Methods.heightForView(text: dataObj.author.isEmpty ? "-" : dataObj.author.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 245)
            
            
            var final = height2
            var lessHeight = 0
            if (height > height2){
                final = height
            }
            
            
            //  let height3 = x.htmlToAttributedString?.height(containerWidth: self.view.frame.width - 50)
            
            //   let height3 = Common_Methods.heightForView(text: dataObj.descriptions.isEmpty ? "-" : x.htmlToAttributedString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
            
            
            
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
            
            
            return ((final +  uiWebViewHeight + 320) - CGFloat(lessHeight))
        }
        
        let height = Common_Methods.heightForView(text: dataObj.name.isEmpty ? "-" : dataObj.name.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 241)
        
        let height2 = Common_Methods.heightForView(text: dataObj.author.isEmpty ? "-" : dataObj.author.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 245)
        var final = height2
        
        if (height > height2){
            final = height
        }
        
        if(dataObj.author.isBlank){
            let height = Common_Methods.heightForView(text: dataObj.name.isEmpty ? "-" : dataObj.name.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 90)
            final = height
        }
        
        return 60 + final
        
        
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        
        if(webView.tag == selectedIndex.row)
        {
            webView.scrollView.isScrollEnabled = false
            self.uiWebViewHeight = webView.documentHeight
            self.tblView.reloadData()
            
        /*    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                let index = NSIndexPath(row: self.selectedIndex.row, section: 0)
                self.tblView.scrollToRow(at: index as IndexPath, at: .top, animated: false)
            })*/
        }
        //  self.tblView.beginUpdates()
        //  self.tblView.endUpdates()
        
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
        
        guard let url = URL(string: obj.video_url) else { return }
        UIApplication.shared.open(url)
        
        /*  let safariVC = SFSafariViewController(url: NSURL(string: obj.video_url)! as URL)
         self.present(safariVC, animated: true, completion: nil)
         safariVC.delegate = self*/
    }
}
extension OthersViewController : SFSafariViewControllerDelegate{
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
extension UIWebView {
    
    func loadFile(from url: URL) throws {
        
        let string = try String(contentsOf: url, encoding: String.Encoding.utf8)
        
        self.loadHTMLString(string, baseURL: url.deletingLastPathComponent())
    }
    
    var documentHeight: CGFloat {
        
        if let string = self.stringByEvaluatingJavaScript(from: "document.documentElement.offsetHeight"), let height = Float(string) {
            
            return CGFloat(height)
        }
        return 0
    }
}
extension NSAttributedString {
    
    func height(containerWidth: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.height)
    }
    
    func width(containerHeight: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: containerHeight), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.width)
    }
    
}
