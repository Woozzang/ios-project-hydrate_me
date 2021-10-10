//
//  IsaoTextfield+Factory.swift
//  HydrateMe
//
//  Created by Woochan Park on 2021/10/10.
//

import UIKit
import TextFieldEffects

extension IsaoTextField {
  
  static func initCustomizedField(keyboardType type: UIKeyboardType = .default) -> IsaoTextField {
    
    let textField = IsaoTextField.init()
    
    textField.keyboardType = type
    
    textField.activeColor = .white
    
    textField.inactiveColor = #colorLiteral(red: 0.8039215686, green: 0.8980392157, blue: 0.7764705882, alpha: 1)
    
    textField.adjustsFontSizeToFitWidth = true
    
    textField.font = UIFont.systemFont(ofSize: 14)
    
    textField.textColor = .white
    
    textField.tintColor = .white
    
    return textField
  }
}
