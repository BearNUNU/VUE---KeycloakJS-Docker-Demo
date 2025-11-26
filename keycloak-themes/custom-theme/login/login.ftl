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
            </form>
        </div>
    </div>
</body>
</html>
