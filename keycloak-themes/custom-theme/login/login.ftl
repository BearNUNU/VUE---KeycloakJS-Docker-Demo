<!DOCTYPE html>
<html data-theme="light">
<head>
    <meta charset="utf-8">
    <title>Login</title>

    <#-- This will load the local styles.css if you need custom overrides -->
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
</head>
<body class="bg-base-200">
    <div class="flex items-center justify-center min-h-screen">
        <div class="card w-full max-w-sm shadow-2xl bg-base-100">
            <form class="card-body" id="kc-form-login" action="${url.loginAction}" method="post">
                <input type="hidden" id="tab_id" name="tab_id" value="${tabId!}" />
                <h1 class="card-title text-2xl justify-center">Login</h1>

                <#-- Display login messages (e.g., "Invalid username or password") -->
                <#if message?has_content>
                    <div role="alert" class="alert alert-${message.type}">
                        <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                        <span>${message.summary}</span>
                    </div>
                </#if>

                <div class="form-control">
                    <label class="label" for="username">
                        <span class="label-text">Username or Email</span>
                    </label>
                    <input id="username" name="username" type="text" placeholder="username" class="input input-bordered" required autofocus />
                </div>

                <div class="form-control">
                    <label class="label" for="password">
                        <span class="label-text">Password</span>
                    </label>
                    <input id="password" name="password" type="password" placeholder="password" class="input input-bordered" required />
                    <#if realm.resetPasswordAllowed || realm.registrationAllowed>
                    <label class="label">
                        <#if realm.resetPasswordAllowed>
                        <a href="${url.loginResetCredentialsUrl}" class="label-text-alt link link-hover">비밀번호 찾기</a>
                        </#if>
                        <#if realm.registrationAllowed>
                        <a href="${url.registrationUrl}" class="label-text-alt link link-hover">회원가입</a>
                        </#if>
                    </label>
                    </#if>
                </div>

                <div class="form-control mt-6">
                    <input id="kc-login" type="submit" value="Login" class="btn btn-primary"/>
                </div>

<#if realm.password && social.providers??>
    <div class="divider">OR</div> <#-- "또는" 구분선 (DaisyUI/Tailwind) -->

    <div class="flex flex-col gap-2">
        <#list social.providers as p>
            <a id="social-${p.alias}" 
               href="${p.loginUrl}" 
               class="btn btn-outline w-full normal-case">
               
               <#-- 구글 아이콘이나 텍스트 표시 -->
               <#if p.alias == "google">
                   <svg class="w-5 h-5 mr-2" viewBox="0 0 24 24">
                        <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" />
                        <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" />
                        <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" />
                        <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" />
                   </svg>
               </#if>
               
               <span>${p.displayName!} 로그인</span>
            </a>
        </#list>
    </div>
</#if>
            </form>
        </div>    </div>
</body>
</html>
