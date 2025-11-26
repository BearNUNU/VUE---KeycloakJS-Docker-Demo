<!DOCTYPE html>
<html data-theme="light">
<head>
    <meta charset="utf-8">
    <title>비밀번호 찾기</title>

    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
</head>
<body class="bg-base-200">
    <div class="flex items-center justify-center min-h-screen">
        <div class="card w-full max-w-sm shadow-2xl bg-base-100">
            <form class="card-body" id="kc-reset-password-form" action="${url.loginAction}" method="post">
                <h1 class="card-title text-2xl justify-center">비밀번호 찾기</h1>

                <#-- Display messages -->
                <#if message?has_content>
                    <div role="alert" class="alert alert-${message.type}">
                        <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                        <span>${message.summary}</span>
                    </div>
                </#if>

                <div class="form-control">
                    <label for="username" class="label">
                        <span class="label-text">사용자 이름 또는 이메일</span>
                    </label>
                    <input type="text" id="username" name="username" class="input input-bordered" autofocus required />
                </div>

                <div class="form-control mt-6">
                    <input type="submit" value="제출" class="btn btn-primary"/>
                </div>

                 <div class="form-control mt-6">
                    <a href="${url.loginUrl}" class="label-text-alt link link-hover text-center">로그인으로 돌아가기</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
