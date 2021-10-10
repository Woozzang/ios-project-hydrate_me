//
//  ProfileViewController.swift
//  HydrateMe
//
//  Created by Woochan Park on 2021/10/09.
//

import UIKit
import TextFieldEffects

final class ProfileViewController: UIViewController {
  
  // MARK: - Property
  
  private let profilImageView: UIImageView = {
    
    let imageView = UIImageView(image: UIImage(named: "1-8"))
    
    return imageView
  }()
  
  private let nameTextField: IsaoTextField = IsaoTextField.initCustomizedField()
  
  private let heightTextField: IsaoTextField =  IsaoTextField.initCustomizedField(keyboardType: .numberPad)

  private let weightTextField: IsaoTextField =  IsaoTextField.initCustomizedField(keyboardType: .numberPad)
  
  private let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    setUpRootView()
    
    setUpNavigationBarButton()
    
    setUpTapGesture()
    
    setUpProfileImageView()
    
    setUpTextFields()
    
    updateProfileImage()
  }
  
  // MARK: - AutoLayout
  
  private func setUpRootView() {
    
    view.backgroundColor = UIColor.themeMainColor
  }
  
  private func setUpNavigationBarButton() {
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(didTapSaveButton))
  }
  
  private func setUpTapGesture() {
    
    view.addGestureRecognizer(tapGestureRecognizer)
    
    tapGestureRecognizer.addTarget(self, action: #selector(didTap))
  }
  
  private func setUpProfileImageView() {
    
    view.addSubview(profilImageView)
    
    profilImageView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      make.leading.equalTo(view).offset(125)
      make.trailing.equalTo(view).offset(-125)
      
      make.height.equalTo(profilImageView.snp.width)
    }
  }
  
  /**
    닉네임, 키, 몸무게 입력창을 화면에 표시한다.
   */
  
  private func setUpTextFields() {
    
    nameTextField.delegate = self
    heightTextField.delegate = self
    weightTextField.delegate = self
    
    nameTextField.text = WaterManager.shared.nickName
    
    var arrangedSubviews: [UIStackView] = []
    
    let nameVerticalStackView = makeConfiguredStackView(title: "닉네임을 설정해주세요", textField: nameTextField)
    
    arrangedSubviews.append(nameVerticalStackView)
    
    let heightVerticalStackView = makeConfiguredStackView(title: "키(cm)를 설정 해주세요", textField: heightTextField)

    arrangedSubviews.append(heightVerticalStackView)

    let weightVerticalStackView = makeConfiguredStackView(title: "몸무게(kg)을 입력해주세요", textField: weightTextField)

    arrangedSubviews.append(weightVerticalStackView)
    
    
    let mainVerticalStackView = UIStackView(arrangedSubviews: arrangedSubviews)
    
    mainVerticalStackView.axis = .vertical
    
    mainVerticalStackView.spacing = 20
    
    view.addSubview(mainVerticalStackView)
    
    mainVerticalStackView.snp.makeConstraints { make in
      
      make.top.equalTo(profilImageView.snp.bottom).offset(40)
      make.leading.equalTo(view).offset(60)
      make.trailing.equalTo(view).offset(-60)
      
      make.height.greaterThanOrEqualTo(0)
    }
  }
  
  // MARK: - Action
  
  @objc func didTapSaveButton() {
    
    guard let userInfo = extractUserInfoFromTextField() else {
      
      // TODO: 알림창
      let alert = UIAlertController(title: "잠시만요...🤔",
                                    message: "설정하지 않은 항목이 있는 것 같아요.",
                                    preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
      
      alert.addAction(okAction)
      
      present(alert, animated: true, completion: nil)

      return
    }
    
    WaterManager.shared.updateUserInfo(with: userInfo)
    
    navigationController?.popToRootViewController(animated: true)
  }
  
  private func extractUserInfoFromTextField() -> [WaterManager.UserInfoKey: Any]? {
    
    guard nameTextField.text!.isNotEmpty, let nickName = nameTextField.text else { return nil }
    
    guard heightTextField.text!.isNotEmpty, let height = Int(heightTextField.text!) else { return nil }
    
    guard weightTextField.text!.isNotEmpty, let weight = Int(weightTextField.text!) else { return nil }
    
    var userInfo: [WaterManager.UserInfoKey: Any]? = [:]
    
    let recommendedIntake = WaterManager.shared.calculateRecommendedIntake(userheight: height, userweight: weight)
    
    userInfo!.updateValue(nickName, forKey: .nickName)
    userInfo!.updateValue(recommendedIntake, forKey: .recommendedIntake)
    
    return userInfo
  }
  
  @objc private func didTap() {
    
    view.endEditing(true)
    
    
    UIView.animate(withDuration: 0.15) { [self] in
      self.view.bounds = CGRect(origin: CGPoint(x: 0, y: 0),
                                size: CGSize.init(width: view.bounds.width, height: view.bounds.height))
    }
    
  }
  
   // FIXME: DrinkWaterViewController 와 유사한 코드가 존재한다.
  /**
   프로필 이미지를 목표 달성률에 따라 업데이트한다
   */
  func updateProfileImage() {
    
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
    
    profilImageView.image = image
  }
  
}


// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
  
  /**
    TextField 위치에 따라 콘텐트 뷰의 Bounds 값 분기
   */
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    if textField === nameTextField {
      
      UIView.animate(withDuration: 0.15) { [self] in
        self.view.bounds = CGRect(origin: CGPoint(x: 0, y: 0),
                                  size: CGSize.init(width: view.bounds.width, height: view.bounds.height))
      }
    }
    
    if textField === heightTextField {
      
      UIView.animate(withDuration: 0.15) {
        self.view.bounds = CGRect(origin: CGPoint(x: 0, y: self.nameTextField.superview!.frame.height),
                                  size: CGSize.init(width: self.view.bounds.width, height: self.view.bounds.height))
      }

    }
    
    if textField === weightTextField {
      
      UIView.animate(withDuration: 0.15) { [self] in
        self.view.bounds = CGRect(origin: CGPoint(x: 0, y: self.nameTextField.superview!.frame.height * 2),
                                  size: CGSize.init(width: self.view.bounds.width, height: self.view.bounds.height))
      }
      
    }
    
    return true
  }
  
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    view.endEditing(true)
  }
}

// MARK: - Custom

extension ProfileViewController {
  /**
      미리 정의된 형태의 입력창 구성을 위해 만든 메서드.
      스택 뷰에 UILabel 과  IsaoTextField 가 수직으로 배열되어 구성된다.
   */
  
  private func makeConfiguredStackView(title: String, textField: UITextField) -> UIStackView {
    
    let label = UILabel().text(title)
                        .font(UIFont.systemFont(ofSize: 12))
                        .textColor(UIColor.white)
    
    
    let stackView = UIStackView(arrangedSubviews: [label, textField])
    
    stackView.axis = .vertical
    stackView.spacing = 5
    
    return stackView
  }
}
