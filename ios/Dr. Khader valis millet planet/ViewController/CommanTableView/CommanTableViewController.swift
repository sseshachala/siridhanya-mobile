//
//  CommanTableViewController.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 14/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class CommanTableViewController: UIViewController,UISearchBarDelegate {
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noDataFound: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dashBoardDataObj = DashBoardModel()
    var commanObjArray = [CommanModel]()
    var selectedIndex  = IndexPath()
    var filterArray = [CommanModel]()
    
    var totalPage = 0
    var currentPage = 1
    var next_page_url = ""
    fileprivate var uiWebView1Height: CGFloat = 20
    fileprivate var uiWebView2Height: CGFloat = 20
    fileprivate var uiWebView3Height: CGFloat = 20
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        titleLbl.text = dashBoardDataObj.menu_name
        noDataFound.isHidden = true
        commanObjArray = []
        self.getApiValue(url: dashBoardDataObj.service_name)
        
        
       
        // Do any additional setup after loading the view.
    }
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
    
    
    
    func getApiValue(url : String){
        
        WebService.getAPIWith(api: url, jsonString: [:], header: [:], centerUrl: "", msg: "Loading...", success: { (result, flag) in
            //print(result)
            if let data = result as? [AnyObject]{
                for dict in data{
                    
                    var objDashBoardModel = CommanModel()
                    
                    objDashBoardModel = objDashBoardModel.getCommanModelWith(dict: dict as! [String : AnyObject])
                    self.commanObjArray.append(objDashBoardModel)
                    
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
    
    
    func getFilterValue(url : String){
        
        WebService.getAPIWith(api: url, jsonString: [:], header: [:], centerUrl: "", msg: "Loading...", success: { (result, flag) in
            //print(result)
            self.filterArray = []
            if let data = result as? [AnyObject]{
                for dict in data{
                    
                    var objDashBoardModel = CommanModel()
                    
                    objDashBoardModel = objDashBoardModel.getCommanModelWith(dict: dict as! [String : AnyObject])
                    self.filterArray.append(objDashBoardModel)
                    
                }
            }
            if(self.filterArray.count > 0){
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
    
    //MARK: -  SearchBar Delegate 
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            
            filterArray = []
            DispatchQueue.main.async {
                self.view.endEditing(true)
            }
            self.tableView.reloadData()
            if(self.commanObjArray.count > 0){
                self.tableView.isHidden = false
                self.noDataFound.isHidden = true
            }else{
                self.tableView.isHidden = true
                self.noDataFound.isHidden = false
            }
            
            
            return
            //print("UISearchBar.text cleared!")
        }
        if(dashBoardDataObj.menu_name == "Millet Diet For Diseases" )
        {
            
            filterArray = self.commanObjArray.filter { $0.self.Type_of_Ailment.lowercased().contains(searchText.lowercased())}
            
            
            // var url = "https://services.milletplanet.org/sdmobile/api/findMilletByDisease/" + searchBar.text!
            
            //   url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            //  self.getFilterValue(url: url)
            
            self.tableView.reloadData()
            
        }else if(dashBoardDataObj.menu_name ==  "Millet Diet For Cancer"){
            
            
            filterArray = self.commanObjArray.filter { $0.self.Type_of_Ailment.lowercased().contains(searchText.lowercased())}
            
            // var url = "https://services.milletplanet.org/sdmobile/api/findMilletByCancer/" + searchBar.text!
            
            // url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            //  self.getFilterValue(url: url)
            
            self.tableView.reloadData()
            
        }
        
       // print(searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        if(filterArray.count == 0 )
        {
            if(self.commanObjArray.count > 0){
                self.tableView.isHidden = false
                self.noDataFound.isHidden = true
            }else{
                self.tableView.isHidden = true
                self.noDataFound.isHidden = false
            }
            
        }
        /*  if(dashBoardDataObj.menu_name == "Millet Diet For Diseases" )
         {
         
         var url = "https://services.milletplanet.org/sdmobile/api/findMilletByDisease/" + searchBar.text!
         
         url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
         self.getFilterValue(url: url)
         
         }else if(dashBoardDataObj.menu_name ==  "Millet Diet For Cancer"){
         
         var url = "https://services.milletplanet.org/sdmobile/api/findMilletByCancer/" + searchBar.text!
         
         url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
         
         self.getFilterValue(url: url)
         
         }*/
        
        
    }
    
}
extension CommanTableViewController : UITableViewDelegate , UITableViewDataSource,UIWebViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(filterArray.count > 0)
        {
            return filterArray.count
        }
        return self.commanObjArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(dashBoardDataObj.menu_name == "Millet Diet For Diseases" )
        {
            let cell: CommanTableCellTypeTwo = self.tableView.dequeueReusableCell(withIdentifier: "CommanTableCellTypeTwo") as! CommanTableCellTypeTwo
            var dataObj = CommanModel()
            if(filterArray.count > 0 ){
                dataObj = self.filterArray[indexPath.row]
            }else{
                dataObj = self.commanObjArray[indexPath.row]
            }
            
            
            cell.diseaseNametxt.text = "Type of ailment"
            cell.DictoctionTxt.text = "Dictoction Kashayas Diet"
            cell.milletProTxt.text = "Tag Keywords"
            cell.specialIntTXt.text = "Millet Protocol"
            
            
            cell.diseaseName.text = dataObj.Type_of_Ailment.htmlToString
            
            
          
            if(selectedIndex == indexPath){
                cell.exapndImageView.image = #imageLiteral(resourceName: "ExpandedRed")
                
            }else{
                cell.exapndImageView.image = #imageLiteral(resourceName: "Expanded")
            }
            
            cell.milletProWebView.delegate = nil
            cell.ductoctionWebView.delegate = nil
            cell.specialInstWebView.delegate = nil
            
            if(selectedIndex == indexPath){
                if(uiWebView1Height == 20)
                {
                    if(!dataObj.Dictoction_Kashayam_Diet.isBlank)
                    {
                       cell.ductoctionWebView.isHidden = false
                        cell.ductoctionWebView.loadHTMLString(dataObj.Dictoction_Kashayam_Diet, baseURL: nil)
                        
                        cell.ductoctionWebView.tag = indexPath.row + 1000
                        cell.ductoctionWebView.delegate = self
                        
                    }else{
                        
                        cell.ductoctionWebView.isHidden = true
                    }
                    
                }else{
                    cell.ductoctionWebView.loadHTMLString(dataObj.Dictoction_Kashayam_Diet, baseURL: nil)
                    
                    cell.ductoctionWebViewHeight.constant = uiWebView1Height
                   
                }
                
                
                
            if(uiWebView2Height == 20)
                {
                    if(!dataObj.Tags_Keywords.isBlank)
                    {
                       
                       cell.milletProWebView.isHidden = false
                        cell.milletProWebView.loadHTMLString(dataObj.Tags_Keywords, baseURL: nil)
                    cell.milletProWebView.tag = indexPath.row + 2000
                    cell.milletProWebView.delegate = self
                    }else{
                        cell.milletProWebView.isHidden = true
                    }
                }else{
                cell.milletProWebView.loadHTMLString(dataObj.Tags_Keywords, baseURL: nil)
                    cell.milletProWebViewHeight.constant = uiWebView2Height
                    // cell.webViewHeight.constant = uiWebViewHeight
                }
                
                
                
               if(uiWebView3Height == 20)
                {
                   if(!dataObj.milletProtocol.isBlank)
                   {
                   cell.specialInstWebView.isHidden = false
                    cell.specialInstWebView.loadHTMLString(dataObj.milletProtocol, baseURL: nil)
                    
                    cell.specialInstWebView.tag = indexPath.row + 3000
                    cell.specialInstWebView.delegate = self
                   }else{
                        cell.specialInstWebView.isHidden = true
                    }
                }else{
                cell.specialInstWebView.loadHTMLString(dataObj.milletProtocol, baseURL: nil)
                    cell.specialInstWebViewHeight.constant = uiWebView3Height
                }
                
                
                
                
                
                
            }
            
            
            
            return cell
        }else if(dashBoardDataObj.menu_name ==  "Millet Diet For Cancer"){
            let cell: CommanTableCellTypeTwo = self.tableView.dequeueReusableCell(withIdentifier: "CommanTableCellTypeTwo") as! CommanTableCellTypeTwo
            cell.diseaseNametxt.text = "Type of aliment"
            cell.DictoctionTxt.text = "Dictoction Kashayas Diet"
            cell.milletProTxt.text = "Tags Keywords"
            cell.specialIntTXt.text = "Millet Protocol"
            
            var dataObj = CommanModel()
            if(filterArray.count > 0 ){
                dataObj = self.filterArray[indexPath.row]
            }else{
                dataObj = self.commanObjArray[indexPath.row]
            }
            
            
            //  let dataObj = self.commanObjArray[indexPath.row]
            cell.diseaseName.text = dataObj.Type_of_Ailment.htmlToString
            
            
         /*   cell.Dictoction.text = dataObj.dictoction_kashayas_juice_every_week.htmlToString
            
            cell.milletProtocol.text = dataObj.dictoction_kashayas_juice_afternoon_each_week.htmlToString
            cell.specialInstructionLbl.text = dataObj.milletProtocol.htmlToString*/
            
            
            cell.milletProWebView.delegate = nil
            cell.ductoctionWebView.delegate = nil
            cell.specialInstWebView.delegate = nil
            
            if(selectedIndex == indexPath){
                if(uiWebView1Height == 20)
                {
                    if(!dataObj.Dictoction_Kashayam_Diet.isBlank)
                    {
                        cell.ductoctionWebView.isHidden = false
                        cell.ductoctionWebView.loadHTMLString(dataObj.Dictoction_Kashayam_Diet, baseURL: nil)
                        
                        cell.ductoctionWebView.tag = indexPath.row + 1000
                        cell.ductoctionWebView.delegate = self
                        
                    }else{
                        cell.ductoctionWebView.isHidden = true
                    }
                    
                }else{
                    cell.ductoctionWebView.loadHTMLString(dataObj.Dictoction_Kashayam_Diet, baseURL: nil)
                    cell.ductoctionWebViewHeight.constant = uiWebView1Height
                    
                }
                
                
                
                if(uiWebView2Height == 20)
                {
                    if(!dataObj.Tags_Keywords.isBlank)
                    {
                        
                        cell.milletProWebView.isHidden = false
                        cell.milletProWebView.loadHTMLString(dataObj.Tags_Keywords, baseURL: nil)
                        cell.milletProWebView.tag = indexPath.row + 2000
                        cell.milletProWebView.delegate = self
                    }else{
                        cell.milletProWebView.isHidden = true
                    }
                }else{
                    cell.milletProWebView.loadHTMLString(dataObj.Tags_Keywords, baseURL: nil)
                    cell.milletProWebViewHeight.constant = uiWebView2Height
                    // cell.webViewHeight.constant = uiWebViewHeight
                }
                
                
                
                if(uiWebView3Height == 20)
                {
                    if(!dataObj.milletProtocol.isBlank)
                    {
                        cell.specialInstWebView.isHidden = false
                        cell.specialInstWebView.loadHTMLString(dataObj.milletProtocol, baseURL: nil)
                        
                        cell.specialInstWebView.tag = indexPath.row + 3000
                        cell.specialInstWebView.delegate = self
                    }else{
                        cell.specialInstWebView.isHidden = true
                    }
                }else{
                    cell.specialInstWebView.loadHTMLString(dataObj.milletProtocol, baseURL: nil)
                    cell.specialInstWebViewHeight.constant = uiWebView3Height
                }
                
                
                
                
                
                
            }
            
            
            
            if(selectedIndex == indexPath){
                cell.exapndImageView.image = #imageLiteral(resourceName: "ExpandedRed")
                
            }else{
                cell.exapndImageView.image = #imageLiteral(resourceName: "Expanded")
            }
            
            return cell
        }else{
            let cell: CommanTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CommanTableViewCell") as! CommanTableViewCell
            let dataObj = self.commanObjArray[indexPath.row]
            cell.coutLbl.text = dataObj.id + " "
            cell.txtValueLbl.text = dataObj.note.htmlToString
            
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
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        //let dataObj = self.commanObjArray[indexPath.row]
        
        var dataObj = CommanModel()
        if(filterArray.count > 0 && (filterArray.count > indexPath.row)){
            
            dataObj = self.filterArray[indexPath.row]
        }else{
            dataObj = self.commanObjArray[indexPath.row]
        }
        if(selectedIndex == indexPath){
            
            // let dataObj = self.commanObjArray[indexPath.row]
            
            /*  cell.diseaseName.text = dataObj.disease_name
             cell.Dictoction.text = dataObj.dictoction_kashayas_juice
             cell.milletProtocol.text = dataObj.milletProtocol
             cell.specialInstructionLbl.text = dataObj.specialInstruction
             
             */
            
            if(dashBoardDataObj.menu_name ==  "Millet Diet For Cancer"){
                
                let height = Common_Methods.heightForView(text: dataObj.cancer_type.isEmpty ? "-" : dataObj.cancer_type , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 120)
                
           /*     let height2 = Common_Methods.heightForView(text: dataObj.dictoction_kashayas_juice_afternoon_each_week.isEmpty ? "-" : dataObj.dictoction_kashayas_juice_afternoon_each_week.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
                
                let height3 = Common_Methods.heightForView(text: dataObj.dictoction_kashayas_juice_every_week.isEmpty ? "-" : dataObj.dictoction_kashayas_juice_every_week.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
                
                let height4 = Common_Methods.heightForView(text: dataObj.milletProtocol.isEmpty ? "" : dataObj.milletProtocol.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
 */
                // let deviceType = UIDevice.current.modelName
                
                
                return height + uiWebView1Height + uiWebView2Height + uiWebView3Height + 200
                
                
                
            }else{
                
                
                
                let height = Common_Methods.heightForView(text: dataObj.disease_name.isEmpty ? "-" : dataObj.disease_name , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 120)
                
            //    let height2 = Common_Methods.heightForView(text: dataObj.dictoction_kashayas_juice.isEmpty ? "-" : dataObj.dictoction_kashayas_juice.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
                
            //    let height3 = Common_Methods.heightForView(text: dataObj.milletProtocol.isEmpty ? "-" : dataObj.milletProtocol.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
                
           //     let height4 = Common_Methods.heightForView(text: dataObj.specialInstruction.isEmpty ? "" : dataObj.specialInstruction.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
                
             
                    return height + uiWebView1Height + uiWebView2Height + uiWebView3Height + 190
                
            }
            
            
            
        }else{
            if(dashBoardDataObj.menu_name ==  "Millet Diet For Cancer"){
                
                let height = Common_Methods.heightForView(text: dataObj.Type_of_Ailment.isEmpty ? "-" : dataObj.Type_of_Ailment.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 100)
                return 50 + height
            }else if(dashBoardDataObj.menu_name ==  "Millet Diet For Diseases"){
                if(indexPath.row == 17)
                {
                   // print(indexPath)
                }
                let height = Common_Methods.heightForView(text: dataObj.Type_of_Ailment.isEmpty ? "-" : dataObj.Type_of_Ailment , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 100)
                return 50 + height
            }
            
        }
        return UITableView.automaticDimension 
    }
    
    
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
            let index = NSIndexPath(row: self.selectedIndex.row, section: 0)
            self.tableView.scrollToRow(at: index as IndexPath, at: .top, animated: false)
        })*/
     //
        
    }
    /*   func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
     if (selectedIndex.contains(indexPath)){
     // return UITableView.automaticDimension
     } else {
     return 70
     }
     }*/
}
