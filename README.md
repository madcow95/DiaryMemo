# 간단한 일기장/메모 앱 DiaryMemo
<div align="center">
  <img src="https://github.com/user-attachments/assets/e1506db2-a3bf-42f4-8901-a559921d1b94" alt="DiaryMemo_icon" width="300px"/>
  <h3>DiaryMemo</h3>
</div>

이 프로젝트는 주로 학습 목적으로 진행되었고, CRUD 기능을 기반으로 새로운 아키텍처와 라이브러리 활용 능력 향상을 목표로 했습니다.
DiaryMemo앱을 제작하며 ReactorKit 아키텍처와 RxSwift를 도입하여 단방향 데이터 흐름을 구현하고, UI 상태 관리와 비동기 작업의 효율성에 대해 공부할 수 있었습니다.
또한 ```convinience init```을 통해 여러 parameter로 커스텀하여 재사용 가능한 UI 컴포넌트를 만드는 모듈화된 방식으로 활용한 결과 UI작업에 대한 개발 시간을 단축할 수 있었습니다.
이 프로젝트를 통해 ReactorKit 아키텍처의 State, Action, Mutate에 맞는 구조를 구현하도록 노력했습니다.

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
1. CoreData에 저장된 이미지를 반복적으로 로드할 때 메모리 사용량이 지속적으로 증가
2. UIImage는 내부적으로 캐시를 사용하는데 반복적인 이미지 로딩이 발생할 때 이전 캐시가 제대로 해제되지 않는 문제로 추측

```수정 전```
<div align="center">
  <img src="https://github.com/user-attachments/assets/b3ebfbb2-7f0f-429c-8098-1a68031d840a" alt="DiaryMemo_icon" width="700px"/>
</div>

```수정 후```
<div align="center">
  <img src="https://github.com/user-attachments/assets/aa361531-1cc1-4086-9096-4a6c832cbafc" alt="DiaryMemo_icon" width="700px"/>
  <h4>캐시에 특정 키로 저장된 이미지가 있는 경우 해당 이미지를 재사용하고, 없는 경우에만 새로 로드하여 캐시에 저장</h4>
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

> 또한 앱이 백그라운드로 진입시 메모리를 계속 할당하지 않게 하기 위해서 ```SceneDelegate```의 ```func sceneDidEnterBackground(_ scene: UIScene)```에 ```removeAllObjects()```를 사용해 캐시에 저장된 이미지를 모두 삭제해 불필요한 메모리 점유 방지했습니다.

