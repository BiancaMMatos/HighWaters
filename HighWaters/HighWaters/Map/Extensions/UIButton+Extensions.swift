//
//  UIButton+Extensions.swift
//  HighWaters
//
//  Created by Bianca Maciel on 11/09/25.
//

import UIKit
import Foundation

extension UIButton {
    
    static func buttonForRightAccessoryView() -> UIButton {
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 18, height: 22)
        button.setImage(UIImage(named: "711-trash-toolbar"), for: .normal)
        return button
        
    }
    
}
