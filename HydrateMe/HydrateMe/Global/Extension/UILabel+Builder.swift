//
//  UILabel+CustomInit.swift
//  HydrateMe
//
//  Created by Woochan Park on 2021/10/10.
//

import UIKit

extension UILabel {
  
  func text(_ text: String) -> UILabel {
    
    self.text = text
    
    return self
  }
  
  func font(_ font: UIFont) -> UILabel {
    
    self.font = font
    
    return self
  }
  
  func textColor(_ color: UIColor) -> UILabel {
    
    self.textColor = color
    
    return self
  }
  
  func numberOfLines(_ numOfLines: Int) -> UILabel {
    
    self.numberOfLines = numOfLines
    
    return self
  }
  
  func textAlignment(_ alignment: NSTextAlignment) -> UILabel {
    
    self.textAlignment = alignment
    
    return self
  }
  
}
