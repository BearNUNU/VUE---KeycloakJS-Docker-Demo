# Vue.js & Keycloak Docker Demo

본 프로젝트는 Vue.js 3 프론트엔드에서 Docker로 실행되는 Keycloak 서버를 통해 인증을 구현하는 데모입니다. 특히, Tailwind CSS와 DaisyUI를 사용하여 로그인, 회원가입, 비밀번호 찾기 페이지의 UI를 완전히 커스텀하고, 이를 프로젝트 내에서 직접 빌드하는 개발 환경을 구축하는 데 중점을 둡니다.

## ✨ 주요 특징

-   **Docker 기반 환경**: Docker Compose를 사용하여 Keycloak과 PostgreSQL 데이터베이스를 한 번에 실행합니다.
-   **Vue.js 3 & Vite**: 빠르고 현대적인 프론트엔드 개발 환경을 제공합니다.
-   **Keycloak 인증**: `keycloak-js` 어댑터를 사용하여 Vue 앱의 인증을 처리합니다.
-   **커스텀 테마**: 로그인, 회원가입, 비밀번호 찾기 등 Keycloak의 모든 인증 UI를 커스텀했습니다.
-   **테마 빌드 시스템**: Tailwind CSS와 DaisyUI로 스타일링된 테마를 CDN 방식이 아닌, 프로젝트 내에서 직접 빌드하고 실시간으로 변경 사항을 확인할 수 있습니다.

## 🛠️ 기술 스택

-   **Frontend**: Vue 3, Vite, TypeScript
-   **Authentication**: Keycloak, keycloak-js
-   **Styling**: Tailwind CSS, DaisyUI
-   **Environment**: Docker, Docker Compose
-   **Database**: PostgreSQL

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

-   **Keycloak**: `http://localhost:8080`
-   **PostgreSQL**: `localhost:5432` (컨테이너 내부에서만 접근)

### 2. Keycloak Realm 설정

Docker 컨테이너가 실행된 후, Keycloak 관리자 콘솔에서 초기 설정을 진행해야 합니다.

1.  `http://localhost:8080` 으로 접속하여 관리자 계정(`admin`/`admin`)으로 로그인합니다.
2.  새로운 **Realm**을 생성합니다. (예: `my-realm`)
3.  생성한 Realm에서 **Clients** 메뉴로 이동하여, Vue 앱을 위한 새 **Client**를 생성합니다. (예: `my-vue-app`)
    -   **Valid Redirect URIs**: `http://localhost:5173/*` (Vite 기본 주소)
    -   **Web Origins**: `http://localhost:5173`
4.  **Realm Settings** > **Themes** 탭으로 이동합니다.
5.  **Login Theme** 드롭다운 메뉴에서 `custom-theme`을 선택하고 **Save**를 누릅니다. 이 과정이 없으면 커스텀 UI가 적용되지 않습니다.

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
    이 명령은 `.ftl` 파일의 변경 사항을 감지하여 `login/resources/css/styles.css`를 자동으로 업데이트합니다. 개발하는 동안 이 터미널을 계속 실행 상태로 두세요.

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
