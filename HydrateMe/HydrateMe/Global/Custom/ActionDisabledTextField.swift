//
//  ActionDisabledTextField.swift
//  HydrateMe
//
//  Created by Woochan Park on 2021/10/11.
//

import UIKit

class ActionDisabledTextField: UITextField {
  
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    
    if action == #selector(UIResponderStandardEditActions.paste(_:)) {
        return false
    }
    
    return super.canPerformAction(action, withSender: sender)
  }
}
