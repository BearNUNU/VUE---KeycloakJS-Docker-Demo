<!DOCTYPE html>
<html data-theme="light">
<head>
    <meta charset="utf-8">
    <title>Update Password</title>

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
            <form class="card-body" id="kc-form-update-password" action="${url.loginAction}" method="post">
                <input type="hidden" id="tab_id" name="tab_id" value="${tabId!}" />
                <h1 class="card-title text-2xl justify-center">비밀번호 변경</h1>

                <#-- Display messages -->
                <#if message?has_content>
                    <div role="alert" class="alert alert-${message.type}">
                        <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                        <span>${message.summary}</span>
                    </div>
                </#if>

                <div class="form-control">
                    <label class="label" for="password-new">
                        <span class="label-text">새 비밀번호</span>
                    </label>
                    <input id="password-new" name="password-new" type="password" placeholder="new password" class="input input-bordered" required autofocus />
                </div>

                <div class="form-control">
                    <label class="label" for="password-confirm">
                        <span class="label-text">비밀번호 확인</span>
                    </label>
                    <input id="password-confirm" name="password-confirm" type="password" placeholder="confirm password" class="input input-bordered" required />
                </div>

                <div class="form-control mt-6">
                    <input id="kc-submit" type="submit" value="변경" class="btn btn-primary"/>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
