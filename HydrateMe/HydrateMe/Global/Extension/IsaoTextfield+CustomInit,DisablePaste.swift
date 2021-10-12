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

/**
  Paste Action 방지
 */

extension IsaoTextField {
  
  // IsaoTextField 에서 이미 canPerformAction 을 open 으로 재정의 해놓았기 때문에
  // 접근지정자를  open 으로 사용하였다.
  open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

    if action == #selector(UIResponderStandardEditActions.paste(_:)) {
        return false
    }

    return super.canPerformAction(action, withSender: sender)
  }

}
