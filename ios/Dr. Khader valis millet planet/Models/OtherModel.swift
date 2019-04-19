//
//  OtherModel.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 18/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class OtherModel: NSObject {
    
    var author:String = ""
    var descriptions:String = ""
    var email:String = ""
    var id:String = ""
    var image:String = ""
    var name:String = ""
    var video_url:String = ""
    
    func getOtherModelWith(dict:[String:AnyObject]) -> OtherModel{
        if let author = dict["author"] as? String{
            self.author = author
        }
        if let descriptions = dict["description"] as? String{
            self.descriptions = descriptions
        }
        if let email = dict["email"] as? String{
            self.email = email
        }
        if let id = dict["id"] as? String{
            self.id = id
        }
        if let image = dict["image"] as? String{
            self.image = image
        }
        if let name = dict["name"] as? String{
            self.name = name
        }
        if let video_url = dict["video_url"] as? String{
            self.video_url = video_url
        }
        
        return self
    }
}
