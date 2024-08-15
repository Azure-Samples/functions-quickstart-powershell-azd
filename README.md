---
name: "Azure Functions PowerShell HTTP Trigger using AZD"
description: This repository contains an Azure Functions HTTP trigger quickstart written in PowerShell and deployed to Azure Functions Flex Consumption using the Azure Developer CLI (AZD). This sample uses managed identity and a virtual network to insure it is secure by default.
page_type: sample
languages:
- PowerShell
products:
- azure
- azure-functions
- entra-id
urlFragment: functions-quickstart-powershell-azd
---

# Azure Functions PowerShell HTTP Trigger using AZD

This repository contains a Azure Functions HTTP trigger quickstart written in PowerShell and deployed to Azure using Azure Developer CLI (AZD). This sample uses managed identity and a virtual network to insure it is secure by default. 

## Getting Started

### Prerequisites

1) [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4) 
2) [Azure Functions Core Tools](https://learn.microsoft.com/azure/azure-functions/functions-run-local?tabs=v4%2Cmacos%2Ccsharp%2Cportal%2Cbash#install-the-azure-functions-core-tools)
3) [Azure Developer CLI (AZD)](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd)
4) [Visual Studio Code](https://code.visualstudio.com/) - Only required if using VS Code to run locally

### Get repo on your local machine
Run the following GIT command to clone this repository to your local machine.
```bash
git clone https://github.com/Azure-Samples/functions-quickstart-powershell-azd.git
```

## Run on your local environment

### Prepare your local environment
1) Create a file named `local.settings.json` and add the following:
```json
{
  "IsEncrypted": false,
  "Values": {
    "AzureWebJobsStorage": "UseDevelopmentStorage=true",
    "FUNCTIONS_WORKER_RUNTIME": "powershell"
  }
}
```

### Using Functions CLI
1) Open this folder in a new terminal and run the following commands:

```bash
func start
```

2) Test the HTTP GET trigger using the browser to open http://localhost:7071/api/httpGetFunction

3) Test the HTTP POST trigger in a new terminal window with the following command, or use your favorite REST client, e.g. [RestClient in VS Code](https://marketplace.visualstudio.com/items?itemName=humao.rest-client), PostMan, curl. `test.http` has been provided to run this quickly.

```bash
curl -i -X POST http://localhost:7071/api/httppostbodyfunction -H "Content-Type: text/json" --data-binary "@src/testdata.json"
```

### Using Visual Studio Code
1) Open this folder in a new terminal
2) Open VS Code by entering `code .` in the terminal
3) Make sure the [Azure Functions extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions) is installed
4) Add required files to the `.vscode` folder by opening the command palette using `Crtl+Shift+P` (or `Cmd+Shift+P` on Mac) and selecting *"Azure Functions: Initialize project for use with VS Code"*
5) Press Run/Debug (F5) to run in the debugger (select "Debug anyway" if prompted about local emulater not running) 
6) Use same approach above to test using an HTTP REST client

## Source Code

The key code that makes these functions work is in `./src/httpGetFunction` and `.src/httpPostBodyFunction`.  The function is identified as an Azure Function by use of the `@azure/functions` library. This code shows a HTTP GET triggered function.  

```powershell
using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters
$name = $Request.Query.name

$body = "This HTTP triggered function executed successfully. Pass a name in the query string for a personalized response."

if ($name) {
    $body = "Hello, $name. This HTTP triggered function executed successfully."
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
```
This code shows a HTTP POST triggered function which expects a  `name` value in the request.

```powershell
using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with the body of the request.
$name = $Request.Body.name

$body = "This HTTP triggered function executed successfully. Pass a name in the request body for a personalized response."

if ($name) {
    $body = "Hello, $name. This HTTP triggered function executed successfully."
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
```

## Deploy to Azure

To provision the dependent resources and deploy the Function app run the following command:
```bash
azd up
```
You will be prompted for an environment name (this is a friendly name for storing AZD parameters), a Azure subscription, and an Aure location.
