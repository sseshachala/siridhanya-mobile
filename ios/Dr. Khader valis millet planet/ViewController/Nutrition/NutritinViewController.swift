//
//  NutritinViewController.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 14/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class NutritinViewController: UIViewController {
    
    @IBOutlet weak var nutritionTop: NSLayoutConstraint!
    
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var noDataFound: UILabel!
    var selectedIndex  = IndexPath()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    var dashBoardDataObj = DashBoardModel()
    var nutritionArray = [NUtritionModel]()
    
    
    fileprivate var uiWebView1Height: CGFloat = 20
    fileprivate var uiWebView2Height: CGFloat = 20
    fileprivate var uiWebView3Height: CGFloat = 20
    fileprivate var uiWebView4Height: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = dashBoardDataObj.menu_name
        noDataFound.isHidden = true
        self.getApiValue()
        // Do any additional setup after loading the view.
    }
    
    func getApiValue(){
        
        WebService.getAPIWith(api: dashBoardDataObj.service_name, jsonString: [:], header: [:], centerUrl: "", msg: "Loading...", success: { (result, flag) in
            //print(result)
            if let data = result as? [AnyObject]{
                for dict in data{
                    
                    var objDashBoardModel = NUtritionModel()
                    
                    objDashBoardModel = objDashBoardModel.getNUtritionModelWith(dict: dict as! [String : AnyObject])
                    self.nutritionArray.append(objDashBoardModel)
                    
                }
            }
            if(self.nutritionArray.count > 0){
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
    
}
extension NutritinViewController : UITableViewDelegate , UITableViewDataSource, UIWebViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutritionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NutritoinCell = self.tableView.dequeueReusableCell(withIdentifier: "NutritoinCell") as! NutritoinCell
        
        let objData = self.nutritionArray[indexPath.row]
        
        
     //   cell.alternativeLBl.text = objData.alternative_names.htmlToString

        cell.name.text = objData.name.htmlToString
        cell.scientificName.text = objData.scientific_name.htmlToString
      //  cell.descriptions.text = objData.Description.htmlToString
        if(objData.Description.isBlank){
            cell.descriptionLbl.text = ""
          //  cell.userTop.constant = -20
        }else{
            cell.descriptionLbl.text = "Description"
          //  cell.userTop.constant = 10
        }
        
        if(objData.uses.isBlank){
            cell.userFixLbl.text = ""
         //   cell.nutrationTop.constant = -20
        }else{
            cell.userFixLbl.text = "Uses"
           // cell.nutrationTop.constant = 10
        }
    //    cell.milletType.text = objData.millet_type.htmlToString
    //    cell.user.text = objData.uses.htmlToString
        cell.descriptionWebView.delegate = nil
        cell.userWebView.delegate = nil
        cell.milletTypeWebView.delegate = nil
        cell.alternativeWebView.delegate = nil
        
        if(selectedIndex == indexPath){
            if(uiWebView1Height == 20)
            {
                if(!objData.Description.isBlank)
                {
                    cell.descriptionWebView.isHidden = false
                    cell.descriptionWebView.loadHTMLString(objData.Description, baseURL: nil)
                    
                    cell.descriptionWebView.tag = indexPath.row + 1000
                    cell.descriptionWebView.delegate = self
                    
                }else{
                    
                    cell.descriptionWebView.isHidden = true
                }
                
            }else{
                cell.descriptionWebView.loadHTMLString(objData.Description, baseURL: nil)
                cell.descriptionWebViewHeight.constant = uiWebView1Height
                
            }
            
            
            
            if(uiWebView2Height == 20)
            {
                if(!objData.alternative_names.isBlank)
                {
                    
                    cell.alternativeWebView.isHidden = false
                    cell.alternativeWebView.loadHTMLString(objData.alternative_names, baseURL: nil)
                    cell.alternativeWebView.tag = indexPath.row + 2000
                    cell.alternativeWebView.delegate = self
                }else{
                    cell.alternativeWebView.isHidden = true
                }
            }else{
                cell.alternativeWebView.loadHTMLString(objData.alternative_names, baseURL: nil)
                cell.alternativeWebViewHeight.constant = uiWebView2Height
               
            }
            
            
            
            if(uiWebView3Height == 20)
            {
                if(!objData.millet_type.isBlank)
                {
                    cell.milletTypeWebView.isHidden = false
                    cell.milletTypeWebView.loadHTMLString(objData.millet_type, baseURL: nil)
                    
                    cell.milletTypeWebView.tag = indexPath.row + 3000
                    cell.milletTypeWebView.delegate = self
                }else{
                    cell.milletTypeWebView.isHidden = true
                }
            }else{
                cell.milletTypeWebView.loadHTMLString(objData.millet_type, baseURL: nil)
                cell.millettypeWebViewHeight.constant = uiWebView3Height
            }
            
            if(uiWebView4Height == 20)
            {
                if(!objData.uses.isBlank)
                {
                    cell.userWebView.isHidden = false
                    cell.userWebView.loadHTMLString(objData.uses, baseURL: nil)
                    
                    cell.userWebView.tag = indexPath.row + 4000
                    cell.userWebView.delegate = self
                }else{
                    cell.userWebView.isHidden = true
                }
            }else{
                cell.userWebView.loadHTMLString(objData.uses, baseURL: nil)
                
                cell.userWebViewHeight.constant = uiWebView4Height
            }

            
            
            
            
            
            
        }
        
        
        
        
        
        cell.nutrition.text = objData.nutrition
        cell.val.text = objData.nutritionVal
        
        if(selectedIndex == indexPath){
            cell.exapndImageView.image = #imageLiteral(resourceName: "ExpandedRed")
            
        }else{
            cell.exapndImageView.image = #imageLiteral(resourceName: "Expanded")
        }
        
        
        
        if(objData.alternative_names.isBlank){
            cell.alterNativeFixLbl.text = ""
          //  cell.milletTypeTop.constant = -20
        }else{
            cell.alterNativeFixLbl.text = "Alternative Names"
          //  cell.milletTypeTop.constant = 10
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        uiWebView1Height = 20
        uiWebView2Height = 20
        uiWebView3Height = 20
        uiWebView4Height = 20
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(selectedIndex == indexPath){
            let indx = NSIndexPath(row: -1, section: 0)
            selectedIndex = indx as IndexPath
        }else{
            selectedIndex = indexPath
        }
        //tableView.scrollToRow(at: indexPath, at: .none, animated: false)
        
       
       // tableView.reloadRows(at: [indexPath], with: .none)
        
        //tableView.endUpdates()
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataObj = self.nutritionArray[indexPath.row]
        if(selectedIndex == indexPath){
            
           // let dataObj = self.nutritionArray[indexPath.row]
            
   //         var height7 = Common_Methods.heightForView(text: dataObj.alternative_names.isEmpty ? "-" : dataObj.alternative_names.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 241)
            
            
        let height = Common_Methods.heightForView(text: dataObj.name.isEmpty ? "-" : dataObj.name , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 241)
        
        let height2 = Common_Methods.heightForView(text: dataObj.scientific_name.isEmpty ? "-" : dataObj.scientific_name.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 245)
        
            var final = height2
            
            if (height > height2){
                final = height
            }
            
     //   let height3 = Common_Methods.heightForView(text: dataObj.Description.isEmpty ? "-" : dataObj.Description.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
        
  //      let height4 = Common_Methods.heightForView(text: dataObj.millet_type.isEmpty ? "" : dataObj.millet_type.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
            
//            let height5 = Common_Methods.heightForView(text: dataObj.uses.isEmpty ? "" : dataObj.uses.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
            
             let height6 = Common_Methods.heightForView(text: dataObj.nutritionVal.isEmpty ? "" : dataObj.nutritionVal , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 173)
            
            var ipadPlusHeight = 0
            
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
            {
                ipadPlusHeight = 50
            }
            
      //      height7 = height7 + CGFloat(ipadPlusHeight)
            
            if(dataObj.Description.isBlank && dataObj.uses.isBlank && dataObj.alternative_names.isBlank){
                
        return final + uiWebView1Height + uiWebView2Height + uiWebView4Height + uiWebView3Height + height6 + 200
                
            }else if(dataObj.Description.isBlank && dataObj.uses.isBlank ){
                
                return final + uiWebView1Height + uiWebView2Height + uiWebView4Height + uiWebView3Height + height6   + 220
                
            }else if(dataObj.Description.isBlank && dataObj.alternative_names.isBlank ){
                
                return final + uiWebView1Height + uiWebView2Height + uiWebView4Height + uiWebView3Height + height6  + 220
                
            }else if(dataObj.uses.isBlank && dataObj.alternative_names.isBlank ){
                
                return final + uiWebView1Height + uiWebView2Height + uiWebView4Height + uiWebView3Height  + height6 + 220
                
            }else if(dataObj.Description.isBlank){
                 return final + uiWebView1Height + uiWebView2Height + uiWebView4Height + uiWebView3Height + height6 + 250
                
            }else if(dataObj.uses.isBlank){
                return final + uiWebView1Height + uiWebView2Height + uiWebView4Height + uiWebView3Height  + height6 + 250
                
            }else if(dataObj.alternative_names.isBlank){
                return final + uiWebView1Height + uiWebView2Height + uiWebView4Height + uiWebView3Height  + height6  + 250
            }
            
            
            return final + uiWebView1Height + uiWebView2Height + uiWebView4Height + uiWebView3Height  + height6  + 270
        }
        
        let height = Common_Methods.heightForView(text: dataObj.name.isEmpty ? "-" : dataObj.name , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 241)
        
        let height2 = Common_Methods.heightForView(text: dataObj.scientific_name.isEmpty ? "-" : dataObj.scientific_name , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 245)
        var final = height2
        
        if (height > height2){
            final = height
        }
        return 50 + final
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
        }else if(webView.tag == selectedIndex.row + 4000){
            self.uiWebView4Height = webView.documentHeight
        }
        
        self.tableView.reloadData()
        
       /* DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
            let index = NSIndexPath(row: self.selectedIndex.row, section: 0)
            self.tableView.scrollToRow(at: index as IndexPath, at: .top, animated: false)
        })*/
        //
        
    }
    
}
