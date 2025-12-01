<template>
  <div>
    <h1>Welcome Home!</h1>
    <p>
      Hello, <strong>{{ keycloak.tokenParsed?.preferred_username }}</strong>.
    </p>
    <p>This is the main page for authenticated users.</p>
    <button @click="logout">Logout</button>
    <button @click="deleteUser">delete</button>
  </div>
</template>

<script setup lang="ts">
import keycloak from '../keycloak';


const logout = () => keycloak.logout();
const deleteUser = async () => {
  const userId = keycloak.tokenParsed?.sub;

  if (!userId) {
    alert("User ID not found.");
    return;
  }

  if (!confirm('회원탈퇴 하겠습니까?')) {
    return;
  }

  try {
    const response = await fetch(`/api/users/delete/${userId}`, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${keycloak.token}`
      }
    });

    if (response.ok) {
      alert('deleteUser successful.');
      keycloak.logout();
    } else {
      const error = await response.json();
      alert(`deleteUser failed: ${error.message}`);
    }
  } catch (error) {
    console.error('Error during deleteUser:', error);
    alert('An error occurred during deleteUser.');
  }
};
</script>

<style scoped>

</style>