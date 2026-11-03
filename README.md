# DALM Frontend

서로 다른 사람의 사진에서 우연히 닮은 순간을 발견하고, 한 장의 엽서를 주고받는 AI 사진 매칭 앱의 Flutter 클라이언트입니다.

## 개발 환경

- Flutter 3.47.1 (stable)
- Dart 3.13.1
- Android / iOS
- 앱 이름: `DALM`
- Bundle ID / Application ID: `com.goodshot.dalm`
- 상태 관리 및 의존성 주입: Riverpod
- 구조: Feature-first Clean Architecture + MVVM

Flutter 버전은 `.fvmrc`에 고정합니다. FVM을 사용하지 않는 경우에도 팀원이 동일한 Flutter 버전을 설치해 주세요.

```bash
flutter --version
flutter pub get
flutter run
```

## 프로젝트 구조

```text
lib/
├── app/                         # 앱 진입점, 라우팅, 전역 테마
├── core/                        # 기능에 종속되지 않는 공통 코드
└── features/
    └── photo/                   # 기능별 Clean Architecture 예시
        ├── data/
        │   ├── datasources/
        │   ├── dtos/
        │   ├── mappers/
        │   └── repositories/
        ├── domain/
        │   ├── entities/
        │   ├── repositories/
        │   └── usecases/
        └── presentation/
            ├── states/
            ├── view_models/
            ├── views/
            └── widgets/
```

상세한 레이어 책임과 의존성 규칙은 [docs/architecture.md](docs/architecture.md)를 참고하세요.

## 디자인 시스템

- `DalmPalette`: Figma에서 추출한 원시 색상. 테마 구성 외 화면에서 직접 사용하지 않습니다.
- `DalmColors`: `textPrimary`, `primaryAction`처럼 역할을 나타내는 의미 기반 색상입니다.
- `DalmTypography`: Inter 기반 UI 서체와 Noto Serif KR 기반 감성 문구 스타일입니다.
- 폰트 파일과 라이선스는 `assets/fonts/`에서 관리합니다.

## 브랜치 전략

- `main`: 배포 가능한 안정 버전
- `develop`: 다음 배포를 위한 통합 개발 브랜치
- `feature/{기능명}`: 기능 작업 브랜치. `develop`에서 생성하고 `develop`으로 PR을 보냅니다.

```bash
git switch develop
git pull origin develop
git switch -c feature/photo-upload
```

## 커밋 규칙

| 타입 | 용도 |
| --- | --- |
| `feat` | 새로운 기능 |
| `fix` | 버그 수정 |
| `refactor` | 기능 변화 없는 구조 개선 |
| `design` | UI 및 디자인 변경 |
| `docs` | 문서 변경 |
| `test` | 테스트 추가 또는 수정 |
| `chore` | 빌드, 설정, 의존성 변경 |

예: `feat: 사진 업로드 화면 구현`

## 기본 검증

PR을 올리기 전에 아래 명령을 통과시킵니다.

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

# DALM Flutter 개발 가이드

## 1. 기본 개발 환경

- Flutter 버전: `3.47.1`
- 지원 플랫폼: Android, iOS
- 상태 관리 및 의존성 주입: Riverpod
- 아키텍처: Feature-first Clean Architecture + MVVM
- 개발은 `develop` 브랜치를 기준으로 진행한다.
- 기능 개발은 `feat/{기능명}` 브랜치를 생성한다.

```bash
git switch develop
git pull origin develop
git switch -c feat/photo-picker
```

---

## 2. 전체 폴더 구조

```text
lib/
├── main.dart
│
├── app/
│   ├── app.dart
│   ├── router/
│   └── theme/
│
├── core/
│   ├── error/
│   ├── network/
│   ├── storage/
│   └── widgets/
│
└── features/
    └── photo/
        ├── data/
        │   ├── datasources/
        │   ├── dtos/
        │   ├── mappers/
        │   └── repositories/
        │
        ├── domain/
        │   ├── entities/
        │   ├── repositories/
        │   └── usecases/
        │
        └── presentation/
            ├── states/
            ├── view_models/
            ├── views/
            └── widgets/
```

---

## 3. 최상위 폴더 역할

### `app`

앱 전체 설정을 관리한다.

- 앱 시작 설정
- 라우팅
- 전역 테마
- 전역 디자인 시스템

```text
app/
├── app.dart
├── router/
└── theme/
```

기능 전용 코드는 `app`에 작성하지 않는다.

### `core`

여러 기능이 공통으로 사용하는 코드를 관리한다.

```text
core/
├── error/       # 공통 오류 타입
├── network/     # API Client, Interceptor
├── storage/     # SecureStorage, SharedPreferences
└── widgets/     # 공통 버튼, 다이얼로그
```

한 기능에서만 사용하는 코드는 `core`에 넣지 않는다.

실제로 두 개 이상의 기능에서 사용할 때 `core`로 이동한다.

### `features`

기능별 코드를 관리한다.

```text
features/
├── onboarding/
├── auth/
├── home/
├── photo/
├── match/
├── moment/
├── postcard/
├── notification/
├── profile/
└── safety/
```

기능 하나가 자신의 UI, 상태, 비즈니스 로직, 데이터 처리를 소유한다.

---

## 4. Data 레이어

서버, 로컬 저장소, 카메라 등 외부 데이터와 직접 연결되는 영역이다.

```text
data/
├── datasources/
├── dtos/
├── mappers/
└── repositories/
```

### `datasources`

실제 외부 기능을 호출한다.

- REST API 호출
- 카메라 실행
- 갤러리 실행
- 로컬 데이터베이스 접근
- SecureStorage 접근
- SharedPreferences 접근

```dart
abstract interface class PhotoPickerDataSource {
  Future<String?> pickFromGallery();

  Future<String?> takePhoto();
}
```

### `dtos`

서버 요청과 응답의 JSON 구조를 표현한다.

```dart
class PhotoDto {
  const PhotoDto({
    required this.photoId,
    required this.imageUrl,
    required this.matchStatus,
  });

  final int photoId;
  final String imageUrl;
  final String matchStatus;
}
```

#### DTO 규칙

- 서버 필드와 최대한 동일하게 작성한다.
- JSON 변환은 DTO에서만 처리한다.
- 화면에서 DTO를 직접 사용하지 않는다.
- 추후 `json_serializable`을 적용한다.

### `mappers`

DTO와 Entity 사이를 변환한다.

```dart
extension PhotoDtoMapper on PhotoDto {
  PhotoEntity toEntity() {
    return PhotoEntity(
      id: photoId,
      imageUrl: imageUrl,
      status: switch (matchStatus) {
        'SEARCHING' => MatchStatus.searching,
        'MATCHED' => MatchStatus.matched,
        _ => MatchStatus.failed,
      },
    );
  }
}
```

### `repositories`

Domain의 Repository 인터페이스를 실제로 구현한다.

```dart
class PhotoRepositoryImpl implements PhotoRepository {
  PhotoRepositoryImpl(this.dataSource);

  final PhotoRemoteDataSource dataSource;

  @override
  Future<PhotoEntity> uploadPhoto(String imagePath) async {
    final dto = await dataSource.uploadPhoto(imagePath);

    return dto.toEntity();
  }
}
```

---

## 5. Domain 레이어

앱의 핵심 데이터와 비즈니스 규칙을 관리한다.

```text
domain/
├── entities/
├── repositories/
└── usecases/
```

Domain은 다음 내용을 알면 안 된다.

- JSON
- HTTP
- Dio
- Widget
- BuildContext
- 화면 디자인

### `entities`

앱 내부에서 사용하는 핵심 모델이다.

```dart
class PhotoEntity {
  const PhotoEntity({
    required this.id,
    required this.imageUrl,
    required this.status,
  });

  final int id;
  final String imageUrl;
  final MatchStatus status;
}

enum MatchStatus {
  searching,
  matched,
  failed,
}
```

### `repositories`

기능에 필요한 동작을 인터페이스로 정의한다.

```dart
abstract interface class PhotoRepository {
  Future<PhotoEntity> uploadPhoto(String imagePath);
}
```

Repository 인터페이스는 기능의 구현 방법을 모르고 필요한 동작만 정의한다.

### `usecases`

하나의 사용자 행동이나 비즈니스 규칙을 표현한다.

```dart
class UploadPhotoUseCase {
  const UploadPhotoUseCase(this.repository);

  final PhotoRepository repository;

  Future<PhotoEntity> call(String imagePath) {
    return repository.uploadPhoto(imagePath);
  }
}
```

#### UseCase 예시

- 사진 선택
- 사진 업로드
- 사진 유효성 확인
- 매칭 시작
- 엽서 전송
- 로그인
- 로그아웃

단순 전달만 하고 별도 규칙이 없다면 UseCase를 무조건 만들 필요는 없다.

---

## 6. Presentation 레이어

화면과 화면 상태를 관리한다.

```text
presentation/
├── states/
├── view_models/
├── views/
└── widgets/
```

### `states`

화면에 필요한 상태를 표현한다.

```dart
class PhotoSelectionState {
  const PhotoSelectionState({
    this.imagePath,
    this.isLoading = false,
    this.errorMessage,
  });

  final String? imagePath;
  final bool isLoading;
  final String? errorMessage;

  PhotoSelectionState copyWith({
    String? imagePath,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PhotoSelectionState(
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
```

#### State 규칙

- State는 immutable하게 작성한다.
- 기존 객체의 필드를 직접 수정하지 않는다.
- 새로운 State 객체로 교체한다.
- View에 필요한 정보만 포함한다.
- DTO를 State에 직접 저장하지 않는다.

### `view_models`

Riverpod Notifier를 사용해 상태를 변경한다.

```dart
final photoSelectionProvider =
    NotifierProvider<PhotoSelectionViewModel, PhotoSelectionState>(
      PhotoSelectionViewModel.new,
    );

class PhotoSelectionViewModel extends Notifier<PhotoSelectionState> {
  @override
  PhotoSelectionState build() {
    return const PhotoSelectionState();
  }

  Future<void> pickFromGallery() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final useCase = ref.read(
        pickPhotoFromGalleryUseCaseProvider,
      );

      final imagePath = await useCase();

      state = state.copyWith(
        imagePath: imagePath,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '사진을 가져오지 못했습니다.',
      );
    }
  }
}
```

#### ViewModel 규칙

- ViewModel에 `BuildContext`를 전달하지 않는다.
- ViewModel에서 Widget을 만들지 않는다.
- ViewModel에서 화면 이동을 직접 처리하지 않는다.
- API를 직접 호출하지 않는다.
- UseCase 또는 Repository를 사용한다.
- 상태 변경은 ViewModel에서 처리한다.

### `views`

전체 화면을 작성한다.

```dart
class PhotoSelectionView extends ConsumerWidget {
  const PhotoSelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(photoSelectionProvider);

    return Scaffold(
      body: Center(
        child: Text(
          state.imagePath ?? '사진을 선택해 주세요.',
        ),
      ),
    );
  }
}
```

#### View 규칙

- View에 복잡한 비즈니스 로직을 작성하지 않는다.
- 상태는 `ref.watch()`로 구독한다.
- 버튼 이벤트는 `ref.read()`로 전달한다.
- Snackbar, Dialog, 화면 이동은 `ref.listen()`으로 처리한다.
- View에서 API를 직접 호출하지 않는다.
- View에서 DTO를 직접 사용하지 않는다.

### `widgets`

해당 기능 안에서만 재사용하는 UI를 작성한다.

```text
photo/presentation/widgets/
├── photo_preview.dart
├── photo_source_bottom_sheet.dart
└── upload_progress_indicator.dart
```

여러 기능에서 동일하게 사용하게 되면 `core/widgets`로 이동한다.

---

## 7. 파일 이름 규칙

| 종류 | 파일 이름 | 클래스 이름 |
| --- | --- | --- |
| DTO | `photo_dto.dart` | `PhotoDto` |
| Entity | `photo_entity.dart` | `PhotoEntity` |
| Mapper | `photo_mapper.dart` | `PhotoDtoMapper` |
| Repository 인터페이스 | `photo_repository.dart` | `PhotoRepository` |
| Repository 구현체 | `photo_repository_impl.dart` | `PhotoRepositoryImpl` |
| UseCase | `upload_photo_use_case.dart` | `UploadPhotoUseCase` |
| State | `photo_upload_state.dart` | `PhotoUploadState` |
| ViewModel | `photo_upload_view_model.dart` | `PhotoUploadViewModel` |
| View | `photo_upload_view.dart` | `PhotoUploadView` |
| Widget | `photo_preview.dart` | `PhotoPreview` |

- 파일 이름은 `snake_case`를 사용한다.
- 클래스 이름은 `PascalCase`를 사용한다.
- 변수와 함수 이름은 `camelCase`를 사용한다.
- Provider 이름은 `{기능명}Provider` 형태를 사용한다.

---

## 8. Riverpod 사용 규칙

### 상태 표시

```dart
final state = ref.watch(photoSelectionProvider);
```

- 상태가 변경되면 화면이 다시 그려진다.
- 주로 Widget의 `build()` 안에서 사용한다.

### 이벤트 전달

```dart
ref
    .read(photoSelectionProvider.notifier)
    .pickFromGallery();
```

사용 예시:

- 버튼 클릭
- 새로고침
- 사진 선택
- 사진 업로드
- 엽서 전송
- 평가 전송

### 부수 효과

```dart
ref.listen(photoUploadProvider, (previous, next) {
  // Snackbar, 화면 이동, Dialog
});
```

정리하면 다음과 같다.

```text
watch  → 화면에 상태 표시
read   → 사용자 이벤트 전달
listen → Snackbar, Dialog, 화면 이동
```

---

## 9. 상태 관리 기준

### Riverpod으로 관리하는 상태

- API 요청 결과
- 선택한 사진
- 사진 업로드 상태
- 로그인 사용자
- 매칭 진행 상태
- 여러 Widget이 공유하는 데이터
- 화면을 벗어나도 유지해야 하는 데이터
- 단위 테스트가 필요한 상태

### `setState`로 관리해도 되는 상태

- 비밀번호 표시 여부
- 단순 탭 선택
- 애니메이션
- FocusNode
- TextEditingController
- 한 Widget 안에서만 사용하는 임시 UI 상태

판단 기준은 다음과 같다.

> 단순한 UI 표현 상태라면 `setState`, 앱의 업무 상태라면 Riverpod을 사용한다.

---

## 10. 데이터 흐름

모든 기능은 기본적으로 다음 흐름을 따른다.

```text
사용자 입력
→ View
→ ViewModel
→ UseCase
→ Repository
→ DataSource
→ API
```

API 응답은 반대 방향으로 전달된다.

```text
API JSON
→ DTO
→ Mapper
→ Entity
→ ViewModel State
→ View
```

다음 규칙을 지킨다.

- View에서 API를 직접 호출하지 않는다.
- View에서 DTO를 직접 표시하지 않는다.
- Domain에서 Dio와 JSON을 사용하지 않는다.
- DataSource의 결과를 필요한 경우 Mapper로 변환한다.
- ViewModel은 Entity 또는 화면 전용 State를 사용한다.

---

## 11. 기능 개발 순서

새로운 기능은 다음 순서로 작성한다.

1. Figma 화면과 필요한 상태를 확인한다.
2. API 명세를 확인한다.
3. Entity를 정의한다.
4. Repository 인터페이스를 정의한다.
5. DTO와 Mapper를 작성한다.
6. DataSource와 Repository 구현체를 작성한다.
7. 필요한 경우 UseCase를 작성한다.
8. State와 ViewModel을 작성한다.
9. View와 Widget을 작성한다.
10. 로딩·성공·실패 상태를 테스트한다.

카메라 선택처럼 API가 없는 기능은 필요한 레이어만 만든다.

빈 폴더를 채우기 위해 DTO, Mapper, Repository를 억지로 만들지 않는다.

---

## 12. 공통 Widget 규칙

여러 기능에서 동일한 디자인과 동작이 반복될 때 `core/widgets`로 분리한다.

```text
core/widgets/
├── buttons/
│   └── dalm_button.dart
├── app_bars/
│   └── dalm_app_bar.dart
├── inputs/
│   └── dalm_text_field.dart
├── media/
│   └── dalm_photo_frame.dart
├── feedback/
│   ├── dalm_loading_view.dart
│   ├── dalm_error_view.dart
│   └── dalm_empty_view.dart
└── layout/
    └── dalm_bottom_action.dart
```

공통 Widget으로 분리하는 기준은 다음과 같다.

- 두 개 이상의 기능에서 반복된다.
- 디자인과 동작 규칙이 동일하다.
- 한 곳에서 수정했을 때 모든 화면에 적용되어야 한다.
- 특정 기능의 Entity나 State에 종속되지 않는다.

기능 전용 Widget은 해당 기능 내부에 둔다.

```text
features/postcard/presentation/widgets/postcard_card.dart
features/moment/presentation/widgets/photo_pair.dart
features/match/presentation/widgets/similarity_bar.dart
```

---

## 13. 공통 버튼 규칙

버튼의 배경색과 글씨색을 직접 전달하지 않고 Variant로 구분한다.

```dart
enum DalmButtonVariant {
  primary,
  accent,
  secondary,
  destructive,
}
```

| Variant | 용도 | 디자인 |
| --- | --- | --- |
| `primary` | 일반적인 주요 행동 | 검은 배경, 흰 글씨 |
| `accent` | 감성적인 주요 행동 | 금색 배경, 검은 글씨 |
| `secondary` | 보조 행동 | 흰 배경, 검은 글씨, 테두리 |
| `destructive` | 삭제 및 위험 행동 | 붉은 글씨 또는 붉은 배경 |

```dart
DalmButton(
  label: '이 엽서 보내기',
  variant: DalmButtonVariant.accent,
  onPressed: sendPostcard,
)
```

버튼이 받을 기본 파라미터는 다음과 같다.

- `label`
- `onPressed`
- `variant`
- `isLoading`
- `trailing`

버튼 컴포넌트 안에서 API 호출이나 화면 이동을 직접 처리하지 않는다.

---

## 14. Git 및 PR 규칙

### 브랜치

```text
main           배포 가능한 안정 코드
develop        통합 개발 코드
feat/{기능명}  기능 개발
fix/{기능명}   버그 수정
```

### PR 대상

- 기능 브랜치는 `develop`에서 생성한다.
- 모든 기능 PR은 `develop`으로 보낸다.
- 본인의 PR을 바로 Merge하지 않는다.
- 상대방이 최소 한 번 확인한다.

### PR 전 확인

```bash
dart format lib test
flutter analyze
flutter test
```

확인 항목:

- 파일이 올바른 레이어에 있는가?
- View에서 API를 직접 호출하지 않았는가?
- DTO를 View에서 직접 사용하지 않았는가?
- 로딩·성공·실패 상태를 처리했는가?
- 불필요한 `setState`를 사용하지 않았는가?
- UI 변경이면 스크린샷을 첨부했는가?
- 테스트와 정적 분석이 통과하는가?

## 학교 AWS HTTP API 연결

AWS의 현재 주소를 전달받은 뒤 아래 명령으로 로컬 `.env`를 갱신합니다.
실제 서버 IP와 로그인 키는 커밋하지 않습니다.

```bash
dart run tool/configure_api.dart http://YOUR_EC2_PUBLIC_IP/v1/
flutter clean
flutter run
```

기존 Kakao 키는 보존합니다. Android는 `.env`의 API 호스트에만 HTTP를 허용하는
네트워크 설정을 빌드 시 생성하며, release의 INTERNET 권한도 포함합니다.
iOS는 `DALM_HTTP_HOST`에만 ATS 예외를 적용하고 전역 ATS 해제는 하지 않습니다.
HTTP API 데이터와 토큰은 전송 중 암호화되지 않습니다. S3 사진 URL은 HTTPS를 유지합니다.
IP가 변경되거나 EIP를 부착하면 같은 명령으로 다시 설정하고 앱을 재빌드합니다.

실기기에서는 Kakao/Apple 로그인, 토큰 재발급, 사진 업로드·조회까지 확인해야 합니다.

플랫폼 정책 참고: [Android Network Security Configuration](https://developer.android.com/privacy-and-security/security-config),
[Apple ATS 예외 도메인](https://developer.apple.com/documentation/bundleresources/information-property-list/nsapptransportsecurity/nsexceptiondomains).
