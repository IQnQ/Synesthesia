//
//  NavigationController.swift
//  Synesthesia
//
//  Created by Zsombor Rajki on 2019. 04. 30..
//  Copyright © 2019. Zsombor Rajki. All rights reserved.
//

import UIKit
import MediaPlayer

class NavigationController: UINavigationController {
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
