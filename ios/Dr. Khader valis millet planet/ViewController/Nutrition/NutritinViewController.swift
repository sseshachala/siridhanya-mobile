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
    var selectedIndex  = [IndexPath]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    var dashBoardDataObj = DashBoardModel()
    var nutritionArray = [NUtritionModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = dashBoardDataObj.menu_name
        noDataFound.isHidden = true
        self.getApiValue()
        // Do any additional setup after loading the view.
    }
    
    func getApiValue(){
        
        WebService.getAPIWith(api: dashBoardDataObj.service_name, jsonString: [:], header: [:], centerUrl: "", msg: "Loading...", success: { (result, flag) in
            print(result)
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
extension NutritinViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutritionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NutritoinCell = self.tableView.dequeueReusableCell(withIdentifier: "NutritoinCell") as! NutritoinCell
        
        let objData = self.nutritionArray[indexPath.row]
        cell.alternativeLBl.text = objData.alternative_names.htmlToString

        cell.name.text = objData.name
        cell.scientificName.text = objData.scientific_name.htmlToString
        cell.descriptions.text = objData.Description.htmlToString
        if(objData.Description.isBlank){
            cell.descriptionLbl.text = ""
            cell.userTop.constant = -20
        }else{
            cell.descriptionLbl.text = "Description"
            cell.userTop.constant = 10
        }
        
        if(objData.uses.isBlank){
            cell.userFixLbl.text = ""
            cell.nutrationTop.constant = -20
        }else{
            cell.userFixLbl.text = "Uses"
            cell.nutrationTop.constant = 10
        }
        cell.milletType.text = objData.millet_type.htmlToString
        cell.user.text = objData.uses.htmlToString
        cell.nutrition.text = objData.nutrition
        cell.val.text = objData.nutritionVal
        
        if(selectedIndex.contains(indexPath)){
            cell.exapndImageView.image = #imageLiteral(resourceName: "ExpandedRed")
            
        }else{
            cell.exapndImageView.image = #imageLiteral(resourceName: "Expanded")
        }
        
        
        
        if(objData.alternative_names.isBlank){
            cell.alterNativeFixLbl.text = ""
            cell.milletTypeTop.constant = -20
        }else{
            cell.alterNativeFixLbl.text = "Alternative Names"
            cell.milletTypeTop.constant = 10
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
        let dataObj = self.nutritionArray[indexPath.row]
        if(selectedIndex.contains(indexPath)){
            
           // let dataObj = self.nutritionArray[indexPath.row]
            
            var height7 = Common_Methods.heightForView(text: dataObj.alternative_names.isEmpty ? "-" : dataObj.alternative_names.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 241)
            
            
        let height = Common_Methods.heightForView(text: dataObj.name.isEmpty ? "-" : dataObj.name , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 241)
        
        let height2 = Common_Methods.heightForView(text: dataObj.scientific_name.isEmpty ? "-" : dataObj.scientific_name.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 245)
        
            var final = height2
            
            if (height > height2){
                final = height
            }
            
        let height3 = Common_Methods.heightForView(text: dataObj.Description.isEmpty ? "-" : dataObj.Description.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
        
        let height4 = Common_Methods.heightForView(text: dataObj.millet_type.isEmpty ? "" : dataObj.millet_type.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
            
            let height5 = Common_Methods.heightForView(text: dataObj.uses.isEmpty ? "" : dataObj.uses.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
            
             let height6 = Common_Methods.heightForView(text: dataObj.nutritionVal.isEmpty ? "" : dataObj.nutritionVal , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 173)
            
            var ipadPlusHeight = 0
            
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
            {
                ipadPlusHeight = 50
            }
            
            height7 = height7 + CGFloat(ipadPlusHeight)
            
            if(dataObj.Description.isBlank && dataObj.uses.isBlank && dataObj.alternative_names.isBlank){
                
        return final + height3 + height4 + height5 + height6  + height7 + 160
                
            }else if(dataObj.Description.isBlank && dataObj.uses.isBlank ){
                
                return final + height3 + height4 + height5 + height6  + height7 + 180
                
            }else if(dataObj.Description.isBlank && dataObj.alternative_names.isBlank ){
                
                return final + height3 + height4 + height5 + height6  + height7 + 180
                
            }else if(dataObj.uses.isBlank && dataObj.alternative_names.isBlank ){
                
                return final + height3 + height4 + height5 + height6  + height7 + 180
                
            }else if(dataObj.Description.isBlank){
                 return final + height3 + height4 + height5 + height6 +  height7 + 210
                
            }else if(dataObj.uses.isBlank){
                return final + height3 + height4 + height5 + height6 +  height7 + 210
                
            }else if(dataObj.alternative_names.isBlank){
                return final + height3 + height4 + height5 + height6 +  height7 + 210
            }
            
            
            return final + height3 + height4 + height5 + height6 + height7 + 230
        }
        
        let height = Common_Methods.heightForView(text: dataObj.name.isEmpty ? "-" : dataObj.name , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 241)
        
        let height2 = Common_Methods.heightForView(text: dataObj.scientific_name.isEmpty ? "-" : dataObj.scientific_name , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 245)
        var final = height2
        
        if (height > height2){
            final = height
        }
        return 50 + final
    }
    
    
}
