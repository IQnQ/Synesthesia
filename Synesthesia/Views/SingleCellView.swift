//
//  SingleCellView.swift
//  Synesthesia
//
//  Created by Zsombor Rajki on 2019. 04. 27..
//

import Foundation
import UIKit

class SongTableViewCell: UITableViewCell {
    

    @IBOutlet weak var miniImageView: UIImageView!
    @IBOutlet weak var musicDescLabel: UILabel!
    @IBOutlet weak var musicTitleLabel: UILabel!
    @IBOutlet weak var amLabel: UILabel!
    @IBOutlet weak var explicitLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
