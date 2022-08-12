# ACME - Pateient Impact API

## Prerequisites
- Ensure you have an AWS instance and are working within the us-east-1 region.

#### Create the IAM Policy
- While already being logged into the AWS Console Go to:
  - https://us-east-1.console.aws.amazon.com/iam/home#/policies$new?step=edit
- Select the JSON tab, and delete everything that is in the JSON document
- In a new browser tab go to:
- - https://raw.githubusercontent.com/AppliedCloudTechnologies/CMS-ACME-Phase3/main/cmsAcmeTechCallengeIamPolicyForEC2InstanceProfileRole.json
- On the recently opened tab, "Select All" and "Copy"
- Return to the tab with the AWS Console, and "Paste" into the blank JSON document
- Select "Next: Tags"
- Enter Name in the Key field and cmsAcmeTechCallengeIamPolicyForEC2InstanceProfileRole in the Value field
- Select "Next: Review"
- Enter cmsAcmeTechCallengeIamPolicyForEC2InstanceProfileRole in the Name field
- Select "Create Policy"

#### Create the IAM Role
- While already being logged into the AWS Console Go to:
  - https://us-east-1.console.aws.amazon.com/iamv2/home#/roles/create?commonUseCase=EC2&step=addPermission&trustedEntityType=AWS_SERVICE
- Search for cmsAcmeTechCallengeIamPolicyForEC2InstanceProfileRole and tick the checkbox to the left of the policy
- Select "Next"
- For Role Name field, enter cmsAcmeTechCallengeIamEC2InstanceProfileRole
- Select "Add tag"
- Enter Name in the Key field and cmsAcmeTechCallengeIamEC2InstanceProfileRole in the Value field
- "Select role"

#### Attach the Role to your EC2
- While already being logged into the AWS Console Go to:
  - https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#Instances:v=3
- Tick the checkbox to the left of the ec2 you want to attach the role for deployment
- Select the "Actions" dropdown, then select "Security", then select "Modify IAM Role"
- Select cmsAcmeTechCallengeIamEC2InstanceProfileRole from the dropdown and select "Update IAM role"

## Installation
Within your EC2 instance do the following to install the project:

Ensure yum packages are up to date
  ```
  sudo yum -y update
  ```
Install git if its not already installed
  ```
  sudo yum -y install git
  ```
Clone the repo
  ```
  git clone https://github.com/AppliedCloudTechnologies/CMS-ACME-Phase3.git
  ```
Change into project
  ```
  cd CMS-ACME-Phase3
  ```
Move into terraform directory 
  ```
  cd terraform
  ```
Make scripts executable
  ```
  chmod 700 *
  ```
Initialize project setup
  ```
  sh install_pipeline.sh
  ```
Seed patient data
  ```
  sh seed_data.sh
  ```


## Get Environment Variables
Run the following command to view environment variables needed for API testing

```
clear && terraform output && echo "########" && echo "User Password:" && terraform output -json |  jq -r '.Password.value | values'
```

You should be presented with values needed to test the api in postman.
 
## ACME API TESTING
Once you have deployed your solution you can test the user flow and api endpoints, we would suggest using postman to test the api functionality. [Postman](https://postman.com) is an API platform for building and using APIs. You can test the api functionality in postman by following these instructions:


In Postman, select to Import new collection

<img width="700" alt="Screen Shot 2022-08-11 at 4 28 24 PM" src="https://user-images.githubusercontent.com/3784116/184259501-301d82d3-9bbb-4240-a4dd-5eaeaa581670.png">

Select `Link` as the import option

<img width="658" alt="Screen Shot 2022-08-11 at 4 28 53 PM" src="https://user-images.githubusercontent.com/3784116/184259617-f3c8fd83-790b-4540-9b27-0361f783a09d.png">

Enter the following url in the space provided and click `Continue`
`https://raw.githubusercontent.com/AppliedCloudTechnologies/CMS-ACME-Phase3/main/CMS-ACME.postman_collection_v1.json`

Click on `CMS-ACME`

<img width="484" alt="Screen Shot 2022-08-11 at 5 36 22 PM" src="https://user-images.githubusercontent.com/3784116/184259729-a964cb68-1446-4304-9921-3b87de01e4dc.png">

Go to variables seciton

<img width="728" alt="Screen Shot 2022-08-11 at 4 40 52 PM" src="https://user-images.githubusercontent.com/3784116/184260012-a6d69326-4f04-4ad9-b3d9-dcd5058ef55f.png">

Enter the following variables from the result of the Get Environment Variables step in EC2 into their respective locations in Postman as current values
- AuthURL
- Client_ID_aka_Audience
- Update-Patient-Status

<img width="641" alt="image" src="https://user-images.githubusercontent.com/3784116/184260651-3ddb340c-c358-46bb-a68f-383398865785.png">

Click `Save`

<img width="707" alt="Screen Shot 2022-08-11 at 5 48 22 PM" src="https://user-images.githubusercontent.com/3784116/184260793-2c2b0c41-e0c7-4609-8d35-bec504ed8fbd.png">

Click on `Authorization`

<img width="605" alt="Screen Shot 2022-08-11 at 4 57 02 PM" src="https://user-images.githubusercontent.com/3784116/184260863-5d7a3402-4665-4092-a7f6-6a0824e82d68.png">

Scroll down and click on `Get New Access Token`

![image](https://user-images.githubusercontent.com/110382909/184008483-025c92b9-3c51-49cb-984b-719b7730a52f.png)

You will be taken to the Cognito Login screen. Login with the Username and User Password provided from the result of the Get Environment Variables step in EC2

![image](https://user-images.githubusercontent.com/110382909/184008646-92b6cf17-2b64-4e69-9670-818e176123c4.png)

Click on proceed to access the token_id

![image](https://user-images.githubusercontent.com/110382909/184008809-1866d7a3-d279-4fda-8411-53a6fe63dd55.png)

Scroll down and copy `id_token` to clipboard

<img width="464" alt="Screen Shot 2022-08-11 at 5 09 43 PM" src="https://user-images.githubusercontent.com/3784116/184261246-6153acce-5993-4412-8412-f2af207d0525.png">

Go back to Variables section and paste in the `id_token` as the BearerToken

<img width="474" alt="Screen Shot 2022-08-11 at 5 10 25 PM" src="https://user-images.githubusercontent.com/3784116/184261324-71617530-8477-4db2-a39d-abff633b89ee.png">

Click `Save`

<img width="707" alt="Screen Shot 2022-08-11 at 5 48 22 PM" src="https://user-images.githubusercontent.com/3784116/184260793-2c2b0c41-e0c7-4609-8d35-bec504ed8fbd.png">

Select `Update Patient Status`

<img width="427" alt="Screen Shot 2022-08-11 at 6 01 10 PM" src="https://user-images.githubusercontent.com/3784116/184261800-3fd5f1f4-05a0-4285-aadb-0b5b5a0669b4.png">

Click on `Body` and then `Send` button to send the request.

![image](https://user-images.githubusercontent.com/110382909/184009397-fb0f6e8a-102d-4a06-8119-82f4125d4581.png)

Response body will be displayed

![image](https://user-images.githubusercontent.com/110382909/184009513-5ca57942-3557-4683-8372-3cd8537424de.png)

Updates can be made to the patient status by making these requests with different values in the reguest body. 
Keep in mind that your user is only able to update the status for patients that are related to your users provider otherwise the API will return an error.

## Project Cleanup

To destroy the resources created from installing from the project run the cleanup script
```
cleanup_pipeline.sh
```
