//
//  DashBoardModel.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 13/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class DashBoardModel: NSObject {
    
    var action:String = ""
    var icon:String = ""
    var id:String = ""
    var menu_name:String = ""
    var service_name:String = ""
    
    func getDashBoardWith(dict:[String:AnyObject]) -> DashBoardModel{
        if let action = dict["action"] as? String{
            self.action = action
        }
        if let icon = dict["icon"] as? String{
            self.icon = icon
        }
        if let id = dict["id"] as? String{
            self.id = id
        }
        if let menu_name = dict["menu_name"] as? String{
            self.menu_name = menu_name
        }
        if let service_name = dict["service_name"] as? String{
            self.service_name = service_name
        }
        
        return self
    }
}
