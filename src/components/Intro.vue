<template>
  <div>
    <h1>Intro Page</h1>
    <p>Please log in to continue.</p>
    <button @click="login">Login</button>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue';
import keycloak from '../keycloak';
import { useRouter } from 'vue-router';

const router = useRouter();

const login = () => keycloak.login({ redirectUri: window.location.origin + '/Home' }); // 로그인 시 Home으로 리다이렉트


//이미 로그인 상태면 intro 페이지에서도 home로 자동 이동되게
onMounted(() => { 
  if (keycloak.authenticated) {
    router.replace('/Home');
  }
});
</script>

<style scoped>

</style>

