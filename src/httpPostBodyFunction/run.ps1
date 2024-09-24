using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with the body of the request.
$name = $Request.Body.name
$age = $Request.Body.age
$status = [HttpStatusCode]::OK

$body = "This HTTP triggered function executed successfully. Pass a name in the request body for a personalized response."

if ( -not ($name -and $age)){
    $body = "Please provide both 'name' and 'age' in the request body."
    $status = [HttpStatusCode]::BadRequest
}
else {
    <# Action when all if and elseif conditions are false #>
    $body = "Hello, ${name}! You are ${age} years old."
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $body
})
