// src/router/index.ts
import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router';
import Intro from '../components/Intro.vue'
import Home from '../components/Home.vue'
import keycloak from '../keycloak';

const routes: Array<RouteRecordRaw> = [
  { path: '/', name: 'Intro', component: Intro },
  {
    path: '/Home',
    name: 'Home',
    component: Home,
    meta: { requiresAuth: true },
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// Global guard
router.beforeEach(async (to, from, next) => {
  if (to.meta.requiresAuth) {
    if (!keycloak.authenticated) {
      // 로그인 강제
      await keycloak.login({ redirectUri: window.location.origin + to.fullPath });
      return; // 로그인으로 리다이렉트되므로 next() 호출 X
    }
  }
  next();
});

export default router;
