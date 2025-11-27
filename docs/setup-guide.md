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