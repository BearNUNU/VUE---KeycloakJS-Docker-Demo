<!DOCTYPE html>
<html data-theme="light">
<head>
    <meta charset="utf-8">
    <title>이메일 확인</title>

    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
</head>
<body class="bg-base-200">
    <div class="flex items-center justify-center min-h-screen py-8">
        <div class="card w-full max-w-sm shadow-2xl bg-base-100">
            <div class="card-body text-center">
                <h1 class="card-title text-2xl justify-center mb-4">📧<br>이메일을 확인해주세요</h1>

                <p class="mb-4">
                    계정 인증을 위해 <strong>${(email!)}</strong> 주소로 확인 링크를 발송했습니다.
                </p>
                <p>
                    이메일이 보이지 않는 경우, 스팸 폴더도 확인해주세요.
                </p>
                
                <div class="form-control mt-6">
                    <a href="${url.loginUrl}" class="btn btn-primary">로그인 페이지로 돌아가기</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
