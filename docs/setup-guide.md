# 📝 Vue.js & Keycloak Docker Demo: 상세 가이드

이 문서는 Vue.js, Keycloak, Docker를 함께 사용하여 인증 시스템을 구축하는 전체 과정을 안내합니다.

---

## 🚀 1. 프로젝트 시작하기

프로젝트를 로컬 환경에서 실행하는 방법은 다음과 같습니다.

### 가. Docker 서비스 시작

먼저 `docker-compose.yml` 설정을 기반으로 Keycloak과 데이터베이스 서버를 시작합니다.

```bash
docker-compose up -d
```

실행 후 다음 주소로 서비스가 시작됩니다.
- **Keycloak**: `http://localhost:8080`
- **PostgreSQL**: `localhost:5432` (컨테이너 내부에서만 접근 가능)

---

## ⚙️ 2. Keycloak 초기 설정

Docker 컨테이너가 정상적으로 실행된 후, Keycloak 관리자 콘솔에서 초기 설정을 진행합니다.

1.  **관리자 로그인**
    - `http://localhost:8080` 으로 접속하여 관리자 계정(`admin`/`admin`)으로 로그인합니다.

2.  **Realm 생성**
    - 새로운 **Realm**을 생성합니다. (예: `my-realm`)

3.  **Client 생성**
    - 생성한 Realm의 **Clients** 메뉴로 이동하여, Vue.js 애플리케이션을 위한 새 **Client**를 생성합니다. (예: `my-vue-app`)
    - 아래와 같이 필수 항목을 설정합니다.
        - **Access Type**: `public`
        - **Valid Redirect URIs**: `http://localhost:5173/*`
        - **Web Origins**: `http://localhost:5173`

4.  **커스텀 테마 적용**
    - **Realm Settings** > **Themes** 탭으로 이동합니다.
    - **Login Theme** 드롭다운 메뉴에서 `custom-theme`을 선택하고 **Save**를 누릅니다.

---

## 🎨 3. Keycloak 테마 개발 (UI 커스터마이징)

Keycloak 로그인 페이지의 UI를 직접 수정하려면 다음 단계를 따릅니다.

1.  **테마 디렉토리로 이동**
    - 별도의 터미널을 열고 테마 디렉토리로 이동합니다.
    ```bash
    cd keycloak-themes/custom-theme
    ```

2.  **의존성 설치 (최초 1회)**
    - `npm` 패키지를 설치합니다.
    ```bash
    npm install
    ```

3.  **실시간 CSS 빌드**
    - 아래 명령어를 실행하여 Tailwind CSS 빌드를 시작합니다.
    ```bash
    npm run build
    ```
    > ℹ️ **Note:** 이 명령은 `.ftl` 파일의 변경 사항을 감지하여 `login/resources/css/styles.css`를 자동으로 업데이트합니다. 개발하는 동안 이 터미널을 계속 실행 상태로 두세요.

---

## 🌐 4. Vue.js 프론트엔드 실행

이제 Vue.js 개발 서버를 시작할 차례입니다.

1.  **의존성 설치**
    - 프로젝트 루트 디렉토리에서 `npm` 패키지를 설치합니다.
    ```bash
    npm install
    ```

2.  **개발 서버 시작**
    - 아래 명령어로 개발 서버를 시작합니다.
    ```bash
    npm run dev
    ```

3.  **결과 확인**
    - 웹 브라우저에서 `http://localhost:5173`으로 접속하여 결과를 확인합니다.

---

## 🔗 5. Google 소셜 로그인 연동

Google 계정을 사용한 "기존 회원 로그인" 및 "신규 회원 자동 가입" 기능을 설정합니다.

### 가. 1단계: Google Cloud Console에서 OAuth 클라이언트 생성

1.  **프로젝트 및 OAuth 동의 화면 설정**
    - [Google Cloud Console](https://console.cloud.google.com/)에 접속하여 새 프로젝트를 생성하거나 기존 프로젝트를 선택합니다.
    - **API 및 서비스 > OAuth 동의 화면**에서 `External`(외부) 타입을 선택하고 필요한 앱 정보를 입력합니다.

2.  **OAuth 클라이언트 ID 생성**
    - **사용자 인증 정보 > 사용자 인증 정보 만들기 > OAuth 클라이언트 ID**를 선택합니다.
    - 아래 내용을 참고하여 설정을 완료합니다.
        - **애플리케이션 유형**: `웹 애플리케이션`
        - **승인된 리디렉션 URI**: 아래 주소를 추가합니다.
            ```text
            http://localhost:8080/realms/my-realm/broker/google/endpoint
            ```
            > ⚠️ **중요**: 주소의 `my-realm` 부분은 **2. Keycloak 초기 설정** 단계에서 생성한 실제 Realm 이름과 반드시 일치해야 합니다.

3.  **클라이언트 ID와 Secret 확인**
    - 생성이 완료되면 **클라이언트 ID**와 **클라이언트 보안 비밀**이 표시됩니다. 이 값들을 다음 단계에서 사용하기 위해 복사해 둡니다.

### 나. 2단계: Keycloak에 Google Identity Provider 설정

1.  **Google Provider 추가 및 정보 입력**
    - Keycloak 관리자 콘솔에서 **Identity Providers** 메뉴로 이동하여 **Google**을 선택합니다.
    - 이전 단계에서 복사한 `Client ID`와 `Client Secret`을 각각 붙여넣습니다.

2.  **상세 설정**
    - **Scopes**: `openid profile email`을 입력합니다. (기본값)
    - **Advanced settings**를 펼쳐 다음 두 항목을 설정합니다.
        - **Trust Email**: `ON`
        - **Sync Mode**: `import`
            > ✨ **Tip**: 위 두 옵션을 활성화하면, 사용자가 별도의 프로필 검토나 이메일 인증 없이 즉시 로그인 및 가입할 수 있어 사용자 경험(UX)이 크게 향상됩니다.

3.  **저장**
    - **Save** 버튼을 클릭하면 설정이 완료되고, Keycloak 로그인 페이지에 Google 로그인 버튼이 나타납니다.

### 다. 3단계: 신규 사용자 로그인 절차 간소화 (선택 사항)

최초 소셜 로그인 시, Keycloak이 사용자 프로필 정보를 검토하는 중간 단계를 생략하여 즉시 가입 및 로그인을 완료시키는 방법입니다.

1.  **Authentication 흐름 복제**
    - **Authentication** > **Flows** 탭으로 이동합니다.
    - 시스템 기본 흐름인 `first broker login`을 찾아 우측의 **Duplicate** 버튼을 클릭합니다.
    - 복제된 흐름에 식별하기 쉬운 이름(예: `Google Auto Login`)을 지정하고 저장합니다.

2.  **Review Profile 단계 비활성화**
    - 복제한 `Google Auto Login` 흐름의 설정 화면으로 이동합니다.
    - `Review Profile (Create User If Unique)` 항목의 `REQUIRED` 설정을 `DISABLED`로 변경합니다.

3.  **Provider에 신규 흐름 적용**
    - 다시 **Identity Providers** > **Google** 설정으로 돌아옵니다.
    - **Advanced settings** > **First Login Flow** 항목을 방금 생성한 `Google Auto Login`으로 변경하고 저장합니다.

---

## 🔗 6. Keycloak 메세지 한글화 & 다국어 지원화

Keycloak이 제공하는 기본 메세지(예: 'Username or email')를 한글화하고, 다국어 환경을 지원하는 방법을 안내합니다.

### 가. 1단계: Keycloak 서버에 한글 언어팩 활성화

1.  **Keycloak 관리자 콘솔 접속**
    - Keycloak 관리자 콘솔에 접속하여 **Realm Settings > Localization** 탭으로 이동합니다.

2.  **지원 언어 추가**
    - **Supported Locales** 목록에서 `Korean(ko)`을 찾아 추가합니다.

3.  **기본 언어 설정 (선택 사항)**
    - **Default Locale**을 `ko`로 설정하면 해당 Realm의 모든 UI가 기본적으로 한글로 표시됩니다.

4.  **저장**
    - **Save** 버튼을 클릭하여 설정을 완료합니다. 이제 Keycloak UI에서 언어 선택 메뉴가 활성화됩니다.

### 나. 2단계: 커스텀 테마에 다국어 지원 설정

1.  **지원 언어 등록 (`theme.properties`)**
    - `keycloak-themes/custom-theme/login/theme.properties` 파일을 열고, `locales` 속성에 지원할 언어 목록을 추가합니다.
    ```properties
    parent=keycloak
    import=common/keycloak
    styles=css/styles.css
    locales=ko, en
    ```
    > 이 설정을 통해 Keycloak은 해당 테마가 한국어(`ko`)와 영어(`en`)를 지원한다는 사실을 인지합니다.

2.  **한글 메세지 파일 추가 (`messages_ko.properties`)**
    - `keycloak-themes/custom-theme/login/messages` 디렉토리 안에 `messages_ko.properties` 파일을 생성하고, 번역할 메세지를 `키=값` 형식으로 작성합니다.
    ```properties
    # 로그인 페이지 제목
    loginTitle=환영합니다!

    # 사용자 이름 및 이메일 레이블
    usernameOrEmail=아이디 또는 이메일

    # 비밀번호 레이블
    password=비밀번호

    # 'Forgot Password?' 링크
    doForgotPassword=비밀번호를 잊으셨나요?
    ```
    > ✨ **Tip**: Keycloak이 사용하는 전체 메세지 키 목록은 [Keycloak 공식 GitHub 리포지토리](https://github.com/keycloak/keycloak/blob/main/themes/src/main/resources/theme/base/login/messages/messages_en.properties)에서 확인할 수 있습니다.

### 다. 3단계: `.ftl` 파일에서 메세지 키 사용하기

FreeMarker 템플릿(`.ftl`) 파일에서 하드코딩된 텍스트 대신, 방금 정의한 메세지 키를 사용하도록 수정합니다.

1.  **템플릿 파일 열기**
    - `keycloak-themes/custom-theme/login/login.ftl` 파일을 엽니다.

2.  **메세지 키로 대체**
    - 이메일 입력 필드의 레이블을 예로 들어 보겠습니다. 기존 코드를 아래와 같이 변경합니다.
    - **변경 전 (하드코딩된 텍스트)**
      ```html
      <label for="username" class="${properties.kcLabelClassName!}">Username or email</label>
      ```
    - **변경 후 (메세지 키 사용)**
      ```html
      <label for="username" class="${properties.kcLabelClassName!}">${msg('usernameOrEmail')}</label>
      ```
      > `msg()` 함수는 Keycloak이 현재 설정된 언어에 맞는 메세지를 자동으로 찾아 출력해주는 역할을 합니다.

3.  **결과 확인**
    - Keycloak 로그인 페이지에 다시 접속하여 언어 설정을 한국어로 변경하면, 방금 수정한 텍스트가 한글로 표시되는 것을 확인할 수 있습니다.

---

## 🔗 7. Keycloak 회원가입 시 이메일 인증 강제 설정

Keycloak에서 회원가입 시 **이메일 인증(Email Verification)**을 강제하는 설정을 단계별로 알려드립니다.

이 기능이 작동하려면 SMTP 서버(메일 발송 서버) 설정이 필수입니다. 만약 개발 환경이라 실제 메일 서버가 없다면, 구글(Gmail)을 테스트용으로 연동하는 방법도 함께 설명해 드립니다.

### 1단계: SMTP 서버 설정 (메일 발송 준비)
Keycloak이 메일을 보낼 수 있도록 우체국(SMTP)을 연결해야 합니다.

1.  **Keycloak 관리자 콘솔** > 왼쪽 메뉴 **Realm Settings** (영역 설정).
2.  상단 **Email** 탭 클릭.
3.  **Connection settings**에 SMTP 정보를 입력합니다. (Gmail 예시)
    *   **Host**: `smtp.gmail.com`
    *   **Port**: `587`
    *   **From**: `noreply@yourdomain.com` (받는 사람에게 표시될 이메일)
    *   **Enable SSL**: `OFF` (보통 587 포트는 StartTLS 사용)
    *   **Enable StartTLS**: `ON`
    *   **Authentication**: `ON`
    *   **Username**: 본인의 Gmail 주소 (예: `test@gmail.com`)
    *   **Password**: **앱 비밀번호 (App Password)**

4.  설정 후 하단 **Test connection** 버튼을 눌러 본인 이메일로 테스트 메일이 오는지 확인합니다.
5.  성공했다면 **Save** 클릭.

#### 💡 Tip (로컬 개발용)
> Docker 환경이라면 `Mailpit` 같은 가짜 SMTP 컨테이너를 띄우고, **Host**: `mailpit`, **Port**: `1025`, **Auth**: `OFF`로 설정하면 실제 메일 발송 없이 웹 UI에서 메일을 확인할 수 있어 매우 편리합니다.

#### 🔑 Google 앱 비밀번호 생성 방법
> `앱 비밀번호`는 구글 계정의 실제 비밀번호가 아닙니다. 아래 절차에 따라 생성한 16자리 코드를 사용해야 합니다.
>
> 1.  **Google 계정 관리** 페이지로 이동합니다.
> 2.  왼쪽 메뉴에서 **보안**을 선택합니다.
> 3.  **Google에 로그인하는 방법** 섹션에서 **2단계 인증**을 클릭합니다. (2단계 인증이 비활성화 상태라면 먼저 활성화해야 합니다.)
> 4.  가장 하단으로 스크롤하여 **앱 비밀번호**를 선택합니다.
> 5.  **앱 선택**에서 `메일`, **기기 선택**에서 `기타 (맞춤 이름)`를 선택하고, 이름(예: `Keycloak Test`)을 입력한 후 **생성** 버튼을 누릅니다.
> 6.  노란색 배경에 표시된 **16자리 비밀번호**를 복사하여 Keycloak의 Password 필드에 붙여넣습니다.

### 2단계: 이메일 인증 기능 활성화
이제 Keycloak에게 "가입 시 이메일 인증을 꼭 시켜!"라고 명령합니다.

1.  왼쪽 메뉴 **Realm Settings > Login** 탭 클릭.
2.  다음 옵션들을 설정합니다.
    *   **User registration** (사용자 등록): `ON` (회원가입 링크 표시)
    *   **Forgot password** (비밀번호 찾기): `ON` (선택 사항)
    *   **Remember me** (로그인 상태 유지): `ON` (선택 사항)
    *   **Verify email** (이메일 확인): `ON` (⭐ 핵심 설정)
        > 이걸 켜면 사용자가 가입 후 링크를 클릭하기 전까지 로그인이 차단됩니다.
3.  **Save** 클릭.

### 3단계: 테스트 진행
이제 시크릿 모드 브라우저를 열어 확인해 봅니다.

1.  로그인 페이지 접속 -> 하단 "Register(회원가입)" 링크 클릭.
2.  회원가입 양식 작성 후 **Register** 클릭.
3.  화면에 "You need to verify your email address..." 라는 안내 문구가 뜨고 로그인이 되지 않아야 정상입니다.
4.  입력한 이메일의 수신함 확인.
5.  Keycloak이 보낸 메일의 링크 클릭.
6.  "이메일이 인증되었습니다" 메시지와 함께 로그인이 성공하는지 확인.

---

## 🔗 8. Keycloak 구글 로그인 심화 가이드 (Seamless & Auto-Link)

이 가이드는 **[🔗 5. Google 소셜 로그인 연동](#-5-google-소셜-로그인-연동)** 설정을 마친 후, 사용자 경험을 더욱 향상시키기 위한 심화 설정입니다. "신규 회원은 즉시 가입, 기존 회원은 즉시 연동"되도록 구성하는 방법을 다룹니다.

### ✅ 목표 시나리오
*   **신규 유저**: 구글 로그인 시 "추가 정보 입력(Review Profile)" 없이 즉시 회원가입 및 로그인.
*   **기존 유저**: 같은 이메일을 가진 기존 계정이 있다면, "계정 연결하시겠습니까?" 질문 없이 즉시 통합 및 로그인.

### 1. Keycloak Realm 필수 설정 (중요 ⭐)
구글에서 받은 이메일로 즉시 유저를 생성하기 위해 반드시 필요한 설정입니다.

1.  Keycloak 관리자 콘솔 > 왼쪽 메뉴 **Realm Settings** (영역 설정).
2.  **Login** 탭 선택.
3.  **Email as username** (이메일을 사용자 이름으로 사용): **ON** 설정.
    > 이유: 이 설정이 꺼져 있으면 "Username 누락"으로 인해 `userId="null"` 에러가 발생합니다.
4.  **Save** 클릭.

### 2. Authentication Flow (인증 흐름) 구성
기본 흐름을 수정하여 사용자 개입 단계를 제거합니다.

1.  왼쪽 메뉴 **Authentication > Flows** 탭.
2.  `first broker login`을 찾아 우측 **...** 버튼 > **Duplicate** > 이름: `Google Auto Login`.
3.  생성된 흐름을 클릭하여 내부 구성을 아래 표와 정확히 일치시킵니다.
    *   기존에 있던 `Review Profile`, `Confirm Link`... 등은 삭제하거나 비활성화합니다.
    *   `Automatically Link Broker`는 **Add execution**으로 추가해야 합니다.

| 순서 | Execution 이름 | Requirement | 설명 |
| :--- | :--- | :--- | :--- |
| 1 | Create User If Unique | ALTERNATIVE | 유저가 없으면 생성 시도 |
| 2 | Automatically Link Broker | ALTERNATIVE | 유저가 있으면 자동 연결 |

> **주의사항**:
> *   반드시 둘 다 **ALTERNATIVE**여야 합니다. (REQUIRED가 있으면 실패 시 다음 단계로 안 넘어감)
> *   `User Creation or Linking` 같은 상위 흐름이 있다면 그 안에서 이 순서를 맞춰야 합니다.

### 3. Identity Provider 설정 업데이트
기존에 생성한 Google Provider 설정을 다음과 같이 업데이트합니다.

1.  왼쪽 메뉴 **Identity Providers > Google**.
2.  **Advanced settings** (고급 설정)을 열고 **First Login Flow**를 방금 만든 `Google Auto Login`으로 변경합니다.
3.  **Mappers 탭 점검 (에러 방지)**:
    *   **Mappers** 탭으로 이동하여 `email` 관련 매퍼가 수동으로 추가되어 있다면 **삭제**하세요.
    *   이유: 잘못 구성된 수동 매퍼는 `JSON field path` 에러를 유발합니다. 구글은 설정 없이도 이메일을 자동으로 가져옵니다.
4.  **Save** 클릭.

### 4. 트러블슈팅 (자주 겪는 에러)
*   **Q. 400 Bad Request 또는 `invalid_user_credentials` 에러가 떠요.**
    *   **원인**: Keycloak이 유저를 생성하려는데 Username이 없어서 실패한 경우입니다.
    *   **해결**: **1번 항목(Realm Settings)**에서 `Email as username`이 켜져 있는지 확인하세요.
*   **Q. `REQUIRED and ALTERNATIVE elements at same level` 에러가 떠요.**
    *   **원인**: Flow 설정에서 하나는 `REQUIRED`, 하나는 `ALTERNATIVE`로 섞여 있어서 로직이 꼬인 겁니다.
    *   **해결**: **2번 항목(Flow 구성)**표를 보고 둘 다 **ALTERNATIVE**로 맞추세요.
*   **Q. `JSON field path is not configured for mapper email` 에러가 떠요.**
    *   **원인**: Identity Provider 설정의 Mappers 탭에 설정값이 비어있는 잘못된 매퍼가 있습니다.
    *   **해결**: **3번 항목(Mappers 점검)**을 참고하여 해당 매퍼를 삭제하세요.
---

## 💾 9. Keycloak Realm 설정 백업 및 관리 (Export/Import)

Keycloak에서 설정한 Realm 정보(Client, Role, User 등)는 언제든지 백업하고 다른 환경에서 복원할 수 있습니다. 설정을 JSON 파일 형태로 내보내(Export) Git으로 버전을 관리하면 팀원들과 설정을 공유하거나, 실수로 설정을 변경했을 때 쉽게 복구할 수 있습니다.

### 가. Realm 설정 내보내기 (Export)

1.  **Keycloak 관리자 콘솔**에 접속하여 백업하려는 Realm을 선택합니다.
2.  왼쪽 메뉴 하단의 **Realm Settings**로 이동합니다.
3.  화면 우측 상단에 있는 **Action** 드롭다운 메뉴를 클릭하고 **Partial export**를 선택합니다.
4.  내보낼 항목을 선택합니다. 일반적으로 아래 두 항목을 `ON`으로 설정하면 대부분의 Realm 설정을 포함할 수 있습니다.
    *   **Export groups and roles**: 그룹 및 역할 포함 여부
    *   **Export clients**: 클라이언트 포함 여부
5.  **Export** 버튼을 클릭하면 `realm-export.json` 형태의 파일이 다운로드됩니다.

### 나. 내보낸 파일 프로젝트에 저장 및 Git 관리

1.  다운로드한 JSON 파일의 이름을 `my-realm-backup.json`과 같이 식별하기 쉽게 변경합니다.
2.  프로젝트 내 적절한 위치(예: `keycloak-config/` 디렉토리 생성 후 그 안)에 파일을 저장합니다.
3.  해당 파일을 Git에 추가하고 커밋합니다.

```bash
# 예시: keycloak-config 디렉토리를 만들고 파일을 이동
mkdir keycloak-config
mv ~/Downloads/realm-export.json keycloak-config/my-realm-backup.json

# Git에 추가
git add keycloak-config/my-realm-backup.json
git commit -m "feat: Add keycloak realm backup"
```

> ✨ **Tip**: Realm 설정을 Git으로 관리하면, Pull Request를 통해 설정 변경 내역을 코드처럼 리뷰할 수 있어 휴먼 에러를 줄이는 데 큰 도움이 됩니다.

### 다. Realm 설정 가져오기 (Import) - 참고

> ⚠️ **주의**: 이 작업은 기존 Realm 설정을 덮어쓸 수 있으니 신중하게 진행해야 합니다. 주로 새로운 환경에 동일한 설정을 복제할 때 사용합니다.

1.  새로운 Realm을 생성하거나, 설정을 덮어쓸 기존 Realm으로 이동합니다.
2.  **Add realm** 페이지 (Realm 목록 페이지의 **Add Realm** 버튼) 또는 **Realm Settings**에서 Import 기능을 사용할 수 있습니다.
3.  백업해둔 JSON 파일을 선택하여 가져오기를 진행합니다.

---

### 라. (심화) 이용약관과 개인정보처리방침 분리하여 동의받기 (권장)

Keycloak의 기본 'Required Action' 기능만으로는 '이용약관'과 '개인정보처리방침'을 각각 별도의 페이지로 분리해서 보여주기 어렵습니다. 현실적인 대안으로, 회원가입 페이지에 두 약관의 동의 체크박스를 각각 만들어 모두 동의해야 가입이 완료되도록 설정할 수 있습니다.

이는 Keycloak의 **User Profile** 기능을 사용하여 코딩 없이 구현할 수 있습니다. (최신 버전 Keycloak 기준)

#### 1. User Profile 기능 활성화

1.  **Keycloak 관리자 콘솔**에서 **Realm Settings** > **User Profile** 탭으로 이동합니다.
2.  **Enabled** 스위치가 `ON` 상태인지 확인합니다. (최신 버전은 기본 활성화)

#### 2. 약관 동의를 위한 Attribute 생성

**Create attribute** 버튼을 클릭하여 아래와 같이 2개의 속성을 각각 생성합니다.

**속성 1: 이용약관 (`terms_of_service`)**
-   **Name**: `terms_of_service`
-   **Display name**: 이용약관 동의
-   **Enabled**: `ON`
-   **Required**: `ON`

**속성 2: 개인정보처리방침 (`privacy_policy`)**
-   **Name**: `privacy_policy`
-   **Display name**: 개인정보처리방침 동의
-   **Enabled**: `ON`
-   **Required**: `ON`

#### 3. 각 Attribute에 대한 Validator 및 Annotation 설정

생성한 각 속성( `terms_of_service`, `privacy_policy`)을 클릭하고, **Validators**와 **Annotations** 탭에서 아래와 같이 설정합니다.

-   **Validators 탭:**
    -   `required` validator가 `ON`으로 설정되어 있는지 확인합니다.

-   **Annotations 탭:**
    -   `inputType`: `checkbox`
    -   `label`: `${termsOfServiceLabel}` (또는 `${privacyPolicyLabel}`)
        > `label`에 사용된 `${...}` 키는 `messages_ko.properties` 파일에 정의해야 합니다. 예: `termsOfServiceLabel=<strong>(필수)</strong> <a href="/terms" target="_blank">서비스 이용약관</a>에 동의합니다.`

#### 4. 결과

위 설정을 마치면 회원가입 폼 하단에 아래와 같이 체크박스 두 개가 생성되며, 모두 체크해야만 가입 버튼이 활성화됩니다. 각 약관의 상세 내용은 라벨에 링크(`<a>`)를 걸어 팝업이나 새 창으로 띄우는 방식으로 처리합니다.
