//
//  QuestionAnswerTableViewCell.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 14/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class QuestionAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var txtValueLbl: UILabel!
  
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var iconImage: UIImageView!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
