<!DOCTYPE html>
<html data-theme="light">
<head>
    <meta charset="utf-8">
    <title>Info Page Debug</title>
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
</head>
<body class="bg-base-200">
    <div class="flex items-center justify-center min-h-screen">
        <div class="card w-96 bg-base-100 shadow-xl">
            <div class="card-body">
                <h2 class="card-title">Debug Information</h2>
                <p>Please copy and paste all the text below.</p>
                <div class="mockup-code">
                    <pre><code>
messageHeader: ${messageHeader!"NOT_SET"}

<#if message?has_content>
message.summary: ${message.summary!"NOT_SET"}
message.type: ${message.type!"NOT_SET"}
<#else>
message: NOT_SET
</#if>

pageId: ${pageId!"NOT_SET"}
client.clientId: ${client.clientId!"NOT_SET"}
url.loginUrl: ${url.loginUrl!"NOT_SET"}
                    </code></pre>
                </div>
                 <#if backToApplicationLink?has_content>
                    <div class="form-control mt-6">
                         <a id="back-to-application" href="${backToApplicationLink}" class="btn btn-primary">Back to Application</a>
                    </div>
                </#if>
            </div>
        </div>
    </div>
</body>
</html>
