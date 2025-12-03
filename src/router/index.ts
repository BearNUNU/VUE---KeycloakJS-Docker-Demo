// src/router/index.ts
import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router';
import Intro from '../components/Intro.vue'
import Home from '../components/Home.vue'
import keycloak from '../keycloak';
import Redirect from '../components/Redirect.vue';

const routes: Array<RouteRecordRaw> = [
  { path: '/', name: 'Intro', component: Intro },
  {
    path: '/Home',
    name: 'Home',
    component: Home,
    meta: { requiresAuth: true },
  },
  {
    path: '/Redirect',
    name: 'Redirect',
    component: Redirect,
    meta: {requiresAuth: true},
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
      await keycloak.login({ redirectUri: window.location.origin + to.fullPath }); // 초대 링크로 접속 시 로그인 완료 후 원래 uri로 진입, 즉 초대 링크에 접속됨
      return; 
    }
  }
  next();
});

export default router;
