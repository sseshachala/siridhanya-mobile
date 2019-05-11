//
//  UniversalSearchViewController.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 25/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class UniversalSearchViewController: UIViewController {
    
    
    @IBOutlet weak var titleLbl: UILabel!
    var dashBoardDataObj = DashBoardModel()
    var filterArray = [UniversalSerachModel]()
    fileprivate var uiWebView1Height: CGFloat = 20
    fileprivate var uiWebView2Height: CGFloat = 20
    fileprivate var uiWebView3Height: CGFloat = 20
    var selectedIndex = IndexPath()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchBar.layoutSubviews()
        
        let topPadding: Float = 0.0
        for view in self.searchBar.subviews as [UIView]
        {
            for viewNew in view.subviews as [UIView]
            {
                if let vf = viewNew as? UITextField {
                    
                    vf.frame = CGRect(x: vf.frame.origin.x, y: CGFloat(topPadding), width: vf.frame.size.width, height: 45)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = dashBoardDataObj.menu_name
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        
        
        searchBar.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
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
    func getApi(searchText : String){
        
         let para = ["searchTerm" : searchText]
        
        WebService.postAPI(api: dashBoardDataObj.service_name, jsonString: para as [String : AnyObject], header: [:], centerUrl: "", msg: "", success: { (result, flag) in
         // print(result)
            self.filterArray = []
            if(self.searchBar.text?.isBlank == true)
            {
                self.filterArray = []
                return
            }
            if let data = result as? [AnyObject]{
                for dict in data{
                    
                    var objDashBoardModel = UniversalSerachModel()
                    
                    objDashBoardModel = objDashBoardModel.getUniversalSerachModelWith(dict: dict as! [String : AnyObject])
                    self.filterArray.append(objDashBoardModel)
                    
                    
                }
            }
            DispatchQueue.main.async {
            
            self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
        
      /* WebService.getAPIWith(api: url, jsonString: [:], header: [:], centerUrl: "", msg: "Loading...", success: { (result, flag) in
            // //print(result)
            self.filterArray = []
            if(self.searchBar.text?.isBlank == true)
            {
            self.filterArray = []
                return
            }
            if let data = result as? [AnyObject]{
                for dict in data{
                    
                    var objDashBoardModel = UniversalSerachModel()
                    
                    objDashBoardModel = objDashBoardModel.getUniversalSerachModelWith(dict: dict as! [String : AnyObject])
                    self.filterArray.append(objDashBoardModel)
                    
                    
                }
            }
            
            
            self.tableView.reloadData()
        }) { (error) in
            print(error)
        }*/
    }
}
extension UniversalSearchViewController : UITableViewDelegate , UITableViewDataSource , UIWebViewDelegate{
    
    //MARK: -  TableView Delegate 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UniversalCell = self.tableView.dequeueReusableCell(withIdentifier: "UniversalCell") as! UniversalCell
        if(filterArray.count > indexPath.row)
        {
        let objDict = self.filterArray[indexPath.row]
        
        cell.typeOfAilment.text = objDict.Type_of_Ailment.htmlToString
        
        
        
        cell.dictoctionKasayam.delegate = nil
        cell.milletProtocol.delegate = nil
        cell.tagsKeyWord.delegate = nil
        
        if(selectedIndex == indexPath){
            if(uiWebView1Height == 20)
            {
                DispatchQueue.main.async {
                    cell.dictoctionKasayam.loadHTMLString(objDict.Dictoction_Kashayam_Diet, baseURL: nil)
                    cell.dictoctionKasayam.tag = indexPath.row + 1000
                    cell.dictoctionKasayam.delegate = self
                    cell.dictoctionKasayamHeight.constant = self.uiWebView1Height
                }
            }else{
                cell.dictoctionKasayam.loadHTMLString(objDict.Dictoction_Kashayam_Diet, baseURL: nil)
                
                cell.dictoctionKasayamHeight.constant = uiWebView1Height
            }
            
            
            if(uiWebView2Height == 20)
            {
                DispatchQueue.main.async {
                    cell.tagsKeyWord.loadHTMLString(objDict.Tags_Keywords, baseURL: nil)
                    cell.tagsKeyWord.tag = indexPath.row + 2000
                    cell.tagsKeyWord.delegate = self
                    cell.tagKeywordHeight.constant = self.uiWebView2Height
                }
            }else{
                cell.tagsKeyWord.loadHTMLString(objDict.Tags_Keywords, baseURL: nil)
                
                cell.tagKeywordHeight.constant = uiWebView2Height
            }
            
            if(uiWebView3Height == 20)
            {
                DispatchQueue.main.async {
                    cell.milletProtocol.loadHTMLString(objDict.milletProtocol, baseURL: nil)
                    cell.milletProtocol.tag = indexPath.row + 3000
                    cell.milletProtocol.delegate = self
                    cell.milletProtocolHeight.constant = self.uiWebView3Height
                }
            }else{
                cell.milletProtocol.loadHTMLString(objDict.milletProtocol, baseURL: nil)
                
                cell.milletProtocolHeight.constant = uiWebView3Height
            }
            
            
        }
        
        if(selectedIndex == indexPath){
            cell.expandCell.image = #imageLiteral(resourceName: "ExpandedRed")
            
        }else{
            cell.expandCell.image = #imageLiteral(resourceName: "Expanded")
        }
        
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        uiWebView1Height = 20
        uiWebView2Height = 20
        uiWebView3Height = 20
        
        
        if(selectedIndex == indexPath){
            let indx = NSIndexPath(row: -1, section: 0)
            selectedIndex = indx as IndexPath
        }else{
            selectedIndex = indexPath
        }
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if(filterArray.count > indexPath.row)
        {
       let dataObj = self.filterArray[indexPath.row]
        
         let height = Common_Methods.heightForView(text: dataObj.Type_of_Ailment.isEmpty ? "-" : dataObj.Type_of_Ailment , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 100)
        
        if(selectedIndex == indexPath){
            
           
            
            
            return height + uiWebView1Height + uiWebView2Height + uiWebView3Height + 200
            
            
        }
        
        
        return height + 50
        }
        return 0
    }
    

     //MARK: -  WebView Delegate 
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        webView.scrollView.isScrollEnabled = false
        if(webView.tag == selectedIndex.row + 1000)
        {
            self.uiWebView1Height = webView.documentHeight
        }else if(webView.tag == selectedIndex.row + 2000){
            self.uiWebView2Height = webView.documentHeight
        }else if(webView.tag == selectedIndex.row + 3000){
            self.uiWebView3Height = webView.documentHeight
        }
        
        self.tableView.reloadData()
        
      /*  DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
            
            if(self.filterArray.count > self.selectedIndex.row)
            {
                
            //let index = NSIndexPath(row: self.selectedIndex.row, section: 0)
                print(self.selectedIndex)
                if(self.selectedIndex.row > 0)
                {
                    print(self.selectedIndex)
                }
            self.tableView.scrollToRow(at: self.selectedIndex , at: .top, animated: false)
            }
        })*/
      
        
    }
}

extension UniversalSearchViewController : UISearchBarDelegate{
    //MARK: -  SearchBar Delegate 
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            
            filterArray = []
            DispatchQueue.main.async {
                self.view.endEditing(true)
            }
            self.tableView.reloadData()
            
            return
            //print("UISearchBar.text cleared!")
        }else{
          filterArray = []
            
         self.getApi(searchText: searchText)
        }
        
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
    
}
class UniversalCell: UITableViewCell{
    
    
    @IBOutlet weak var milletProtocolHeight: NSLayoutConstraint!
    @IBOutlet weak var tagKeywordHeight: NSLayoutConstraint!
    @IBOutlet weak var dictoctionKasayamHeight: NSLayoutConstraint!
    @IBOutlet weak var milletProtocol: UIWebView!
    @IBOutlet weak var tagsKeyWord: UIWebView!
    @IBOutlet weak var dictoctionKasayam: UIWebView!
    @IBOutlet weak var expandCell: UIImageView!
    
    @IBOutlet weak var typeOfAilment: UILabel!
    
    
}
