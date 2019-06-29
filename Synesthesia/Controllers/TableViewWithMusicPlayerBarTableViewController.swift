//
//  TableViewWithMusicPlayerBarTableViewController.swift
//  Synesthesia
//
//  Created by Zsombor Rajki on 2019. 04. 30..
//  Copyright © 2019. Zsombor Rajki. All rights reserved.
//

import UIKit

class TableViewWithMusicPlayerBarTableViewController: UITableViewController {
    lazy var playerViewController: PlayerViewController = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = appDelegate.playerViewController
        return vc
    }()
}
