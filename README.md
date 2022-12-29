# Ensuring Quality Releases
Udacity's DevOps on Azure platform ---> Project 3

## Status

### Introduction 
The aim of the project --> is to use some industry leading tools including Microsoft Azure DevOps and Infrastructure as Code Tools like Terraform to create a disposable test environment and run a variety of automated tests with the click of a button. Monitor and provide insight into the behavior of the FakeRestAPI application that will be deployed and determine root causes by querying the application’s custom log files.



### Introduction 
In this project, Azure DevOps is used to build a CI/CD pipeline that create and deploy in infrastructure using terraform, Azure App service to host a website - FakeRestAPI.
The automated test runs on a self-hosted test runner, a Linux Virtual machine is deployed to use to deploy the UI test with selenium, Integration test with postman and a stress test with Jmeter.

![Structure](images/structure.PNG "structure")

### Project Dependencies
- [Terraform](https://www.terraform.io/downloads.html): IaC
- [JMeter](https://jmeter.apache.org/download_jmeter.cgi): For Stress Test
- [Postman](https://www.postman.com/downloads/): Integration Testing
- [Python](https://www.python.org/downloads/): FakeRestyAPI
- [Selenium](https://sites.google.com/a/chromium.org/chromedriver/getting-started): UI Testing

### Prerequisites
- [Azure Account](https://portal.azure.com) 
- [Azure Command Line Interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Azure DevOps Account](https://dev.azure.com/) 

### Implementation
1. Download the Project Starter file or fork and clone the repository
2. Open it in your preferred code editor (Using VS Code in my case)

Login to your Azure account 

``` bash
az login 
```

Create service principal to authenticate terraform 

``` bash
az ad sp create-for-rbac --name ensuring-quality-releases-sp --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
```

The output will look like this

``` json
{
  "appId": "f020d581-daf4-4473-b1de-c6af0ad31836",
  "displayName": "azure-cli-2022-12-27-10-39-32",
  "password": "MYk8Q~GVc3G0~ZjyctMjOEiVIPImrcqgPimvGaQq",
  "tenant": "2202583d-31dc-43c2-9798-c28c0ffe2a4f"
}
``` 

Within the tarraform folder, run a bash script to create a backend storage account 

```bash
./configure-tfstate-storage-account.sh
```

Create a secret.conf that contains all the arequired authentication parameters extracted from service principal credentials. This will be uploaded to the pipeline as a variable group. 


Generate ssh key pair from your local machine

```bash
ssh-keygen -t rsa
```

### Set up Azure Pipeline 
setup a project in your Azure DevOps Organization and install terraform extension from the market place [terrafrom extention](https://marketplace.visualstudio.com/items?itemName=charleszipp.azure-pipelines-tasks-terraform&targetId=154afa9d-764e-46a6-9ba3-5b67286ed76b&utm_source=vstsproduct&utm_medium=ExtHubManageList)

![terraform from market place](images_project3/terraform_extension.JPG "Market Place")

Create a new Service Connection from Project Settings -> Service connections -> New service connection -> Azure Resource Manager -> Service Principal (automatic)

Next, create a variable group (azsecret) from the library in the DevOps Pipeline. Upload the secret.conf to the library as a Secure File

Navigate to Pipelines -> Library -> Secure Files -> + Secure File -> Upload File. Upload your ssh keys as well.

![Azure Config and secure file](images_project3/secure_files.JPG "Azure config")

We will also need a variables group, we will add the following data in a variable group named azsecret.conf

![Azure pipeline variable](images_project3/variable_groups.JPG "Variable")

### Configure The Pipeline Environment

Regitster a VM in the Pipeline Environment for self-test runner. Pipelines -> Environments -> TEST -> Add resource -> Virtual Machines -> Linux.

Then copy the registration script and manually ssh into the virtual machine you would have previously created and paste it on the terminal.

```bash
mkdir azagent;cd azagent;curl -fkSL -o vstsagent.tar.gz https://vstsagentpackage.azureedge.net/agent/2.210.1/vsts-agent-linux-x64-2.210.1.tar.gz;tar -zxvf vstsagent.tar.gz; if [ -x "$(command -v systemctl)" ]; then ./config.sh --environment --environmentname "TEST" --acceptteeeula --agent $HOSTNAME --url https://dev.azure.com/lawalshakirat66/ --work _work --projectname 'p3_demo' --auth PAT --token xlwqjycl6g5ab32rieorpuwa2ryxmvcp7dzgwri3mdjznz6b7p6a --runasservice; sudo ./svc.sh install; sudo ./svc.sh start; else ./config.sh --environment --environmentname "TEST" --acceptteeeula --agent $HOSTNAME --url https://dev.azure.com/lawalshakirat66/ --work _work --projectname 'p3_demo' --auth PAT --token xlwqjycl6g5ab32rieorpuwa2ryxmvcp7dzgwri3mdjznz6b7p6a; ./run.sh; fi
```
![Installing azagent](images_project3/Test-runner.JPG "azagent")

After a successful Deploy run, it should look something like this:

![Installed azagent](images_project3/Test_environment.JPG "installed azagent")

## create and run the azure-pipeline.yaml 
Choose you github repo. edit the azure-pipeline.yaml script. When you save and run the pipeline, it goes through the following stages
- Provision
- Build
- Deploy
- Test


### Terrafrom apply

![terraform apply](images_project3/terraform_apply.JPG "installed azagent")

### Deployed Webapp

![Terraform deployed webapp](images_project3/WebAppDeploy.JPG " Terraform Deployed webapp")

![Deployed webapp](images_project3/fake-RestAPI.JPG "Deployed webapp")

#### Automation Testing

### Jmeter Logs

![JMeter Logs](images_project3/Jmeter.JPG "JMeter Logs")

### Regression test 

![Regression test](images_project3/RegressionTest1.JPG "Reg test")

![Regression test](images_project3/RegressionTest2.JPG "Reg test")


### Validation test 

![Validation test](images_project3/ValidationTest.JPG "Val test")

### Publish Test Results

![Reg Result](images_project3/PublishTestRegression.JPG "Reg result")

![Val Result](images_project3/PublishTestValidation.JPG "Val result")

### Selenium Test Result

![Selenium Result](images_project3/SeleniumTest.JPG "Selenium Result")

### Stages in Azure Pipeline 

![Stages](images_project3/PipelineStages.JPG "Stages")


#### Creating Log Analytics workspace 

Create a Log Analytics Workspace from the portal. Then, goto Agents management > Linux server > Log Analytics agent instructions > Download and onboard agent for Linux

SSH into the VM created above (Under test) and install the OSMAgent.

```bash 
wget https://raw.githubusercontent.com/Microsoft/OMS-Agent-for-Linux/master/installer/scripts/onboard_agent.sh && sh onboard_agent.sh -w 0ca00083-6708-4862-871d-6ba01ed6f0d8 -s p6HsJnyMJOY3sZRGCyNIkwcQo+UkXL9i8GOrf5wDgzM5JSikM5oY+8k2bfI2uejLsyMu3ra5Y7SlrtiUFX/B2Q== -d opinsights.azure.com
```

### Create an alert for the App Service
- From the [Azure Portal](https://portal.azure.com) go to:<br/>
`Home > Resource groups > "RESOURCE_GROUP_NAME" > "App Service Name" > Monitoring > Alerts`
- Click on `New alert rule`
- Under `Condition` click `Add condition`
- Choose a condition e.g. `Http 404`
- Set the `Threshold value` to `1`
- Click `Done`

### Create a new action group for the App Service
- In the same page, go to the `Actions` section, click `Add action groups` and then `Create action group`
- Give the action group a name e.g. `http404`
- Add an **Action name** e.g. `HTTP 404` and choose `Email/SMS message/Push/Voice` in **Action Type**.
- Provide your email and then click `OK`

![Alert](images_project3/alert.JPG "Alert") 

### Create AppServiceHTTPLogs

Go to the `App service > Diagnostic Settings > + Add Diagnostic Setting.` Tick `AppServiceHTTPLogs` and Send to Log Analytics Workspace created on step above and `Save`.

Go back to the `App service > App Service Logs` . Turn on Detailed `Error Messages` and `Failed Request Tracing` > `Save`. Restart the app service.

### Setting up Log Analytics 

Set up custom logging, in the log analytics workspace go to `Settings > Custom Logs > Add + > Choose File`. Select the file selenium.log > Next > Next. Put in the following paths as type Linux:

```
/var/log/selenium/selenium.log
```

![CL](images_project3/logsAnalytics.JPG "CL") 


Go back to Log Analytics workspace and run below query to see Logs 

```bash
AppServiceHTTPLogs 
|where _SubscriptionId contains "3f8e074e-7d07-4990-8a18-bb4023ba8f4c"
| where ScStatus == '404'

```

![APPhttps Logs](images_project3/status_404.JPG "Http logs") 


Go back to the App Service web page and navigate on the links and also generate 404 not found , example:

```bash 
https://project3demo-appservice.azurewebsites.net/uuuu

https://project3demo-appservice.azurewebsites.net/first page
```
After the trigger, check the email configured since an alert message will be received. 


![Email](images_project3/triggered.JPG "Email")

### URL Used for the project 
 Postman: https://dummy.restapiexample.com/api/v1/create
 Selemium: https://www.saucedemo.com/
 Jmeter: Delpoyed webapp -  http://project3demo-appservice.azurewebsites.net/ (Bringing down soon)


### Helpful resources from Microsoft
- [Example setup using GitHub](https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/install-ssh-key?view=azure-devops#example-setup-using-github)
- [Environment - virtual machine resource](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/environments-virtual-machines?view=azure-devops)
- [Set secret variables](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/variables?tabs=yaml%2Cbatch&view=azure-devops&preserve-view=true#secret-variables)
- [Design a CI/CD pipeline using Azure DevOps](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/apps/devops-dotnet-webapp)
- [Create a CI/CD pipeline for GitHub repo using Azure DevOps Starter](https://docs.microsoft.com/en-us/azure/devops-project/azure-devops-project-github)
- [Create a CI/CD pipeline for Python with Azure DevOps Starter](https://docs.microsoft.com/en-us/azure/devops-project/azure-devops-project-python?WT.mc_id=udacity_learn-wwl)
