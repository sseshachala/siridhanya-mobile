//
//  CommanTableViewController.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 14/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class CommanTableViewController: UIViewController {
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
        self.getApiValue(url: dashBoardDataObj.service_name)
        // Do any additional setup after loading the view.
    }
    
    func getApiValue(url : String){
        
        WebService.getAPIWith(api: url, jsonString: [:], header: [:], centerUrl: "", msg: "Loading...", success: { (result, flag) in
            print(result)
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
extension CommanTableViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.commanObjArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(dashBoardDataObj.menu_name == "Millet Diet For Diseases" )
        {
            let cell: CommanTableCellTypeTwo = self.tableView.dequeueReusableCell(withIdentifier: "CommanTableCellTypeTwo") as! CommanTableCellTypeTwo
            let dataObj = self.commanObjArray[indexPath.row]
            cell.diseaseName.text = dataObj.disease_name
            
            
            cell.Dictoction.text = dataObj.dictoction_kashayas_juice.htmlToString
            cell.milletProtocol.text = dataObj.milletProtocol.htmlToString
            cell.specialInstructionLbl.text = dataObj.specialInstruction.htmlToString
            if(dataObj.specialInstruction.isEmpty){
                cell.specialINstructiontxt.text = ""
            }else{
                cell.specialINstructiontxt.text = "Special Instruction"
            }
            if(selectedIndex.contains(indexPath)){
                cell.exapndImageView.image = #imageLiteral(resourceName: "ExpandedRed")
                
            }else{
                cell.exapndImageView.image = #imageLiteral(resourceName: "Expanded")
            }
            
            return cell
        }else if(dashBoardDataObj.menu_name ==  "Millet Diet For Cancer"){
            let cell: CommanTableCellTypeTwo = self.tableView.dequeueReusableCell(withIdentifier: "CommanTableCellTypeTwo") as! CommanTableCellTypeTwo
            cell.diseaseNametxt.text = "Cancer type"
            cell.DictoctionTxt.text = "Dictoction Kashayas Juice Every Week"
            cell.milletProTxt.text = "Dictoction Kashayas Juice Afternoon Each Week"
            cell.specialIntTXt.text = "Millet Protocol"
            
            let dataObj = self.commanObjArray[indexPath.row]
            cell.diseaseName.text = dataObj.cancer_type
            cell.Dictoction.text = dataObj.dictoction_kashayas_juice_every_week.htmlToString
            
            cell.milletProtocol.text = dataObj.dictoction_kashayas_juice_afternoon_each_week.htmlToString
            cell.specialInstructionLbl.text = dataObj.milletProtocol.htmlToString
            
            if(selectedIndex.contains(indexPath)){
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
        
        if(dashBoardDataObj.menu_name ==  "Kids Instructions" || dashBoardDataObj.menu_name ==  "Lifestyle"){
            return
        }
        if(selectedIndex.contains(indexPath)){
            let indx = selectedIndex.firstIndex(of: indexPath)
            selectedIndex.remove(at: indx!)
        }else{
            selectedIndex.append(indexPath)
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        
        tableView.endUpdates()
        // self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
         let dataObj = self.commanObjArray[indexPath.row]
        
        if(selectedIndex.contains(indexPath)){
            
           // let dataObj = self.commanObjArray[indexPath.row]
            
            /*  cell.diseaseName.text = dataObj.disease_name
             cell.Dictoction.text = dataObj.dictoction_kashayas_juice
             cell.milletProtocol.text = dataObj.milletProtocol
             cell.specialInstructionLbl.text = dataObj.specialInstruction
             
             */
            
            if(dashBoardDataObj.menu_name ==  "Millet Diet For Cancer"){
                
                let height = Common_Methods.heightForView(text: dataObj.cancer_type.isEmpty ? "-" : dataObj.cancer_type , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 120)
                
                let height2 = Common_Methods.heightForView(text: dataObj.dictoction_kashayas_juice_afternoon_each_week.isEmpty ? "-" : dataObj.dictoction_kashayas_juice_afternoon_each_week.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
                
                let height3 = Common_Methods.heightForView(text: dataObj.dictoction_kashayas_juice_every_week.isEmpty ? "-" : dataObj.dictoction_kashayas_juice_every_week.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
                
                let height4 = Common_Methods.heightForView(text: dataObj.milletProtocol.isEmpty ? "" : dataObj.milletProtocol.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
               // let deviceType = UIDevice.current.modelName
                
                
                return height + height4 + height2 + height3 + 200
                
                
                
            }else{
                
                
                
                let height = Common_Methods.heightForView(text: dataObj.disease_name.isEmpty ? "-" : dataObj.disease_name , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 120)
                
                let height2 = Common_Methods.heightForView(text: dataObj.dictoction_kashayas_juice.isEmpty ? "-" : dataObj.dictoction_kashayas_juice.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
                
                let height3 = Common_Methods.heightForView(text: dataObj.milletProtocol.isEmpty ? "-" : dataObj.milletProtocol.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
                
                let height4 = Common_Methods.heightForView(text: dataObj.specialInstruction.isEmpty ? "" : dataObj.specialInstruction.htmlToString , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 50)
                
                if(dataObj.specialInstruction.isEmpty)
                {
                    return height + height4 + height2 + height3 + 150
                }else{
                    return height + height4 + height2 + height3 + 190
                }
            }
            
            
            
        }else{
            if(dashBoardDataObj.menu_name ==  "Millet Diet For Cancer"){
                
                let height = Common_Methods.heightForView(text: dataObj.cancer_type.isEmpty ? "-" : dataObj.cancer_type , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 120)
              return 50 + height
            }else{
                 let height = Common_Methods.heightForView(text: dataObj.disease_name.isEmpty ? "-" : dataObj.disease_name , font: UIFont(name: "Roboto-Regular", size:17.0)!, width: self.view.frame.width - 120)
                return 50 + height
            }
            
        }
    }
    
    /*   func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
     if (selectedIndex.contains(indexPath)){
     // return UITableView.automaticDimension
     } else {
     return 70
     }
     }*/
}
