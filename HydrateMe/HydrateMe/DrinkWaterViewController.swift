//
//  DrinkWaterViewController.swift
//  HydrateMe
//
//  Created by Woochan Park on 2021/10/09.
//

import UIKit
import SnapKit

class DrinkWaterViewController: UIViewController {
  
  private let baselabel = {
    return UILabel().text("잘하셨어요!\n오늘 마신 양은")
      .font(.systemFont(ofSize: 25))
      .textColor(.white)
      .numberOfLines(0)
  }()
  
  private let waterCountLabel = {
    return UILabel().text("1200ml")
      .font(.systemFont(ofSize: 25, weight: .bold))
      .textColor(.white)
  }()
  
  private let achievementRateLabel = {
    return UILabel().text("목표의 57%")
      .font(.systemFont(ofSize: 14, weight: .thin))
      .textColor(.white)
  }()
  
  private let mainImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "1-8"))
    
    return imageView
  }()
  
  private let waterInputTextFiled: UITextField = {
    let textField = UITextField()
    
    textField.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
    textField.textColor = .white
    textField.textAlignment = .center
    textField.backgroundColor = .clear
    textField.placeholder = "마실 물 양을 입력해주세요"
    textField.tintColor = .white
    
    return textField
  }()
  
  private let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
  
  private let drinkWaterButton : UIButton = {
    
    let button = UIButton()
    
//    button.tintColor = .black
    button.setTitle("물마시기💧", for: .normal)
    button.setTitleColor(.black, for: .normal)
    
    button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    button.backgroundColor = .white
    
    return button
  }()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    title = "물 마시기"
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.themeMainColor
    
    view.isUserInteractionEnabled = true
    
    setUpTapGesture()
    
    setUpNavigationItem()
    
    setUpLabelStackView()
    
    setUpMainImageView()
    
    setUpWaterInputTextField()
    
    setUpDrinkWaterButton()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    /**
      - Description:
          SafeArea 값에 따라 버튼의 레이아웃을 조정
     */
    drinkWaterButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
    drinkWaterButton.snp.makeConstraints { maker in
      maker.height.equalTo(60 + view.safeAreaInsets.bottom)
    }
  }
  
  private func setUpTapGesture() {
    
    view.addGestureRecognizer(tapGestureRecognizer)
    
    tapGestureRecognizer.addTarget(self, action: #selector(didTap))
  }
  
  private func setUpNavigationItem() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(resetWaterCountToZero))
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(moveToProfilePage))
  }
  
  private func setUpLabelStackView() {
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    
    view.addSubview(stackView)
    
    stackView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
      make.left.equalTo(view.safeAreaLayoutGuide).offset(40)
    }
    
    stackView.addArrangedSubview(baselabel)
    stackView.addArrangedSubview(waterCountLabel)
    stackView.addArrangedSubview(achievementRateLabel)
  }
  
  private func setUpMainImageView() {
    
    view.addSubview(mainImageView)
    
    mainImageView.snp.makeConstraints { make in
      make.center.equalTo(view)
      make.leading.equalTo(view).offset(70)
      make.trailing.equalTo(view).offset(-70)
      make.height.equalTo(mainImageView.snp.width)
    }
  }
  
  private func setUpWaterInputTextField() {
    
    view.addSubview(waterInputTextFiled)
    
    waterInputTextFiled.delegate = self
    
    waterInputTextFiled.snp.makeConstraints { make in
      
      make.top.equalTo(mainImageView.snp.bottom).offset(50)
      make.centerX.equalTo(view)
      make.leading.equalTo(view).offset(50)
      make.trailing.equalTo(view).offset(-50)
    }
  }
  
  private func setUpDrinkWaterButton() {
    
    view.addSubview(drinkWaterButton)
    
    drinkWaterButton.addTarget(self, action: #selector(didTapDrinkWaterButton), for: .touchUpInside)
    
    drinkWaterButton.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalTo(view)
    }
  }
  
  @objc func resetWaterCountToZero() {
    
    let alert = UIAlertController(title: "⚠️ 주의 ⚠️",
                                  message: "기록된 물이 삭제되요.\n괜찮으신가요?",
                                  preferredStyle: .alert)
    
    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
      WaterManager.shared.resetVolume()
    }
    
    let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
    
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
  @objc func moveToProfilePage() {
    
    print(#function)
    
    view.bounds = CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height)
  }
  
  
  
  func updateWaterCount() {
    
  }
  
//  func mainImageMaker() -> UIImage {
//    let currentVolume = WaterManager.shared.waterVolume
//
//  }
  
  @objc private func didTapDrinkWaterButton() {
    
    print(#function)
    
    guard let text = waterInputTextFiled.text else {
      
      let alert = UIAlertController(title: "물 없음", message: "입력한 값을 확인해주세요🤔", preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
      
      alert.addAction(okAction)
      
      present(alert, animated: true, completion: nil)
      
      return
    }
    
    let waterVolumeString = text.replacingOccurrences(of: "ml", with: "")
    
    let waterVolume = Int(waterVolumeString) ?? 0
    
  }
  
  @objc private func didTap() {
    print(#function)
    view.endEditing(true)
  }
}


extension DrinkWaterViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.text = " "
  }
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    
    if textField.text == " " {
      textField.text = nil
      return
    }
    
    textField.text = textField.text?.replacingOccurrences(of: " ", with: "")
    textField.text = textField.text! + "ml"
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    textField.resignFirstResponder()
    
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    guard string.count == 1 ,let substring = string.first else { return false }
    
    let inputCharacter = Character.init(String(substring))
    
    if inputCharacter.isNumber {
      
      return true
    }
    
    return false
  }
}

extension DrinkWaterViewController {
  
  @objc func keyboardWillShow(_ notification: Notification) {
    
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
    
    
    guard let keyboardBeginFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
    
    print(keyboardFrame, keyboardBeginFrame)
    
    view.bounds = CGRect(x: 0, y: keyboardFrame.size.height/2, width: view.bounds.width, height: view.bounds.height)
  }
  
  @objc func keyboardWillHide() {
    view.bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
  }
}
