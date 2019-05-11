//
//  NutritoinCell.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 14/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class NutritoinCell: UITableViewCell {
    @IBOutlet weak var descriptionWebViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var alternativeWebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var millettypeWebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var userWebViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var userWebView: UIWebView!
    @IBOutlet weak var descriptionWebView: UIWebView!
    @IBOutlet weak var milletTypeWebView: UIWebView!
    @IBOutlet weak var alternativeWebView: UIWebView!
    @IBOutlet weak var milletTypeTop: NSLayoutConstraint!
    @IBOutlet weak var alterNativeFixLbl: UILabel!
    @IBOutlet weak var alternativeLBl: UILabel!
    @IBOutlet weak var val: UILabel!
    
    @IBOutlet weak var userFixLbl: UILabel!
    
    @IBOutlet weak var nutrationTop: NSLayoutConstraint!
    @IBOutlet weak var userTop: NSLayoutConstraint!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var descriptions: UILabel!
    @IBOutlet weak var nutrition: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var milletType: UILabel!
    @IBOutlet weak var exapndImageView: UIImageView!
    
    @IBOutlet weak var scientificName: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
