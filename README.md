---
name: "Azure Functions PowerShell HTTP Trigger using AZD"
description: This repository contains an Azure Functions HTTP trigger quickstart written in PowerShell and deployed to Azure Functions Flex Consumption using the Azure Developer CLI (AZD). This sample uses managed identity and a virtual network to insure it's secure by default.
page_type: sample
languages:
- powershell
- bicep
- azdeveloper
products:
- azure
- azure-functions
- entra-id
urlFragment: functions-quickstart-powershell-azd
---

# Azure Functions PowerShell HTTP Trigger using AZD

This repository contains an Azure Functions HTTP trigger reference sample written in PowerShell and deployed to Azure using Azure Developer CLI (`azd`). The sample uses managed identity and a virtual network to make sure deployment is secure by default.

This source code supports the article [Quickstart: Create and deploy functions to Azure Functions using the Azure Developer CLI](https://learn.microsoft.com/azure/azure-functions/create-first-function-azure-developer-cli?pivots=programming-language-powershell).

### Prerequisites

+ [PowerShell 7.4](https://learn.microsoft.com/powershell/scripting/install/installing-powershell?view=powershell-7.4) 
+ [Azure Functions Core Tools](https://learn.microsoft.com/azure/azure-functions/functions-run-local?pivots=programming-language-powershell#install-the-azure-functions-core-tools)
+ [Azure Developer CLI (`azd`)](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd)
+ To use Visual Studio Code to run and debug locally:
  + [Visual Studio Code](https://code.visualstudio.com/)
  + [Azure Functions extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions)

## Initialize the local project

You can initialize a project from this `azd` template in one of these ways:

+ Use this `azd init` command from an empty local (root) folder:

    ```powershell
    azd init --template functions-quickstart-javascript-azd
    ```

    Supply an environment name, such as `flexquickstart` when prompted. In `azd`, the environment is used to maintain a unique deployment context for your app.

+ Clone the GitHub template repository locally using the `git clone` command:

    ```powershell
    git clone https://github.com/Azure-Samples/functions-quickstart-powershell-azd.git
    cd functions-quickstart-powershell-azd
    ```

## Prepare your local environment

Navigate to the `src` app folder and create a file in that folder named _local.settings.json_ that contains this JSON data:

```json
{
  "IsEncrypted": false,
  "Values": {
    "FUNCTIONS_WORKER_RUNTIME": "powershell",
    "FUNCTIONS_WORKER_RUNTIME_VERSION": "7.4",
    "AzureWebJobsStorage": "UseDevelopmentStorage=true"
  }
}
```

## Run your app from the terminal

1. From the `src` folder, run this command to start the Functions host locally:

    ```shell
    func start
    ```

1. From your HTTP test tool in a new terminal (or from your browser), call the HTTP GET endpoint: <http://localhost:7071/api/httpget>

1. Test the HTTP POST trigger with a payload using your favorite secure HTTP test tool. This example runs from the `src` folder and uses the `Invoke-RestMethod` cmdlet in PowerShell with payload data from the [`testdata.json`](./src/functions/testdata.json) project file:

    ```powershell
    Invoke-RestMethod -Uri http://localhost:7071/api/httppost -Method Post -ContentType "application/json" -InFile "testdata.json"
    ```

1. When you're done, press Ctrl+C in the terminal window to stop the `func.exe` host process.

## Run your app using Visual Studio Code

1. Open the root folder in a new terminal.
1. Run the `code .` code command to open the project in Visual Studio Code.
1. Press **Run/Debug (F5)** to run in the debugger. Select **Debug anyway** if prompted about local emulator not running.
1. Send GET and POST requests to the `httpget` and `httppost` endpoints respectively using your HTTP test tool (or browser for `httpget`). If you have the [RestClient](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) extension installed, you can execute requests directly from the [`test.http`](./src/functions/test.http) project file.

## Source Code

The code that implements the function logic is maintained in `./src/httpGetFunction` and `.src/httpPostBodyFunction` function folders.

The `httpget` function endpoint is defined in [`function.json`](./src/httpGetFunction/function.json), with this code in the [`run.ps1`](./src/httpGetFunction/run.ps1) file:  

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

The `httppost` function endpoint is defined in [`function.json`](./src/httpPostBodyFunction/function.json), with this code in the [`run.ps1`](./src/httpPostBodyFunction/run.ps1) file:

```powershell
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
```

## Deploy to Azure

Run this command to provision the function app, with any required Azure resources, and deploy your code:

```shell
azd up
```

You're prompted to supply these required deployment parameters:

| Parameter | Description |
| ---- | ---- |
| _Environment name_ | An environment that's used to maintain a unique deployment context for your app. You won't be prompted if you created the local project using `azd init`.|
| _Azure subscription_ | Subscription in which your resources are created.|
| _Azure location_ | Azure region in which to create the resource group that contains the new Azure resources. Only regions that currently support the Flex Consumption plan are shown.|

After publish completes successfully, `azd` provides you with the URL endpoints of your new functions, but without the function key values required to access the endpoints. To learn how to obtain these same endpoints along with the required function keys, see [Invoke the function on Azure](https://learn.microsoft.com/azure/azure-functions/create-first-function-azure-developer-cli?pivots=programming-language-powershell#invoke-the-function-on-azure) in the companion article [Quickstart: Create and deploy functions to Azure Functions using the Azure Developer CLI](https://learn.microsoft.com/azure/azure-functions/create-first-function-azure-developer-cli?pivots=programming-language-powershell).

## Redeploy your code

You can run the `azd up` command as many times as you need to both provision your Azure resources and deploy code updates to your function app.

>[!NOTE]
>Deployed code files are always overwritten by the latest deployment package.

## Clean up resources

When you're done working with your function app and related resources, you can use this command to delete the function app and its related resources from Azure and avoid incurring any further costs:

```shell
azd down
```
