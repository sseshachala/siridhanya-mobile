//
//  CommanModel.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 14/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class CommanModel: NSObject {
    
    
    var note:String = ""
    var id:String = ""
    var Description:String = ""
    var Id:String = ""
    var dictoction_kashayas_juice:String = ""
    var disease_name:String = ""
    var milletProtocol:String = ""
    var specialInstruction:String = ""
    
    var cancer_type:String = ""
    var dictoction_kashayas_juice_afternoon_each_week:String = ""
    var dictoction_kashayas_juice_every_week:String = ""
    var Dictoction_Kashayam_Diet:String = ""
    var Tags_Keywords:String = ""
    var Type_of_Ailment:String = ""
   
    
    
    func getCommanModelWith(dict:[String:AnyObject]) -> CommanModel{
        
        if let Dictoction_Kashayam_Diet = dict["Dictoction_Kashayam_Diet"] as? String{
            self.Dictoction_Kashayam_Diet = Dictoction_Kashayam_Diet
        }
        if let Tags_Keywords = dict["Tags_Keywords"] as? String{
            self.Tags_Keywords = Tags_Keywords
        }
        if let Type_of_Ailment = dict["Type_of_Ailment"] as? String{
            self.Type_of_Ailment = Type_of_Ailment
        }
        if let dictoction_kashayas_juice_afternoon_each_week = dict["dictoction_kashayas_juice_afternoon_each_week"] as? String{
            self.dictoction_kashayas_juice_afternoon_each_week = dictoction_kashayas_juice_afternoon_each_week
        }
        if let dictoction_kashayas_juice_every_week = dict["dictoction_kashayas_juice_every_week"] as? String{
            self.dictoction_kashayas_juice_every_week = dictoction_kashayas_juice_every_week
        }
        
        
        if let specialInstruction = dict["specialInstruction"] as? String{
            self.specialInstruction = specialInstruction
        }
        if let milletProtocol = dict["milletProtocol"] as? String{
            self.milletProtocol = milletProtocol
        }
        if let disease_name = dict["disease_name"] as? String{
            self.disease_name = disease_name
        }
        if let dictoction_kashayas_juice = dict["dictoction_kashayas_juice"] as? String{
            self.dictoction_kashayas_juice = dictoction_kashayas_juice
        }
        
        if let note = dict["note"] as? String{
            self.note = note
        }
        if let Description = dict["Description"] as? String{
            self.note = Description
        }
        if let id = dict["id"] as? NSNumber{
            self.id = "\(id)"
        }
        if let Id = dict["Id"] as? NSNumber{
            self.id = "\(Id)"
        }
        
        
        
        return self
    }
}
