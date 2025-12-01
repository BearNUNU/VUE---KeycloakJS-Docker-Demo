import keycloak from '../keycloak';

let intervalId: number | null = null;

export const startTokenAutoRefresh = (intervalSec = 60) => {
  if (intervalId) return;
  intervalId = window.setInterval(async () => {
    try {
      // 만료 60초 이내이면 갱신 시도
      await keycloak.updateToken(60);
    } catch (err) {
      console.warn('auto token refresh failed', err);
    }
  }, intervalSec * 1000);
};

//todo 해당 함수 사용 시점 
export const stopTokenAutoRefresh = () => {
  if (intervalId) {
    clearInterval(intervalId);
    intervalId = null;
  }
};



// keycloakJS는 내부에서 자동으로 Refresh Token과 Access Token을 관리하기 때문에 별도로 위와 같이 토큰 갱신을 시킬 필요가 없다.