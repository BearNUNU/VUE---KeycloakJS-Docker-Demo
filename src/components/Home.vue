<template>
  <div>
    <h1>Welcome Home!</h1>
    <p>
      Hello, <strong>{{ keycloak.tokenParsed?.preferred_username }}</strong>.
    </p>
    <p>This is the main page for authenticated users.</p>
    <button @click="logout">Logout</button>
  </div>
</template>

<script setup lang="ts">
import keycloak from '../keycloak';

const logout = () => keycloak.logout();
</script>

<style scoped>

</style>