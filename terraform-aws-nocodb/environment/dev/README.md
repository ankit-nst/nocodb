# Terraform NocoDB Infrastructure - Development Environment

This folder contains Terraform scripts to provision the infrastructure for the NocoDB development environment. The infrastructure includes the following components:
- **VPC**: Virtual Private Cloud with public and private subnets.
- **ALB**: Application Load Balancer for routing traffic.
- **ASG**: Auto Scaling Group for managing EC2 instances.
- **RDS**: Relational Database Service for PostgreSQL.

---

## **Prerequisites**
Before running the Terraform scripts, ensure the following:
1. **AWS CLI** is installed and configured with appropriate credentials.
2. **Terraform** is installed (minimum version 1.0.0).
3. **Bash** is available to execute the `initial-setup.sh` script.

---

## **Steps to Execute**

### **Step 1: Run the Initial Setup Script**
Run the `initial-setup.sh` script to create the backend resources (S3 bucket and DynamoDB table) for Terraform state management.

```bash
sudo chmod a+x initial-setup.sh
./initial-setup.sh <aws-vault-profile> <environment> <region>
```

- Press `q` to exit the screen after reviewing the output.

- The script will display the following information:
  - **S3 Bucket Name**
  - **DynamoDB Table Name**
  - **S3 Key Path**
---

### **Step 2: Update the `provider.tf` File**
Update the `provider.tf` file with the values from the `initial-setup.sh` script:
- Replace the placeholders for `s3_bucket_name`, `dynamodb_table_name`, and `s3_state_key` with the values noted from the script.

Example:
```hcl
terraform {
  backend "s3" {
    bucket         = "your-s3-bucket-name"
    key            = "your/s3/key/path"
    region         = "your-region"
    dynamodb_table = "your-dynamodb-table-name"
  }
}
```

---

### **Step 3: Initialize Terraform**
Run the following command to initialize Terraform and download the required modules:

```bash
terraform init
```

---

### **Step 4: Plan the Infrastructure**
Generate an execution plan to review the resources that will be created:

```bash
terraform plan
```

---

### **Step 5: Apply the Infrastructure**
Apply the Terraform configuration to provision the infrastructure:

```bash
terraform apply
```

- Type `yes` when prompted to confirm the changes.

---

### **Step 6: Verify the Deployment**
Once the infrastructure is provisioned:
1. Check the AWS Management Console to verify the resources:
   - VPC
   - ALB
   - ASG
   - RDS
2. Note the outputs displayed by Terraform (e.g., ALB DNS name, RDS endpoint).

---

### **Step 7: Clean Up (Optional)**
To destroy the infrastructure and clean up resources, run:

```bash
terraform destroy
```

---

## **Folder Structure**
Here’s an overview of the folder structure:

```plaintext
.
├── main.tf               # Main Terraform configuration
├── variables.tf          # Variable definitions
├── outputs.tf            # Output definitions
├── provider.tf           # Terraform backend and provider configuration
├── initial-setup.sh      # Script to create backend resources
├── README.md             # Instructions to execute the scripts
```

---
## **Important Note**
If you change the AWS region, ensure that you update the AMI ID in the tfvars file for the new region. The AMI ID is region-specific, and using an incorrect AMI ID will result in errors during the deployment.


## **Notes**
- Ensure that the `terraform.tfvars` file contains the appropriate values for your environment.
- The `initial-setup.sh` script must be run only once to create the backend resources.
- Always review the `terraform plan` output before applying changes.


