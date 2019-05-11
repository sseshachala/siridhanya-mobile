//
//  CommanTableCellTypeTwo.swift
//  Dr. Khader valis millet planet
//
//  Created by Sunny on 14/04/19.
//  Copyright © 2019 Sunny. All rights reserved.
//

import UIKit

class CommanTableCellTypeTwo: UITableViewCell {
    
    @IBOutlet weak var diseaseNametxt: UILabel!
    
    @IBOutlet weak var DictoctionTxt: UILabel!
    
    @IBOutlet weak var milletProTxt: UILabel!
    
    @IBOutlet weak var specialIntTXt: UILabel!
    
    
    
    
    @IBOutlet weak var specialInstructionLbl: UILabel!
    
    @IBOutlet weak var specialInstWebView: UIWebView!
    @IBOutlet weak var milletProWebView: UIWebView!
    @IBOutlet weak var ductoctionWebView: UIWebView!
    
    @IBOutlet weak var specialInstWebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ductoctionWebViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var milletProWebViewHeight: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var Dictoction: UILabel!
    
    @IBOutlet weak var milletProtocol: UILabel!
    @IBOutlet weak var diseaseName: UILabel!
    
    @IBOutlet weak var exapndImageView: UIImageView!
    @IBOutlet weak var specialINstructiontxt: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
