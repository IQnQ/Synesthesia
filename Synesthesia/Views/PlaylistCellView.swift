//
//  PlaylistCellView.swift
//  Synesthesia
//
//  Created by Zsombor Rajki on 2019. 05. 03..
//  Copyright © 2019. Zsombor Rajki. All rights reserved.
//

import Foundation
import UIKit

class PlaylistCellView : UITableViewCell {
    
    @IBOutlet weak var playlistImage: UIImageView!
    @IBOutlet weak var playlistTitleLabel: UILabel!
    @IBOutlet weak var playlistAuthorLabel: UILabel!
    

override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    }

override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
    }
}
