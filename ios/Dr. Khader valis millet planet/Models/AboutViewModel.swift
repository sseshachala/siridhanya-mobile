//
//  AboutViewModel.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 14/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class AboutViewModel: NSObject {
    
    var about:String = ""
    var image:String = ""
    var id:String = ""
    
    
    func getAboutWith(dict:[String:AnyObject]) -> AboutViewModel{
        if let about = dict["about"] as? String{
            self.about = about
        }
        if let image = dict["image"] as? String{
            self.image = image
        }
        if let id = dict["id"] as? String{
            self.id = id
        }
        
        
        return self
    }
}
