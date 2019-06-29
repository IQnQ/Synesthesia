//
//  PlayerActionButton.swift
//  Synesthesia
//
//  Created by Zsombor Rajki on 2019. 04. 30..
//  Copyright © 2019. Zsombor Rajki. All rights reserved.
//

import UIKit

class PlayerActionButton: UIButton {
    
    @IBInspectable
    var alternativeImage: UIImage?
    
    override func updateConstraints() {
        super.updateConstraints()
        layer.backgroundColor = UIColor.gray.withAlphaComponent(0).cgColor
        layer.cornerRadius = frame.height / 2
        
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
    }
    
    func onClickAnimation() {
        let duration: TimeInterval = 0.5
        self.layer.backgroundColor = self.layer.backgroundColor?.copy(alpha: 0)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration, animations: {
                self.imageView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.layer.backgroundColor = self.layer.backgroundColor?.copy(alpha: 0.5)
            })
            UIView.animate(withDuration: duration, animations: {
                self.imageView?.transform = .identity
                self.layer.backgroundColor = self.layer.backgroundColor?.copy(alpha: 0)
            })
        }
    }
}
