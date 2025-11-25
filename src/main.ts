import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import keycloak from './keycloak'


const initKeycloak = async() => {
    try {
        await keycloak.init({
            onLoad: 'check-sso', //로그인을 백그라운드에서 감지 후 세션 연결, login-required로 하면 로그인 페이지로 강제 리다이렉트
            checkLoginIframe: true, // iframe 단위로 로그인 검사
            checkLoginIframeInterval: 10,
            // redirectUri: window.location.origin + '/dashboard',      // todo 로그인 페이지로 리다리엑트 지정 필요
            pkceMethod: "S256"// PKCE 방식 지정 -> 인증 코드 중간에 가로채는 위협 방지

        })
    } catch (error) {
        console.log(error)
    }
}

//lazy init 방식도 있지만 초기화 후 app 마운트 하는 방식 사용
initKeycloak().finally(()=>{
createApp(App).mount('#app')    
})
