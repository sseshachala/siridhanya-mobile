//
//  CommanTableViewCell.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 14/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class CommanTableViewCell: UITableViewCell {

    @IBOutlet weak var txtValueLbl: UILabel!
    @IBOutlet weak var coutLbl: UILabel!
    
    @IBOutlet weak var backView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = 15
        backView.clipsToBounds = true
    backView.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.3764705882, blue: 0.4705882353, alpha: 1)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
