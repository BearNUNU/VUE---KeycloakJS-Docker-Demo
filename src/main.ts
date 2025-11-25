import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import keycloak from './keycloak'
import router from './router'
import { startTokenAutoRefresh } from './components/utils/tokenRefresher';


const initKeycloak = async() => {
    try {
        const authenticated = await keycloak.init({
            checkLoginIframe: false, // iframe 단위로 로그인 검사  로컬 개발 환경에서는 ORS / 3rd party cookie 문제로 타임아웃 발생 가능
            checkLoginIframeInterval: 60,
            redirectUri: window.location.origin + '/', // intro 페이지로 리다이렉트
            pkceMethod: "S256"// PKCE 방식 지정 -> 인증 코드 중간에 가로채는 위협 방지

        })
        if(authenticated){
            startTokenAutoRefresh(); //토큰 자동 리프레시 추가
        }
    } catch (error) {
        console.log(error)
    }
}

//lazy init 방식도 있지만 초기화 후 app 마운트 하는 방식 사용
initKeycloak().finally(()=>{
createApp(App).use(router).mount('#app'); 
})
