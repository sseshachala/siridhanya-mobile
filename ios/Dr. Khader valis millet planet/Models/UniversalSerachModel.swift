//
//  UniversalSerachModel.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 28/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class UniversalSerachModel: NSObject {
    
    var id:String = ""
    var Type_of_Ailment:String = ""
    var Dictoction_Kashayam_Diet:String = ""
    var Tags_Keywords:String = ""
    var milletProtocol:String = ""
    
    
    func getUniversalSerachModelWith(dict:[String:AnyObject]) -> UniversalSerachModel{
        if let id = dict["id"] as? String{
            self.id = id
        }
        if let Type_of_Ailment = dict["Type_of_Ailment"] as? String{
            self.Type_of_Ailment = Type_of_Ailment
        }
        if let Dictoction_Kashayam_Diet = dict["Dictoction_Kashayam_Diet"] as? String{
            self.Dictoction_Kashayam_Diet = Dictoction_Kashayam_Diet
        }
        if let Tags_Keywords = dict["Tags_Keywords"] as? String{
            self.Tags_Keywords = Tags_Keywords
        }
        if let milletProtocol = dict["milletProtocol"] as? String{
            self.milletProtocol = milletProtocol
        }
       
        
        return self
    }
}
