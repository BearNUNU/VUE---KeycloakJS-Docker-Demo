import Keycloak from "keycloak-js";

// vite 환경변수에 있는 값들을 통해 keycloak instance 생성
const keycloakConfig = {
    url: import.meta.env.BASE_URL as string,
    realm: import.meta.env.VITE_REALM as string,
    clientId: import.meta.env.VITE_CLIENT_ID as string,
}

const keycloak = new Keycloak(keycloakConfig);

export default keycloak;    