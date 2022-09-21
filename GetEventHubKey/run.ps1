using namespace System.Net


# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)
$User = ""
$PWord = ConvertTo-SecureString -String "" -AsPlainText -Force
$tenant = ""
$subscription = ""
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User,$PWord
Connect-AzAccount -Credential $Credential -Tenant $tenant -Subscription $subscription


# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$p_GroupName = $Request.Query.p_GroupName
$p_NamespaceName = $Request.Query.p_NamespaceName
$p_EventHub = $Request.Query.p_EventHub
$pAuthName = $Request.Query.pAuthName
$body = ""

if ($p_GroupName && $p_NamespaceName && $p_EventHub) {
    $body = Get-AzEventHubKey -ResourceGroupName $p_GroupName -NamespaceName $p_NamespaceName -EventHubName $p_EventHub -AuthorizationRuleName $pAuthName
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
