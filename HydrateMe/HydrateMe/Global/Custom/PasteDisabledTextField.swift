//
//  ActionDisabledTextField.swift
//  HydrateMe
//
//  Created by Woochan Park on 2021/10/11.
//

import UIKit

/**
  Paste Action 을 사용하지 못하게 한 텍스트필드
 */

final class PasteDisabledTextField: UITextField {
  
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    
    if action == #selector(UIResponderStandardEditActions.paste(_:)) {
        return false
    }
    
    return super.canPerformAction(action, withSender: sender)
  }
}
