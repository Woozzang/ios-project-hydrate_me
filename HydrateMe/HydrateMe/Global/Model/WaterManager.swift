//
//  WaterManager.swift
//  HydrateMe
//
//  Created by Woochan Park on 2021/10/10.
//

import Foundation

class WaterManager {
  
  typealias Water = Int
  
  // MARK: - Property
  
  static let shared = WaterManager()
  
  private let persistantStorage = UserDefaults.standard
  
  /**
    userIntake (마신 물양), recommendedIntake (권장 섭취량) 는 ml 단위
   */
  private(set) var userIntake: Water = 0 {
    
    didSet {
      NotificationCenter.default.post(name: WaterManager.waterVolumeDidChange, object: nil)
    }
  }
  
  private(set) var recommendedIntake: Water = 0 {
    
    didSet {
      NotificationCenter.default.post(name: WaterManager.recommendedIntakeDidChange, object: nil)
    }
  }
  
  private(set) var nickName: String = "" {
    
    didSet {
      NotificationCenter.default.post(name: WaterManager.nickNameDidChange, object: nil)
    }
  }
  
  /**
    권장 섭취량
   */
  var acheivementRate: Float {
    
    return ( Float(userIntake) / Float(recommendedIntake) ) * 100
  }

  
  private let dateFormatter: DateFormatter = {
    
    let formatter = DateFormatter()
    formatter.dateFormat = .some("yyyy-MM-dd")
    return formatter
  }()
  
  // MARK: - Life Cycle
  
  private init() { }

  // MARK: - Custom Method
  
  /**
    UserDefaults 에서 사용자 데이터를 가지고 온다.
   */
  
  func fetchUserInfo() {
    
    guard let dateString = persistantStorage.string(forKey: UserInfoKey.recordedDate.rawValue) else { return }
    
    guard let recordedDate = dateFormatter.date(from: dateString) else { fatalError(#function) }
    
    // 기록된 날짜가 오늘이라면, 기록된 수치를 가져온다.
    if recordedDate.isToday() {
      userIntake = persistantStorage.integer(forKey: UserInfoKey.userIntake.rawValue)
    }

    recommendedIntake = persistantStorage.integer(forKey: UserInfoKey.recommendedIntake.rawValue)
    
    let nickname = persistantStorage.string(forKey: UserInfoKey.nickName.rawValue) ?? "등록안됨"
    
    self.nickName = nickname
  }
  
  /**
    마신 물 양을 업데이트 한다.
   - Parameter
    - size : 추가적으로 마신 물의 양
   */
  
  func addWaterVolume(size volume: Water) {
    
    self.userIntake += volume
  }
  
  
  /**
    지금까지 마신 물의 총 양을 초기화한다.
   */
  
  func resetVolume() {
    
    userIntake = 0
  }
  
  /**
    현재는 권장 섭취량만을 처리한다.
    요구사항이 변경될 경우 수정한다.
   */
  
  func updateUserInfo(with userInfo: [UserInfoKey: Any?]) {
    
    guard let nickName = userInfo[UserInfoKey.nickName] as? String else { return }
    guard let recommendedIntake = userInfo[UserInfoKey.recommendedIntake] as? Int else { return }

    self.nickName = nickName
    self.recommendedIntake = recommendedIntake
  }
  
  /**
      UserDefaults 에 사용자 정보를 저장한다
   */
  
  func saveUserInfo() {
    
    let recordedDate = dateFormatter.string(from: Date())
    
    persistantStorage.setValue(nickName, forKey: UserInfoKey.nickName.rawValue)
    persistantStorage.setValue(recordedDate, forKey: UserInfoKey.recordedDate.rawValue)
    persistantStorage.setValue(userIntake, forKey: UserInfoKey.userIntake.rawValue)
    persistantStorage.setValue(recommendedIntake, forKey: UserInfoKey.recommendedIntake.rawValue)
  }
  
  /**
    권장 섭취량을 계산한다
   */
  func calculateRecommendedIntake(userheight height: Int, userweight weight: Int) -> Int {

    var result = (Float(height) + Float(weight)) / Float(100)

    result = ((result * 10).rounded(.down)) / 10
    
    /**
      ml 변환
     */
    result = result * 1000
    
    return Int(result)
  }
}

// MARK: - Notification.Name

extension WaterManager {
  
  static let nickNameDidChange = Notification.Name("nickNameDidChange")
  
  static let waterVolumeDidChange = Notification.Name("waterVolumeDidChange")
  
  static let recommendedIntakeDidChange = Notification.Name("recommendedIntakeDidChange")
}

// MARK: - UserInfoKey

extension WaterManager {
  
  enum UserInfoKey: String {
    case userIntake
    case recordedDate
    case recommendedIntake
    case nickName
    
// 이 정보들을 유지할 필요가 없음
//    case height
//    case weight
  }
}
