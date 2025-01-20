# 간단한 일기장/메모 앱 DiaryMemo
<div align="center">
  <img src="https://github.com/user-attachments/assets/e1506db2-a3bf-42f4-8901-a559921d1b94" alt="DiaryMemo_icon" width="300px"/>
  <h3>DiaryMemo</h3>
</div>

이 프로젝트의 목표는 주로 학습 목적에 있었습니다. 가장 쉽게 접근할 수 있는 기능인 CRUD를 활용하여 새로운 아키텍처와 라이브러리 활용 능력 향상을 목표로 프로젝트를 기획하게 되었습니다.
일기장/메모 앱을 만들면서 ReactorKit아키텍처와 RxSwift를 도입해보았으며, 이를 통해 단방향 데이터 흐름을 알 수 있었고 RxSwift를 통해 UI 상태 및 비동기 작업을 효율성에 대해 공부할 수 있었습니다.
또한 재사용 가능한 UI 컴포넌트를 만들어 ```convinience init```을 통해 여러 parameter로 커스텀이 가능하도록 만드는 등의 모듈화된 방식으로 활용했습니다.
이를 통해 컴포넌트 단위로 재사용가능한 UI를 만들어 UI작업에 대한 개발 시간을 단축할 수 있었고, ReactorKit 아키텍처의 State, Action, Mutate에 맞는 구조를 구현하도록 노력했습니다.

## 앱스토어: https://apps.apple.com/kr/app/diarymemo/id6740481010
## 개발도구 및 스택
- **언어:** Swift 5.10
- **라이브러리:**
    - FSCalendar 2.8.4
    - ReactorKit 3.2.0
    - RxSwift 6.8.0
    - SnapKit 5.7.1
- **데이터 관리:** CoreData

## 트러블 슈팅
1. CoreData에 Data타입으로 저장된 이미지를 반복적인 화면 이동을 통해 불러올때 메모리가 지속적으로 증가
2. UIImage는 내부적으로 캐시를 사용하는데 반복적인 이미지 로딩이 발생할 때 이전 캐시가 제대로 해제되지 않는 문제로 추측

```수정 전```
<div align="center">
  <img src="https://github.com/user-attachments/assets/b3ebfbb2-7f0f-429c-8098-1a68031d840a" alt="DiaryMemo_icon" width="700px"/>
</div>

```수정 후```
<div align="center">
  <img src="https://github.com/user-attachments/assets/aa361531-1cc1-4086-9096-4a6c832cbafc" alt="DiaryMemo_icon" width="700px"/>
  <h4>사진과 같이 캐시에 특정 key로 저장된 이미지가 있으면 해당 이미지를 불러오고 그렇지 않으면 캐시에 저장후 이미지 불러오도록 수정</h4>
</div>

```수정 전```
<div align="center">
  <img src="https://github.com/user-attachments/assets/3e0f9f95-7338-4381-a13b-6cd945b11d5d" alt="DiaryMemo_icon" width="700px"/>
</div>
<div align="center">
  <img src="https://github.com/user-attachments/assets/78f4f9ca-2189-463f-9f59-ed91029162df" alt="DiaryMemo_icon" width="250px"/>
</div>

```수정 후```
<div align="center">
  <img src="https://github.com/user-attachments/assets/73ec6260-1f82-4535-b850-f4a73325999d" alt="DiaryMemo_icon" width="700px"/>
</div>
<div align="center">
  <img src="https://github.com/user-attachments/assets/81951322-01eb-4d09-9fe3-231ac6d35e4b" alt="DiaryMemo_icon" width="250px"/>
</div>

> 또한 앱이 백그라운드로 진입시 메모리를 계속 할당하지 않게 하기 위해서 ```SceneDelegate```의 ```func sceneDidEnterBackground(_ scene: UIScene)```에 ```removeAllObjects()```를 사용해 캐시에 저장된 이미지를 모두 삭제하는 로직을 추가하였습니다.

