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
- [**프로젝트 상세 가이드**](./docs/setup-guide.md)