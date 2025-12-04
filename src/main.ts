import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import keycloak from './keycloak'
import router from './router'
import { startTokenAutoRefresh } from './utils/tokenRefresher';


const initKeycloak = async () => {
    try {
        let authenticated;
        if (import.meta.env.DEV) {
            // 로컬 개발 환경: Nginx 없이 Vite 개발 서버만 사용하는 경우,.
            // 'login-required'는 사용자가 인증되지 않았을 경우 항상 로그인 페이지로 리디렉션하여 이 문제를 해결합니다.
            console.log('개발환경');
            authenticated = await keycloak.init({
                // onLoad: 'login-required', // 사용자가 인증되지 않은 경우 로그인 페이지로 리디렉션
                checkLoginIframe: false,
                checkLoginIframeInterval: 60,
                redirectUri: window.location.origin + '/', // intro 페이지로 리다이렉트
                pkceMethod: 'S256',
            });
        } else {
            console.log('프로덕션환경');
            // 프로덕션/스테이징 환경 (Nginx 사용)
            authenticated = await keycloak.init({
                onLoad: 'check-sso', // 강제 로그인 없이 SSO 세션을 자동으로 확인합니다.
                silentCheckSsoRedirectUri:
                    window.location.origin + '/silent-check-sso.html', // silent check에 사용할 URI
                pkceMethod: 'S256', // PKCE 방식 지정 -> 인증 코드 중간에 가로채는 위협 방지
            });
        }

        if (authenticated) {
            startTokenAutoRefresh(); //토큰 자동 리프레시 추가
        }
    } catch (error) {
        console.error('Keycloak 초기화 실패:', error);
    }
};

//lazy init 방식도 있지만 초기화 후 app 마운트 하는 방식 사용
initKeycloak().finally(()=>{
createApp(App).use(router).mount('#app'); 
})
