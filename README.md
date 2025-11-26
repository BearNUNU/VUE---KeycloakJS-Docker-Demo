# VUE---KeycloakJS-Docker-Demo

This repository is a demo project that implements OAuth2 / OpenID Connect authentication and role-based access control using Keycloak.js within a Vue 3 (Vite) application. It is designed to run both the frontend and Keycloak server using Docker Compose for easy local setup and deployment.

## Keycloak 설정

1.  **docker-compose.yml**
    
    ```yaml
    ports:
      # 로컬 컴퓨터(Host)와 컨테이너(Guest)의 포트를 연결합니다.
      # 형식: "HOST:CONTAINER"
      # 로컬 컴퓨터의 8080 포트로 오는 요청을 컨테이너의 8080 포트로 전달합니다.
      # 이를 통해 웹 브라우저에서 http://localhost:8080 으로 Keycloak에 접근할 수 있습니다.
      # 운영에서는 호스트 포트 8080 노출 대신 프록시 사용
      - "8080:8080"
    ```

2.  **.env.local**
    
    ```
    # 개발 환경
    VITE_KEYCLOAK_URL=http://localhost:8080
    VITE_KEYCLOAK_REALM=demo
    VITE_KEYCLOAK_CLIENT_ID=vue-client
    
    # 운영 환경 예시
    # 서비스 시 URL 공인 도메인으로 변경
    # VITE_KEYCLOAK_URL=https://auth.mycompany.com
    # VITE_KEYCLOAK_REALM=production
    # VITE_KEYCLOAK_CLIENT_ID=vue-client-prod
    ```

3.  **Realm 별도 생성**

4.  **Client 설정**
    *   **Access Type**: `public`
    *   **Valid Redirect URIs**: 운영 도메인 추가
    *   **Web Origins**: 운영 도메인 URL 지정

5.  **TLS / HTTPS**
    *   Docker Compose + Nginx / Traefik으로 SSL Termination 구성

6.  **Realm Settings**
    *   User registration: `ON`
    *   Forgot password: `ON`
    *   Remember me: `ON`
    *   Verify email: `ON` → Keycloak에 SMTP(이메일 발송 서버) 설정 필요

7.  **유저 정보 설정**
    *   User Profile에서 필요한 사용자 정보 필드를 설정합니다.