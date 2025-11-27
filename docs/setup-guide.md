# Vue.js & Keycloak Docker Demo 상세 가이드

## 🚀 시작하기

프로젝트를 로컬 환경에서 실행하는 방법은 다음과 같습니다.

### 1. Docker 서비스 시작

먼저 Keycloak과 데이터베이스 서버를 시작합니다.

```bash
docker-compose up -d
```

- **Keycloak**: `http://localhost:8080`
- **PostgreSQL**: `localhost:5432` (컨테이너 내부에서만 접근)

### 2. Keycloak Realm 설정

Docker 컨테이너가 실행된 후, Keycloak 관리자 콘솔에서 초기 설정을 진행해야 합니다.

1.  `http://localhost:8080` 으로 접속하여 관리자 계정(`admin`/`admin`)으로 로그인합니다.
2.  새로운 **Realm**을 생성합니다. (예: `my-realm`)
3.  생성한 Realm에서 **Clients** 메뉴로 이동하여, Vue 앱을 위한 새 **Client**를 생성합니다. (예: `my-vue-app`)
    - **Access Type**: `public`
    - **Valid Redirect URIs**: `http://localhost:5173/*`
    - **Web Origins**: `http://localhost:5173`
4.  **Realm Settings** > **Themes** 탭으로 이동합니다.
5.  **Login Theme** 드롭다운 메뉴에서 `custom-theme`을 선택하고 **Save**를 누릅니다.

### 3. 테마 개발 (UI 수정 시)

Keycloak 로그인 페이지의 UI를 수정하려면 다음 단계를 따릅니다.

1.  별도의 터미널을 열고 테마 디렉토리로 이동합니다.
    ```bash
    cd keycloak-themes/custom-theme
    ```
2.  (최초 한 번만) 필요한 패키지를 설치합니다.
    ```bash
    npm install
    ```
3.  아래 명령어를 실행하여 실시간으로 CSS 빌드를 시작합니다.
    ```bash
    npm run build
    ```
    > 이 명령은 `.ftl` 파일의 변경 사항을 감지하여 `login/resources/css/styles.css`를 자동으로 업데이트합니다. 개발하는 동안 이 터미널을 계속 실행 상태로 두세요.

### 4. Vue.js 프론트엔드 실행

1.  프로젝트 루트 디렉토리에서 의존성을 설치합니다.
    ```bash
    npm install
    ```
2.  개발 서버를 시작합니다.
    ```bash
    npm run dev
    ```
3.  웹 브라우저에서 `http://localhost:5173`으로 접속하여 결과를 확인합니다.

### 5. Google 소셜 로그인 설정

Google 로그인을 연동하여 "기존 회원 로그인" 및 "신규 회원 자동 가입" 기능을 구현하는 절차는 다음과 같습니다. 과정은 총 3단계로 구성됩니다.

#### 1단계: Google Cloud Console에서 OAuth 클라이언트 생성

1.  **프로젝트 및 OAuth 동의 화면 설정**
    - [Google Cloud Console](https://console.cloud.google.com/)에 접속하여 새 프로젝트를 생성하거나 기존 프로젝트를 선택합니다.
    - **API 및 서비스 > OAuth 동의 화면**에서 `External`(외부) 타입을 선택하고 앱 정보를 입력합니다.

2.  **OAuth 클라이언트 ID 생성**
    - **사용자 인증 정보 > 사용자 인증 정보 만들기 > OAuth 클라이언트 ID**를 선택합니다.
    - 아래 내용을 참고하여 설정을 완료합니다.
        - **애플리케이션 유형**: `웹 애플리케이션`
        - **승인된 리디렉션 URI**: 아래 주소를 추가합니다.
            ```text
            http://localhost:8080/realms/my-realm/broker/google/endpoint
            ```
            > **중요**: `my-realm` 부분은 **2. Keycloak Realm 설정** 단계에서 생성한 실제 Realm 이름과 일치해야 합니다.

3.  **클라이언트 ID와 Secret 확인**
    - 생성이 완료되면 **클라이언트 ID**와 **클라이언트 보안 비밀**이 표시됩니다. 이 값들을 복사해 둡니다. 다음 단계에서 사용됩니다.

#### 2단계: Keycloak에 Google Identity Provider 설정

1.  **Google Provider 추가 및 기본 정보 입력**
    - Keycloak 관리자 콘솔 > **Identity Providers** 메뉴로 이동하여 **Google**을 선택합니다.
    - `1단계`에서 복사한 **Client ID**와 **Client Secret**을 각각 붙여넣습니다.

2.  **상세 설정**
    - **Scopes**: `openid profile email`을 입력합니다.
    - **Advanced settings**를 펼쳐 다음 두 항목을 설정합니다.
        - **Trust Email**: `ON`
        - **Sync Mode**: `import`
            > **팁**: 위 두 옵션을 활성화하면, 사용자가 별도의 프로필 검토나 이메일 인증 없이 즉시 로그인 및 가입할 수 있어 사용자 경험이 향상됩니다.

3.  **저장**
    - **Save** 버튼을 클릭하면 설정이 완료되고, 로그인 페이지에 Google 로그인 버튼이 나타납니다.

#### 3단계: 신규 사용자 로그인 절차 간소화 (선택 사항)

최초 소셜 로그인 시, Keycloak이 사용자 프로필을 검토하는 중간 단계를 생략하여 즉시 가입을 완료시키는 방법입니다.

1.  **Authentication 흐름 복제**
    - **Authentication** > **Flows** 탭으로 이동합니다.
    - 시스템 기본 흐름인 `first broker login`을 찾아 우측의 **Duplicate** 버튼을 클릭합니다.
    - 복제된 흐름의 이름(예: `Google Auto Login`)을 지정하고 저장합니다.

2.  **Review Profile 단계 비활성화**
    - 복제한 `Google Auto Login` 흐름의 설정 화면으로 이동합니다.
    - **Review Profile (Create User If Unique)** 항목의 `REQUIRED` 설정을 `DISABLED`로 변경합니다.

3.  **Provider에 신규 흐름 적용**
    - 다시 **Identity Providers** > **Google** 설정으로 돌아옵니다.
    - **Advanced settings** > **First Login Flow** 항목을 방금 생성한 `Google Auto Login`으로 변경하고 저장합니다.