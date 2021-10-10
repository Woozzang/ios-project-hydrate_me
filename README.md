# 물 마시기 프로젝트

💧💧 사용자가 마신 물의 양을 저장하고, 지금까지 마신 물의 양을 보여주는 앱 💧💧💧
<br /><br />
| DrinkWaterVC             |  ProfileVC |
:-------------------------:|:-------------------------:
<img src="/Resources/main.gif" width= "70%"> | <img src="/Resources/sub.gif" width= "70%"> 

<br /><br />

## 사용 요소 및 개념

- `NavigationController` ,  `Scene Life Cycle`, `Singletone`, `UserDefaults`
- `NotificationCenter`, 🔥 `No-StoryBoard`🔥 , `SwiftPM`
<br />

## 의존성

- `SnapKit`
    - 이 프로젝트는 스토리보드를 사용하지않고 100% 코드로 UI 를 구성하였습니다.
    - AutoLayout 관련 코드를 줄이기 위해 SnapKit 을 사용하였습니다.
<br />

## 화면 구조

- `MainNavigationController` : 최상단 컨테이너 뷰 컨트롤러
- `DrinkWaterViewController` : 메인 화면 컨트롤러
- `ProfileViewController` : 프로필 화면 컨트롤러
<br /><br />

# 해결 과정 🏃🏻‍♀️🏃🏻
### ☑️ <객체>.shared.init() 에서 self 가 반환되기 전에 다시 shared 에 접근해서  BAD ACCESS 오류

<img src="/Resources/Bad.png">

디버깅 인스펙터의 콜스택을 천천히 살펴보니....

- init 이 완료되어 self 를 반환받기 전에 self 에 접근을 시도하는 코드가 있었다.
- 어떻게 init 아직 완료된지 알 수 있을까?..... 호출 스택에 아직 남아있잖아여
- 반환된 코드는 스택에서 사라지겠죠?????

<img src="/Resources/CallStack.png">

→ One-time Set up 코드이기 때문에 SceneDelegate 에서 호출해주었다.
<br />

### ☑️  UITextField 숫자만 받게 하기

**최초 시도** 

```swift
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
```

- 여기서 `replacementString` 을 캐릭터로 변형하고, `.isNumber` 로 숫자인지 확인했다.
    - 발생하는 이슈 1: 백스페이스가 무시된다.
        - (잘못 입력해도 수정하려면 다른 곳을 탭한 후 다시 입력을 처음부터 시작해야한다.)
    - ~~발생하는 이슈 2: `paste` 로 문자를 입력하면 막지 못한다.~~
        - 확인 결과 내 코드만으로 paste 를 막을 수 있다.

해결

- iOS iPhone 용 앱인 점을 사용하여 , textFiled 의 입력 키보드를 NumberPad 로 설정해준다.
    - 최초 시도는 백스페이스 입력이 불가능한 점을 제외하고는 필요한 모든 기능이 구현되지만,
    - UX 상 사용자가 잘못 입력했을 때 수정 기회를 주는 것이 옳다고 생각하기 때문에 변경하였다.
<br />

### ☑️  UITextField Action 막기

- Paste Action 을 막아서 숫자 외의 문자를 붙여넣기 하는 것을 막고 싶었다.
- 아래 메서드는 소위 Action 메뉴를 열려고 할 때 수 차례 호출된다. (select, paste, selectAll 등등을 전달하며)

```swift
override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    
    if action == #selector(UIResponderStandardEditActions.paste(_:)) {
        return false
    }
    
    return super.canPerformAction(action, withSender: sender)
  }
```

<img src="/Resources/PasteAction.png">
<br />

### ☑️  화면에서 홈으로 이동했다가 다시 돌아오면 viewWillAppear(_:) 가 호출되지 않는다.

이 경우 animation 을 어떻게 다시 Trigger 해줄수 있을까?

- 응 노티 써~ 🆗
- `UIScene.willEnterForegroundNotification`
<br />

### ☑️  네비게이션 바 컬러 적용 안됨

- `barTintColor`
    - navigationBar.backgroundColor 로 시도했었다. 이거 계속 반복하는 실수 같음
    
<br />

### ☑️  Fatal Error: Float 이 NaN 이거나  Infinite 일 때  Int 로 타입 컨버젼 시도

- `.isNaN`, `isInfinite` 으로 분기 처리해주세요
<br />

### (해결 중) UIAlertController 중복 코드좀 없애고 싶다 !!!😡

[UIAlertController with Function Builders](https://felginep.github.io/2020-03-10/uialertcontroller-function-builders)
<br />

### ~~(해결 중) 앱과 거의 같은 생명주기를 가지는 객체의 deinit 추적~~

~~어떻게 하지..? 브레이크 포인트에 안걸린다~~

```swift
deinit {
    print(#function)
    saveUserInfo()
}
```