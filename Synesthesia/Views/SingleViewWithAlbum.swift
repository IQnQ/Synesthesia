//
//  SingleViewWithAlbum.swift
//  Synesthesia
//
//  Created by Zsombor Rajki on 2019. 04. 28..
//

import Foundation
import UIKit

class SingleViewWithAlbum: UITableViewCell{

    @IBOutlet weak var musicAlbumLabel: UILabel!
    @IBOutlet weak var musicDescLabel: UILabel!
    @IBOutlet weak var musicArtistLabel: UILabel!
    @IBOutlet weak var musicImage: UIImageView!
    
    
    override func awakeFromNib() {
    super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        // Configure the view for the selected state
    }
}
