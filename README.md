# Vue.js & Keycloak Docker Demo

본 프로젝트는 Vue.js 3 프론트엔드에서 Docker로 실행되는 Keycloak 서버를 통해 인증을 구현하는 데모입니다. 특히, Tailwind CSS와 DaisyUI를 사용하여 로그인, 회원가입, 비밀번호 찾기 페이지의 UI를 완전히 커스텀하고, 이를 프로젝트 내에서 직접 빌드하는 개발 환경을 구축하는 데 중점을 둡니다.

## ✨ 주요 특징

- **Docker 기반 환경**: Docker Compose를 사용하여 Keycloak과 PostgreSQL 데이터베이스를 한 번에 실행합니다.
- **Vue.js 3 & Vite**: 빠르고 현대적인 프론트엔드 개발 환경을 제공합니다.
- **Keycloak 인증**: `keycloak-js` 어댑터를 사용하여 Vue 앱의 인증을 처리합니다.
- **커스텀 테마**: 로그인, 회원가입, 비밀번호 찾기 등 Keycloak의 모든 인증 UI를 커스텀했습니다.
- **테마 빌드 시스템**: Tailwind CSS와 DaisyUI로 스타일링된 테마를 CDN 방식이 아닌, 프로젝트 내에서 직접 빌드하고 실시간으로 변경 사항을 확인할 수 있습니다.

## 🛠️ 기술 스택

- **Frontend**: Vue 3, Vite, TypeScript
- **Authentication**: Keycloak, keycloak-js
- **Styling**: Tailwind CSS, DaisyUI
- **Environment**: Docker, Docker Compose
- **Database**: PostgreSQL

## 📂 프로젝트 구조

```
.
├── keycloak-themes/
│   └── custom-theme/       # Keycloak 커스텀 테마 소스
│       ├── login/          # 로그인, 회원가입 등 .ftl 템플릿
│       ├── package.json    # 테마 빌드를 위한 종속성
│       └── tailwind.config.js # Tailwind 설정
│
├── public/
├── src/                    # Vue.js 애플리케이션 소스
│   ├── components/
│   ├── keycloak.ts         # Keycloak 초기화 설정
│   └── main.ts
│
├── docker-compose.yml      # Docker 서비스 정의 (Keycloak, Postgres)
├── package.json            # Vue 앱 종속성
└── README.md
```

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

이 프로젝트의 커스텀 테마는 소셜 로그인을 지원하도록 구성되어 있습니다. Google 로그인을 활성화하여 "기존 회원 로그인 / 신규 회원 자동 가입"을 구현하려면 다음 절차를 따르세요.

1.  **Google Cloud Console 설정**
    - [Google Cloud Console](https://console.cloud.google.com/)에서 새 프로젝트를 생성합니다.
    - **API 및 서비스 > OAuth 동의 화면**에서 `External`(외부) 타입을 선택하고 필수 정보를 입력합니다.
    - **사용자 인증 정보 > 사용자 인증 정보 만들기 > OAuth 클라이언트 ID**를 선택합니다.
        - **애플리케이션 유형**: `웹 애플리케이션`
        - **승인된 리디렉션 URI**: 아래 주소를 정확히 입력합니다.
            ```text
            http://localhost:8080/realms/my-realm/broker/google/endpoint
            ```
            > *(주의: `my-realm` 부분은 2단계에서 생성한 실제 Realm 이름과 일치해야 합니다.)*
    - **범위(Scopes)**: `email`, `profile`, `openid`를 포함하여 설정합니다.
    - 생성된 **Client ID**와 **Client Secret**을 복사합니다.

2.  **Keycloak Identity Provider 설정**
    - Keycloak 관리자 콘솔 > **Identity Providers** 메뉴로 이동하여 **Google**을 선택합니다.
    - 복사한 **Client ID**와 **Client Secret**을 입력합니다.
    - **Scopes** 입력란에 `openid profile email` 값을 입력합니다.
    - **Advanced settings**를 펼쳐 다음을 설정합니다.
        - **Trust Email**: `ON`으로 설정
        - **Sync Mode**: `import`로 설정
            > 이 옵션들을 활성화하면 Google 이메일을 신뢰하여, 별도의 인증이나 프로필 검토 없이 즉시 로그인 및 회원가입 처리가 됩니다.
    - **Save**를 누르면 로그인 화면에 Google 버튼이 자동으로 활성화됩니다.

3.  **회원가입 절차 간소화 (선택 사항)**
    1.  **Authentication 흐름 복제**
        - Keycloak 관리자 콘솔 > **Authentication** > **Flows** 탭으로 이동합니다.
        - `first broker login` 흐름을 찾아 우측 메뉴에서 **Duplicate**를 선택합니다.
        - 새 흐름의 이름을 `Google Auto Login` 등으로 지정합니다.
    2.  **흐름 수정 (Review Profile 비활성화)**
        - 복제된 `Google Auto Login` 흐름에서 **Review Profile (Create User If Unique)** 항목을 찾습니다.
        - 해당 항목의 설정을 **REQUIRED**에서 **DISABLED**로 변경합니다.
            > 이 설정을 통해 신규 소셜 로그인 시 사용자 정보 확인 화면이 생략됩니다.
    3.  **Google Provider에 적용**
        - **Identity Providers** > **Google** 설정으로 돌아갑니다.
        - **Advanced settings** > **First Login Flow** 항목을 `Google Auto Login`으로 변경합니다.
        - **Save**를 누릅니다.