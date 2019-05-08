//
//  WebService.swift
//  Dr. Khader vali's Millet Planet
//
//  Created by Sunny on 13/04/19.
//

import Foundation

import Alamofire

class WebService : NSObject
{
   
    
    
    
    
    class func sessionExpirealert(message: String)
    {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        
        if let _ : UIAlertController = topVC as? UIAlertController {
            // nothing to do , AlertController already active
            // ...
            print("Alert not necessary, already on the screen !")
            
        } else {
            
            let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
            
            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                //MoveToLogin()
            }))
            
            
            topVC?.present(alertView, animated: true, completion: nil)
            
            print("Alert comes up via another presented VC, e.g. a PopOver")
        }
        
        
    }
    
    
    
    class func alertMsg(message: String, email: String)
    {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        
        
        
        if let _ : UIAlertController = topVC as? UIAlertController {
            // nothing to do , AlertController already active
            // ...
            print("Alert not necessary, already on the screen !")
            
        } else {
            let actionSheetController: UIAlertController = UIAlertController(title: KAppName, message: message , preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                //Call Service
                
            }
            
            actionSheetController.addAction(okAction)
            
            topVC?.present(actionSheetController, animated: true, completion: nil)
        }
        /*  let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let objMainViewController : LoginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
         
         let objMainViewController1 : ForgotPasswordVC = mainStoryboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
         
         if((UIApplication.shared.keyWindow?.visibleViewController)!.isKind(of: objMainViewController.classForCoder) && !email.isEmpty)
         {
         let actionSheetController: UIAlertController = UIAlertController(title: KAppName, message: message , preferredStyle: .alert)
         let okAction: UIAlertAction = UIAlertAction(title: "Resend verification link", style: .default) { action -> Void in
         //Call Service
         self.ResendVerificationLink(email: email)
         }
         let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
         
         }
         actionSheetController.addAction(okAction)
         actionSheetController.addAction(cancelAction)
         topVC?.present(actionSheetController, animated: true, completion: nil)
         }
         else if((UIApplication.shared.keyWindow?.visibleViewController)!.isKind(of: objMainViewController1.classForCoder) && !email.isEmpty)
         {
         let actionSheetController: UIAlertController = UIAlertController(title: KAppName, message: message , preferredStyle: .alert)
         let okAction: UIAlertAction = UIAlertAction(title: "Resend verification link", style: .default) { action -> Void in
         //Call Service
         self.ResendVerificationLink(email: email)
         }
         let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
         
         }
         actionSheetController.addAction(okAction)
         actionSheetController.addAction(cancelAction)
         topVC?.present(actionSheetController, animated: true, completion: nil)
         }
         else if((UIApplication.shared.keyWindow?.visibleViewController)!.isKind(of: objMainViewController.classForCoder) && email == "")
         {
         let actionSheetController: UIAlertController = UIAlertController(title: KAppName, message: message   , preferredStyle: .alert)
         let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
         //Move to Login
         _ = topVC?.navigationController?.popViewController(animated: true)
         }
         actionSheetController.addAction(cancelAction)
         topVC?.present(actionSheetController, animated: true, completion: nil)
         }
         else
         {
         //topVC?.navigationController?.setViewControllers([objMainViewController], animated: true)
         let alertView = UIAlertController(title: KAppName, message: message, preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         
         topVC?.present(alertView, animated: true, completion: nil)
         }*/
    }
    
    //MARK: <POST REQUEST METHOD>
    class func postAPI(api:String,jsonString:[String: AnyObject], header: HTTPHeaders , centerUrl : String, msg : String ,success: @escaping CompletionHandler,failure: @escaping(NSError)  -> Void){
        
        let apiString = api as String
      //  print(apiString)
        
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        DispatchQueue.main.async {
            if(!msg.isBlank)
            {
                Common_Methods.showHUD(with: msg)
            }
            
        }
        
        let headers = [
            "accept": "application/json",
            "content-type": "application/x-www-form-urlencoded; charset=utf-8",
            "cache-control": "no-cache"
        ]
        
        
        
      
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 620
        
        manager.request(apiString, method: HTTPMethod.post, parameters: jsonString, headers: headers)
            .validate(statusCode: 200..<500)
            .responseJSON { (result) in
                switch result.result {
                case .success:
                    Common_Methods.hideHUD()
                    if let json = result.value {
                        Common_Methods.hideHUD()
                        success(json as AnyObject, true)
                        
                    } else {
                        Common_Methods.hideHUD()
                        success(result.value as AnyObject, false)
                    }
                    break
                case .failure(let error):
                    Common_Methods.hideHUD()
                    
                    if (result.result.error?.localizedDescription.contains(KInternetOffline))!{
                        //error.localizedDescription
                        let alert = UIAlertController.init(title: KAppName, message: error.localizedDescription , preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { action in
                            
                        }))
                        
                        
                        
                        if  topVC?.presentedViewController == nil {
                            //------Alert not necessary, already on the screen !----
                            if let _ : UIAlertController = topVC as? UIAlertController {
                                // nothing to do , AlertController already active
                                // ...
                                print("Alert not necessary, already on the screen !")
                                
                            }else{
                                topVC?.present(alert, animated: true, completion: nil)
                            }
                        } else{
                            /* topVC?.dismiss(animated: true) { () -> Void in
                             topVC?.present(alert, animated: true, completion: nil)
                             }*/
                        }
                        
                        
                        
                    }
                    else if error.localizedDescription.contains(kJSONserializError){
                        let alert = UIAlertController.init(title: KAppName, message: KServerNotresponding , preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { action in
                            
                        }))
                        topVC?.present(alert, animated: true, completion: nil)
                    }
                    else{
                        let alert = UIAlertController.init(title: KAppName, message: error.localizedDescription , preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { action in
                            
                        }))
                        topVC?.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    failure(error as NSError)
                    break
                }
        }
        
        
    }
    
    
    //MARK: <GET REQUEST METHOD>
  
    class func getAPIWith(api:String,jsonString:[String: AnyObject], header: HTTPHeaders , centerUrl :  String, msg : String,success: @escaping CompletionHandler ,failure: @escaping(NSError)  -> Void){
        
        let apiString =  (api as String)
        
        
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        
        DispatchQueue.main.async {
            Common_Methods.showHUD(with: msg)
        }
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 220
      //  manager.session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        manager.request(apiString, method: HTTPMethod.get, parameters: jsonString, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON { (result) in
                switch result.result {
                case .success:
                    Common_Methods.hideHUD()
                    if let json = result.value {
                        Common_Methods.hideHUD()
                        success(json as AnyObject, true)
                        
                    } else {
                        Common_Methods.hideHUD()
                        success(result.value as AnyObject, false)
                    }
                    break
                case .failure(let error):
                    Common_Methods.hideHUD()
                    
                    if (result.result.error?.localizedDescription.contains(KInternetOffline))!{
                        
                        let alert = UIAlertController.init(title: KAppName, message: error.localizedDescription , preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { action in
                            
                        }))
                      
                        
                        
                        if  topVC?.presentedViewController == nil {
                            //------Alert not necessary, already on the screen !----
                            if let _ : UIAlertController = topVC as? UIAlertController {
                                // nothing to do , AlertController already active
                                // ...
                                print("Alert not necessary, already on the screen !")
                                
                            }else{
                                topVC?.present(alert, animated: true, completion: nil)
                            }
                        } else{
                            /* topVC?.dismiss(animated: true) { () -> Void in
                             topVC?.present(alert, animated: true, completion: nil)
                             }*/
                        }
                        
                        
                        
                    }
                    else if error.localizedDescription.contains(kJSONserializError){
                        let alert = UIAlertController.init(title: KAppName, message: KServerNotresponding , preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { action in
                            
                        }))
                        topVC?.present(alert, animated: true, completion: nil)
                    }
                    else{
                        let alert = UIAlertController.init(title: KAppName, message: error.localizedDescription , preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { action in
                            
                        }))
                        topVC?.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    failure(error as NSError)
                    break
                }
                
        }
        
    }
    
    
   
    
    
}


extension UIWindow {
    /// Returns the currently visible view controller if any reachable within the window.
    public var visibleViewController: UIViewController? {
        return UIWindow.visibleViewController(from: rootViewController)
    }
    
    /// Recursively follows navigation controllers, tab bar controllers and modal presented view controllers starting
    /// from the given view controller to find the currently visible view controller.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to start the recursive search from.
    /// - Returns: The view controller that is most probably visible on screen right now.
    public static func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        switch viewController {
        case let navigationController as UINavigationController:
            return UIWindow.visibleViewController(from: navigationController.visibleViewController)
            
        case let tabBarController as UITabBarController:
            return UIWindow.visibleViewController(from: tabBarController.selectedViewController)
            
        case let presentingViewController where viewController?.presentedViewController != nil:
            return UIWindow.visibleViewController(from: presentingViewController?.presentedViewController)
            
        default:
            return viewController
        }
    }
}




