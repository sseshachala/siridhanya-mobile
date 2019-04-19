//
//  DashBoardCell.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 13/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class DashBoardCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: ViewWithShadow!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //backView.layer.cornerRadius = 10
        
    }
}
