//
//  TabBarController.swift
//  Synesthesia
//
//  Created by Zsombor Rajki on 2019. 04. 29..
//

import UIKit

class TabBarController: UITabBarController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupBar.barStyle = .prominent
        self.popupBar.barTintColor = .white
        self.popupBar.tintColor = .white
        self.popupBar.progressViewStyle = .bottom
        self.popupContentView.popupCloseButtonStyle = .chevron
        self.popupBar.inheritsVisualStyleFromDockingView = false
        self.popupInteractionStyle = .drag
        self.popupBar.backgroundStyle = .dark
        self.popupBar.backgroundColor = .clear
    }
    
}
