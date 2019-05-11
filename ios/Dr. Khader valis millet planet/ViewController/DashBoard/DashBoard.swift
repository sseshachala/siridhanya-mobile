//
//  DashBoard.swift
//  Dr. Khader vali's Millet Planet
//
//  Created by Sunny on 13/04/19.
//

import UIKit
import SDWebImage
import SafariServices

class DashBoard: UIViewController {
    @IBOutlet weak var noDataFound: UILabel!
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    var dashBoardDataArray = [DashBoardModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDataFound.isHidden = true
        if UserDefaults.standard.value(forKey: kDashBoardData) != nil{
            let result = self.unArchiveData()
            
            for dict in result{
                
                var objDashBoardModel = DashBoardModel()
                objDashBoardModel = objDashBoardModel.getDashBoardWith(dict: dict as! [String : AnyObject])
                self.dashBoardDataArray.append(objDashBoardModel)
                
            }
            self.nodataFoundLblShowHide()
            self.collectionVIew.reloadData()
        }else{
            
            self.getDashBoardData()
        }
        // Do any additional setup after loading the view.
    }
    func nodataFoundLblShowHide(){
        if(self.dashBoardDataArray.count > 0){
            self.collectionVIew.isHidden = false
            self.noDataFound.isHidden = true
        }else{
            self.collectionVIew.isHidden = true
            self.noDataFound.isHidden = false
        }
    }
    func getDashBoardData(){
        
        
        
        
        WebService.getAPIWith(api: kMenu, jsonString: [:], header: [:], centerUrl: "", msg: "Loading dashboard data.", success: { (result, flag) in
            //print(result)
            
            if let data = result as? [AnyObject]{
                self.dashBoardDataArray = []
                for dict in data{
                    
                    var objDashBoardModel = DashBoardModel()
                    objDashBoardModel = objDashBoardModel.getDashBoardWith(dict: dict as! [String : AnyObject])
                    self.dashBoardDataArray.append(objDashBoardModel)
                    
                }
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: data)
                UserDefaults.standard.set(encodedData, forKey: kDashBoardData)
                
                UserDefaults.standard.synchronize()
                
                
                
                
                
                
                
            }
            
            self.nodataFoundLblShowHide()
            
            self.collectionVIew.reloadData()
            
        }) { (error) in
            print(error)
        }
    }
    
    func unArchiveData() -> [AnyObject]{
        
        let unarchivedObject = UserDefaults.standard.data(forKey: kDashBoardData)
        
        do {
            guard let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedObject!) as? [AnyObject] else {
                return []
                //fatalError("loadWidgetDataArray - Can't get Array")
            }
            return array
        } catch {
            return []
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
    @IBAction func refreshButtonPressed(_ sender: Any) {
        
        self.getDashBoardData()
    }
    
}
extension DashBoard: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dashBoardDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardCell", for: indexPath as IndexPath) as! DashBoardCell
        let objData = self.dashBoardDataArray[indexPath.row]
        
        cell.titleLbl.text = objData.menu_name
        cell.imageView.sd_setImage(with: NSURL(string: objData.icon )! as URL, placeholderImage: #imageLiteral(resourceName: "smallLogoWithBack"), options: .retryFailed, completed: nil)
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let objData = self.dashBoardDataArray[indexPath.row]
        if(objData.action == "json"){
            if(objData.menu_name == "About Doctor Khader Vali"){
                let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
                
                aboutVC.dashBoardDataObj = objData
                
                self.navigationController?.pushViewController(aboutVC, animated: true)
            }else if(objData.menu_name == "Find Millets"){
                let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "NutritinViewController") as! NutritinViewController
                
                aboutVC.dashBoardDataObj = objData
                
                self.navigationController?.pushViewController(aboutVC, animated: true)
            }else if(objData.menu_name == "Millet FAQ"){
                let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "FAQ") as! FAQ
                
                aboutVC.dashBoardDataObj = objData
                
                self.navigationController?.pushViewController(aboutVC, animated: true)
            }else if(objData.menu_name == "Lifestyle" || objData.menu_name == "Kids Instructions"){
                let lifeStyleViewController = self.storyboard?.instantiateViewController(withIdentifier: "LifeStyleViewController") as! LifeStyleViewController
                
                lifeStyleViewController.dashBoardDataObj = objData
                
                self.navigationController?.pushViewController(lifeStyleViewController, animated: true)
            }else if(objData.menu_name == "Search"){
                let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "UniversalSearchViewController") as! UniversalSearchViewController
                
                aboutVC.dashBoardDataObj = objData
                
                self.navigationController?.pushViewController(aboutVC, animated: true)
            }else{
                let commanTV = self.storyboard?.instantiateViewController(withIdentifier: "CommanTableViewController") as! CommanTableViewController
                
                commanTV.dashBoardDataObj = objData
                
                self.navigationController?.pushViewController(commanTV, animated: true)
            }
            
        }else if(objData.action == "global"){
            let commanTV = self.storyboard?.instantiateViewController(withIdentifier: "OthersViewController") as! OthersViewController
            
            commanTV.dashBoardDataObj = objData
            
            self.navigationController?.pushViewController(commanTV, animated: true)
        }else{
            self.openSafariView(obj: objData)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        //let objData = self.dashBoardDataArray[indexPath.row]
        
        
        let HW = Int((self.view.frame.width - 22) / 3)
        
     //   print(((self.view.frame.width - 22) / 3))
        
        
        return CGSize(width: HW, height: HW + 50)
        
    }
    
    func openSafariView(obj : DashBoardModel){
        //obj
        
        guard let url = URL(string: obj.service_name) else { return }
        UIApplication.shared.open(url)
        /* let safariVC = SFSafariViewController(url: NSURL(string: obj.service_name)! as URL)
         self.present(safariVC, animated: true, completion: nil)
         safariVC.delegate = self*/
    }
}
extension DashBoard : SFSafariViewControllerDelegate{
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
