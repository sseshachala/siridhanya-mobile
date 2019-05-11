//
//  AboutViewController.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 14/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
   
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    var aboutViewArray = [AboutViewModel]()
    var dashBoardDataObj = DashBoardModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = dashBoardDataObj.menu_name
        self.getAboutData()
        // Do any additional setup after loading the view.
    }
    func getAboutData(){
        
        WebService.getAPIWith(api: dashBoardDataObj.service_name, jsonString: [:], header: [:], centerUrl: "", msg: "Loading...", success: { (result, flag) in
            //print(result)
            if let data = result as? [AnyObject]{
                for dict in data{
                    
                    var objDashBoardModel = AboutViewModel()
                    objDashBoardModel = objDashBoardModel.getAboutWith(dict: dict as! [String : AnyObject])
                    self.aboutViewArray.append(objDashBoardModel)
                    
                }
                if(self.aboutViewArray.count > 0){
                    let obj = self.aboutViewArray[0]
                    self.webView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    self.webView.loadHTMLString(obj.about, baseURL: nil)
                  //  self.aboutTxtView.text = obj.about
                    self.userImageView.sd_setImage(with: NSURL(string: obj.image )! as URL, placeholderImage: #imageLiteral(resourceName: "smallLogoWithBack"), options: .retryFailed, completed: nil)
                }
                
                
            }
            
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
