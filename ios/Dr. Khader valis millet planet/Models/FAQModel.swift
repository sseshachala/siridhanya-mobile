//
//  FAQModel.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 15/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class FAQModel: NSObject {
    
    var answer:String = ""
    var answer_icon:String = ""
    var id:String = ""
    var question:String = ""
    var question_icon:String = ""
    
    func getFAQModelWith(dict:[String:AnyObject]) -> FAQModel{
        if let answer = dict["answer"] as? String{
            self.answer = answer
        }
        if let answer_icon = dict["answer_icon"] as? String{
            self.answer_icon = answer_icon
        }
        if let id = dict["id"] as? String{
            self.id = id
        }
        if let question = dict["question"] as? String{
            self.question = question
        }
        if let question_icon = dict["question_icon"] as? String{
            self.question_icon = question_icon
        }
        
        return self
    }
}
