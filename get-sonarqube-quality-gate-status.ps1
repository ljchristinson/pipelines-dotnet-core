# This script checks for Quality Gate status for a SonarQube Project
[CmdletBinding()]
Param(
    # Define Sonar Token
    [Parameter (Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String] $SonarToken,

    # Define SonarQube Server URI
    [Parameter (Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String] $SonarServerName,

    # Define Project Key
    [Parameter (Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String] $SonarProjectKey
)

$Token = [System.Text.Encoding]::UTF8.GetBytes("32bbef2a150290c6c38101e99b7dd4d861af0d61" + ":")
$TokenInBase64 = [System.Convert]::ToBase64String($Token)
 
$basicAuth = [string]::Format("Basic {0}", $TokenInBase64)
$Headers = @{ Authorization = $basicAuth }
 
$QualityGateResult = Invoke-RestMethod -Method Get -Uri https://sonarcloud.io/api/qualitygates/project_status?projectKey=ljchristinson_pipelines-dotnet-core -Headers $Headers
$QualityGateResult | ConvertTo-Json | Write-Host
 
if ($QualityGateResult.projectStatus.status -eq "OK"){
    Write-Host "Quality Gate Succeeded"
}
else{
    throw "Quality gate failed."
}