import { computed, ref } from 'vue';
import keycloak from '../keycloak';


const isAuthenticated = ref<boolean>(!!keycloak.token);
const userProfile = ref<Record<string, any> | null>(null);

const loadUserProfile = async () => {
  try {
    const profile = await keycloak.loadUserProfile();
    userProfile.value = profile;
  } catch (err) {
    console.warn('loadUserProfile failed', err);
  }
};

const login = (redirectUri?: string) => {
  keycloak.login({ redirectUri });
};

const logout = (redirectUri?: string) => {
  keycloak.logout({ redirectUri });
};

const getToken = async () => {
  // 토큰이 곧 만료되면 갱신
  try {
    await keycloak.updateToken(30); // 만료 30초 전이면 갱신
  } catch (err) {
    console.warn('token update failed', err);
  }
  return keycloak.token;
};

const tokenParsed = computed(() => keycloak.tokenParsed || null);

export function useAuth() {
  return {
    isAuthenticated,
    userProfile,
    tokenParsed,
    login,
    logout,
    getToken,
    loadUserProfile,
  };
}