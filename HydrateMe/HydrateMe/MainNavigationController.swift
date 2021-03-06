//
//  MainNavigationController.swift
//  HydrateMe
//
//  Created by Woochan Park on 2021/10/09.
//

import UIKit

class MainNavigationController: UINavigationController {
  
  init(with rootViewController: UIViewController) {
    super.init(nibName: nil, bundle: nil)
    
    setViewControllers([rootViewController], animated: true)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpNavigationBar()
  }
  
  private func setUpNavigationBar() {
    
    navigationBar.barTintColor = UIColor.themeMainColor
    navigationBar.tintColor = UIColor.white
    navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
  }
}
