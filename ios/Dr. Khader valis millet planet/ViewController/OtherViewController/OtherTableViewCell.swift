//
//  OtherTableViewCell.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 18/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class OtherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var tempText: UITextView!
    
    @IBOutlet weak var moreInfoButton: UIButton!
    
    @IBOutlet weak var authorButton: UIButton!
    
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var moreInfoLbl: UILabel!
    @IBOutlet weak var moreInfoFixLbl: UILabel!
    @IBOutlet weak var descriptionlb: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var authorNameFixLbl: UILabel!
    @IBOutlet weak var authorNameWidth: NSLayoutConstraint!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var exapndImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
