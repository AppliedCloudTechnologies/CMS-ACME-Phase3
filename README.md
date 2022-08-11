Prerequisites
1. The tool server (aka bastion host) (aka jump box) has access to the internet
2. Must use the us-east-1 region

Intall Script
1. install_pipeline.sh

Manual Steps
1. terraform output
2. terraform output -json | jq -r '.Password.value | values'

Cleanup Script
1. cleanup_pipeline.sh
 
 ACME API TESTING
 1. Import collection or API data
   ![image](https://user-images.githubusercontent.com/110382909/184006628-dc6f22ee-5cd4-4c4e-842c-f9b60a5ae772.png)
2.	The following API calls will be imported 
![image](https://user-images.githubusercontent.com/110382909/184008018-ac5dde30-a556-4988-afac-672016caa344.png)
3.	Click on “CMS-ACME” 
4.	Click on “Get New Access Token” to generate a new bearer token
![image](https://user-images.githubusercontent.com/110382909/184008483-025c92b9-3c51-49cb-984b-719b7730a52f.png)
5.	You will be taken to the Cognito Login screen. Login with your provided credentials
![image](https://user-images.githubusercontent.com/110382909/184008646-92b6cf17-2b64-4e69-9670-818e176123c4.png)
6.	Click on proceed to access the token_id
![image](https://user-images.githubusercontent.com/110382909/184008809-1866d7a3-d279-4fda-8411-53a6fe63dd55.png)
7.	Copy id_token to clipboard
![image](https://user-images.githubusercontent.com/110382909/184008934-e08f59b9-e752-4e4f-abc8-5d230dd95414.png)
8.	Select “Update Patient Status”
![image](https://user-images.githubusercontent.com/110382909/184009040-553f8273-315a-4e80-ac7f-3dc89666630a.png)
9.	Select “Authorization” and copy the bearer token.
![image](https://user-images.githubusercontent.com/110382909/184009177-d70401bc-a01c-43b2-b2a2-9c9ef2d1ceb0.png)
10.	Click on “Body” and then “Send” button to send the request.
![image](https://user-images.githubusercontent.com/110382909/184009397-fb0f6e8a-102d-4a06-8119-82f4125d4581.png)
11.	Response body will be displayed
![image](https://user-images.githubusercontent.com/110382909/184009513-5ca57942-3557-4683-8372-3cd8537424de.png)
