//
//  Common_Methods.swift
//  Dr. Khader vali's Millet Planet
//
//  Created by Sunny on 13/04/19.
//

import UIKit
import SwiftSpinner
class Common_Methods: NSObject {
    static let shared = Common_Methods()
    
    let appColor = UIColor(red: 112.0/255.0, green: 120.0/255.0, blue: 87.0/255.0, alpha: 1)
    

    // MARK: -  SwiftSpinner 
    
    class func updateMsg (with : String){
        
       SwiftSpinner.sharedInstance.title = with
        
    }
    class func showHUD(with : String){
        
        SwiftSpinner.show(delay: 0.5, title: with, animated: true)
     
    }
    class func hideHUD(){
        
       SwiftSpinner.hide()
        
    }
    
    
    //MARK: -  AlertViewConroller 
    
    class func callAlertViewConroller(CommonAlert:UIViewController,DialogTitle:String,strDialogMessege:String)
    {
        let actionSheetController: UIAlertController = UIAlertController(title: DialogTitle as String, message: strDialogMessege as String, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        
        actionSheetController.addAction(OKAction)
        
        CommonAlert.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}



extension String
{
    public var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
}

public extension UIDevice {
    
    var modelName: String {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
        let DEVICE_IS_SIMULATOR = true
        #else
        let DEVICE_IS_SIMULATOR = false
        #endif
        
        var machineString : String = ""
        
        if DEVICE_IS_SIMULATOR == true
        {
            
            if let dir = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                machineString = dir
            }
        }
        else {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            machineString = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        }
        switch machineString {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        default:                                        return machineString
        }
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
