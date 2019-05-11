    //
//  LifeStyleViewController.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 24/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class LifeStyleViewController: UIViewController {
    
    var uiWebViewHeight = [CGFloat]()
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var noDataFound: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dashBoardDataObj = DashBoardModel()
    var commanObjArray = [CommanModel]()
    var selectedIndex  = [IndexPath]()
    
    var totalPage = 0
    var currentPage = 1
    var next_page_url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = dashBoardDataObj.menu_name
        noDataFound.isHidden = true
        commanObjArray = []
        uiWebViewHeight = []
        self.getApiValue(url: dashBoardDataObj.service_name)
        // Do any additional setup after loading the view.
    }
    func getApiValue(url : String){
        
        WebService.getAPIWith(api: url, jsonString: [:], header: [:], centerUrl: "", msg: "Loading...", success: { (result, flag) in
          //  //print(result)
            if let data = result as? [AnyObject]{
                for dict in data{
                    
                    var objDashBoardModel = CommanModel()
                    
                    objDashBoardModel = objDashBoardModel.getCommanModelWith(dict: dict as! [String : AnyObject])
                    self.commanObjArray.append(objDashBoardModel)
                    self.uiWebViewHeight.append(20)
                    
                }
            }else if let data = result.value(forKeyPath: "data") as? [Any]{
                for dict in data{
                    
                    if let totalPage = result.value(forKeyPath: "last_page") as? Int{
                        self.totalPage = totalPage
                    }
                    
                    self.next_page_url = ""
                    
                    if let nextPage = result.value(forKeyPath: "next_page_url") as? String{
                        self.next_page_url = nextPage
                    }
                    
                    
                    
                    var objDashBoardModel = CommanModel()
                    
                    objDashBoardModel = objDashBoardModel.getCommanModelWith(dict: dict as! [String : AnyObject])
                    self.commanObjArray.append(objDashBoardModel)
                    self.uiWebViewHeight.append(40)
                    
                }
            }
            if(self.commanObjArray.count > 0){
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LifeStyleViewController : UITableViewDelegate , UITableViewDataSource , UIWebViewDelegate{
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return self.commanObjArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell: CommanTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CommanTableViewCell") as! CommanTableViewCell
                let dataObj = self.commanObjArray[indexPath.row]
                cell.coutLbl.text = "\(indexPath.row + 1)"
           //     cell.txtValueLbl.text = dataObj.note.htmlToString
            
            
            //cell.txtValueLbl.isHidden = true
            
            
            cell.webview.delegate = nil
            
         
            if(uiWebViewHeight[indexPath.row] == 40)
                {
                    
                cell.webview.isOpaque = false
                  
                cell.webview.loadHTMLString(dataObj.note, baseURL: nil)
                        cell.webview.tag = indexPath.row
                    cell.webview.scrollView.isScrollEnabled = false
                        cell.webview.delegate = self
                        cell.wevViewHeight.constant = self.uiWebViewHeight[indexPath.row]
                   
                }else{
                cell.webview.isOpaque = false
                 cell.webview.loadHTMLString(dataObj.note, baseURL: nil)
                    cell.wevViewHeight.constant = uiWebViewHeight[indexPath.row]
                }
                
                
           
            
            
            
                
                if indexPath.row == self.commanObjArray.count - 1 { // last cell
                    if Int(totalPage) > currentPage{ // more items to fetch
                        currentPage = currentPage + 1
                        if(!next_page_url.isEmpty)
                        {
                            self.getApiValue(url: next_page_url)
                            
                        }
                        //  self.getMeetingList(type: self.topBarArray[self.topBarCurrentSelction]["Name"]!, page: currentPage)
                        //   self.getList(currentPage: currentPage)
                    }
                }
                
                return cell
            
            
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.uiWebViewHeight[indexPath.row] + 20
    }
        
        /*   func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         if (selectedIndex.contains(indexPath)){
         // return UITableView.automaticDimension
         } else {
         return 70
         }
         }*/
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        
       
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.showsVerticalScrollIndicator = false
      self.uiWebViewHeight[webView.tag] = webView.documentHeight
        
            self.tableView.reloadData()
            
        
        
        //  self.tblView.beginUpdates()
        //  self.tblView.endUpdates()
        
    }
}
