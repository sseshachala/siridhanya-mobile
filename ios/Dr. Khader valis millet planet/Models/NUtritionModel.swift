//
//  NUtritionModel.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 14/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class NUtritionModel: NSObject {
    
    
    var alternative_names:String = ""
    var id:String = ""
    var Description:String = ""
    var millet_type:String = ""
    var name:String = ""
    var nutrition:String = ""
    var nutritionVal:String = ""
    var scientific_name:String = ""
    var uses:String = ""
    
   
    func getNUtritionModelWith(dict:[String:AnyObject]) -> NUtritionModel{
        
        
        if let alternative_names = dict["alternative_names"] as? String{
            self.alternative_names = alternative_names
        }
        if let description = dict["description"] as? String{
            
            self.Description = description
            
        }
        if let millet_type = dict["millet_type"] as? String{
            self.millet_type = millet_type
        }
        
        
        if let name = dict["name"] as? String{
            self.name = name
        }
        if let nutrition = dict["nutrition"] as? String {
            var des = nutrition.description
        
            des = des.replacingOccurrences(of: "\\{", with: "", options: .regularExpression)
            des = des.replacingOccurrences(of: "\\}", with: "", options: .regularExpression)
            des = des.replacingOccurrences(of: "\\o", with: "", options: .regularExpression)
            des = des.replacingOccurrences(of: "\"", with: "", options: .regularExpression)
           des =  des.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
            des = des.trimmingCharacters(in: .whitespacesAndNewlines)
            des =  String(des.filter { !" \n\t\r".contains($0) })
            
           
            
            
            
            let i = des.components(separatedBy: ",")
            var val = [String]()
            var nutritionValtxt = [String]()
            for x in 0..<i.count{
                print(i[x])
                let valDes = i[x].components(separatedBy: ":")
                let trimmedString = String(valDes[0].filter { !" \n\t\r".contains($0) })
                
                val.append(trimmedString)
        
                nutritionValtxt.append(valDes[1])
               
                
            }
            let finalVal = val.joined(separator:"")
            let finalnutritionValtxt = nutritionValtxt.joined(separator:"\n")
            self.nutritionVal =  finalnutritionValtxt
            self.nutrition = finalVal
        }
        if let scientific_name = dict["scientific_name"] as? String{
            self.scientific_name = scientific_name
        }
        if let uses = dict["uses"] as? String{
            self.uses = uses
        }
        
        
        if let id = dict["id"] as? NSNumber{
            self.id = "\(id)"
        }
        
        
        
        
        return self
    }
    
    
    
    
}
