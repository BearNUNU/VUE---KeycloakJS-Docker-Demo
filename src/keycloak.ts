import Keycloak from "keycloak-js";

// vite 환경변수에 있는 값들을 통해 keycloak instance 생성
const keycloakConfig = {
  url: import.meta.env.VITE_KEYCLOAK_URL,    
  realm: import.meta.env.VITE_KEYCLOAK_REALM,    
  clientId: import.meta.env.VITE_KEYCLOAK_CLIENT_ID, 
}

const keycloak = new Keycloak(keycloakConfig);

export default keycloak;    