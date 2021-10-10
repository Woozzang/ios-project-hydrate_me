//
//  DrinkWaterViewController.swift
//  HydrateMe
//
//  Created by Woochan Park on 2021/10/09.
//

import UIKit
import SnapKit

final class DrinkWaterViewController: UIViewController {
  
  // MARK: - Property
  
  private let baselabel = {
    return UILabel().text("잘하셨어요!\n오늘 마신 양은")
      .font(.systemFont(ofSize: 25))
      .textColor(.white)
      .numberOfLines(0)
  }()
  
  private let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
  
  private let waterCountLabel = {
    return UILabel().font(.systemFont(ofSize: 25, weight: .bold)).textColor(.white)
  }()
  
  private let achievementRateLabel = {
    return UILabel().font(.systemFont(ofSize: 14, weight: .thin)).textColor(.white)
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
    textField.keyboardType = .numberPad
    
    return textField
  }()
  
  private let guideLabel: UILabel = {
    
    return UILabel().font(.systemFont(ofSize: 12)).textColor(.white).textAlignment(.center)
  }()
  
  private let drinkWaterButton : UIButton = {
    
    let button = UIButton()
    
//    button.tintColor = .black
    button.setTitle("물마시기💧", for: .normal)
    button.setTitle("목표 달성 완료 🥳", for: .disabled)
    button.setTitleColor(.black, for: .normal)
    
    button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    button.backgroundColor = .white
    
    return button
  }()
  
  // MARK: - Life Cycle
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    title = "물 마시기"
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(userIntakeDidChange), name: WaterManager.waterVolumeDidChange, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(recommendedIntakeDidChange), name: WaterManager.recommendedIntakeDidChange, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(nickNameDidChange), name: WaterManager.nickNameDidChange, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(sceneWillEnterForeground), name: UIScene.willEnterForegroundNotification, object: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    setUpRootView()
    
    setUpTapGesture()
    
    setUpNavigationItem()
    
    setUpLabelStackView()
    
    setUpMainImageView()
    
    setUpWaterInputTextField()
    
    setUpDrinkWaterButton()
    
    setUpGuideLabel()
    
    updateWaterCountLabel()

    updateAcheivementRateLabel()
    
    updateGuideLabel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    animateImageVIew()
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
  
  // MARK: - AutoLayout
  
  private func setUpRootView() {
    
    view.backgroundColor = UIColor.themeMainColor
    
    view.isUserInteractionEnabled = true
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
  
  private func setUpGuideLabel() {
    
    view.addSubview(guideLabel)
    
    guideLabel.snp.makeConstraints { make in
      make.leading.trailing.equalTo(view)
      make.bottom.equalTo(drinkWaterButton.snp.top).offset(-8)
    }
  }
  
  private func setUpDrinkWaterButton() {
    
    view.addSubview(drinkWaterButton)
    
    drinkWaterButton.addTarget(self, action: #selector(didTapDrinkWaterButton), for: .touchUpInside)
    
    drinkWaterButton.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalTo(view)
    }
  }
  
  /**
    이미지 뷰의 애니메이션을 시작한다
   */
  
  private func animateImageVIew() {
    
    self.mainImageView.transform = CGAffineTransform.identity
    
    UIView.animate(withDuration: 1.0,
                   delay: 0,
                   options: [.autoreverse, .repeat, .allowUserInteraction],
                   animations: { self.mainImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7) },
                   completion: nil

    )
  }
  
  // MARK: - Action
  
  @objc private func didTapDrinkWaterButton() {
    
    guard let text = waterInputTextFiled.text, text.isNotEmpty else {
      
      let alert = UIAlertController(title: "물 없음", message: "입력한 값을 확인해주세요🤔", preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
      
      alert.addAction(okAction)
      
      present(alert, animated: true, completion: nil)
      
      return
    }
    
    waterInputTextFiled.text = nil
    
    if WaterManager.shared.recommendedIntake == 0 {
      
      let alert = UIAlertController(title: "❌ 사용자 정보 없음 ❌", message: "사용자 정보를 먼저 입력해주세요😅", preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
        self.navigationController?.pushViewController(ProfileViewController(), animated: true)
      })
      
      alert.addAction(okAction)
      
      present(alert, animated: true, completion: nil)
      
      return
    }
    
    let waterVolumeString = text.replacingOccurrences(of: "ml", with: "")
    
    let waterVolume = Int(waterVolumeString) ?? 0
    
    WaterManager.shared.addWaterVolume(size: waterVolume)
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
    
    navigationController?.pushViewController(ProfileViewController(), animated: true)
  }
  
  @objc private func didTap() {
    
    view.endEditing(true)
  }
}

// MARK: - UITextFieldDelegate

extension DrinkWaterViewController: UITextFieldDelegate {
  
  /**
      TextField 커서를 중앙에서 시작하기 위한 트릭
   */
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.text = " "
  }
  
  /**
      TextField 커서를 중앙에서 시작하기 위한 트릭
   */
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

  // FIXME: UITextField.keyboardType = .numberpad 에서는 필요 없는 delegate 메서드이다.
  
//  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//    guard string.count == 1 ,let substring = string.first else { return false }
//
//    let inputCharacter = Character.init(String(substring))
//
//    if inputCharacter.isNumber {
//
//      return true
//    }
//
//    return false
//  }
}

// MARK: - Notification Action

extension DrinkWaterViewController {
  
  @objc func keyboardWillShow(_ notification: Notification) {
    
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
    
    view.bounds = CGRect(x: 0, y: keyboardFrame.size.height/2, width: view.bounds.width, height: view.bounds.height)
  }
  
  @objc func keyboardWillHide() {
    
    view.bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
  }
  
  @objc func userIntakeDidChange() {
    
    updateWaterCountLabel()
    updateAcheivementRateLabel()
    updateMainImage()
    updateToAcheiment()
  }
  
  @objc func recommendedIntakeDidChange() {
    
    updateAcheivementRateLabel()
    updateMainImage()
    updateGuideLabel()
    updateToAcheiment()
  }
  
  @objc func nickNameDidChange() {
    
    updateGuideLabel()
  }
  
  @objc func sceneWillEnterForeground() {
    
    animateImageVIew()
  }
}

// MARK: - Update Method Called-by Notification Actions

extension DrinkWaterViewController {
  
  private func updateMainImage() {
    
    let rate = WaterManager.shared.acheivementRate
    
    guard !rate.isNaN, !rate.isInfinite else { return }
    
    let intRate = Int(rate)
    
    var image: UIImage
    
    switch intRate {
      case (0...10):
        image = UIImage(named: "1-1")!
      case (11...20):
        image = UIImage(named: "1-2")!
      case (21...30):
        image = UIImage(named: "1-3")!
      case (31...40):
        image = UIImage(named: "1-4")!
      case (41...50):
        image = UIImage(named: "1-5")!
      case (51...60):
        image = UIImage(named: "1-6")!
      case (61...70):
        image = UIImage(named: "1-7")!
      case (71...80):
        image = UIImage(named: "1-8")!
      case (81...):
        image = UIImage(named: "1-9")!
      default:
        image = UIImage()
    }
    
    mainImageView.image = image
    
    animateImageVIew()
  }
  
  private func updateGuideLabel() {
    
    let nickName = WaterManager.shared.nickName
    
    let recommendedIntake = WaterManager.shared.recommendedIntake
    
    /**
      리터 변환
     */
    
    let liter = Int(Float(Int(Float(recommendedIntake) / Float(100))) / Float(10))
    
    guideLabel.text = "\(nickName) 님의 하루 물 권장 섭취량은 \(liter)L 입니다."
  }
  

  
  private func updateToAcheiment() {
    
    let acheivementRate = WaterManager.shared.acheivementRate
    
    if acheivementRate >= 100 {
      
      drinkWaterButton.isEnabled = false
      waterInputTextFiled.isEnabled = false
      
    } else {
      
      drinkWaterButton.isEnabled = true
      waterInputTextFiled.isEnabled = true
    }
  }
  
  private func updateWaterCountLabel() {
    
    let newVolume = WaterManager.shared.userIntake
    
    waterCountLabel.text = "\(newVolume)ml"
  }
  
  
  private func updateAcheivementRateLabel() {
    
    let newRate = WaterManager.shared.acheivementRate
    
    var resultText: String
    
    if newRate.isNaN || newRate.isInfinite {
      
      resultText = "0"
    } else {
      resultText = "\(Int(newRate.rounded(.down)))"
    }
    
    achievementRateLabel.text = "목표의 \(resultText)%"
  }
}
