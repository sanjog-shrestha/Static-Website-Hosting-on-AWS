# 🌐 Static Website Hosting with Terraform (AWS S3)

## 📌 Overview

This project demonstrates how to deploy a **static website on Amazon Web
Services (AWS)** using **HashiCorp Terraform Infrastructure as Code
(IaC)**.

Terraform provisions and configures the required AWS resources
automatically, enabling **repeatable and version-controlled
infrastructure deployments**.

The infrastructure includes: - Amazon S3 bucket - Static website hosting
configuration - Public access policy - Website file uploads

This project highlights **cloud automation, infrastructure modularity,
and DevOps deployment practices**.

------------------------------------------------------------------------

# 🏗 Architecture

User Browser\
↓\
S3 Static Website Endpoint\
↓\
Amazon S3 Bucket\
├── index.html\
└── error.html

Architecture Screenshot:

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/ed62041c-5f79-4fb5-a683-4e0c66359255" />


------------------------------------------------------------------------

# ☁ AWS Deployment

## Provisioned Resources

-   S3 Bucket
-   Static Website Hosting Configuration
-   Bucket Public Access Configuration
-   Bucket Policy (Public Read)
-   Website Content Upload

AWS Console Screenshot:

<img width="1555" height="532" alt="image" src="https://github.com/user-attachments/assets/c4cf0d23-bbb2-4f87-bcee-283a4b41e2b9" />

------------------------------------------------------------------------

# 📂 Repository Structure

terraform-aws-static-website/
│
├── provider.tf
├── variables.tf
├── resource.tf
├── output.tf
│
├── index.html
├── error.html

### Structure Explanation

-   **provider.tf** → AWS provider configuration\
-   **variables.tf** → Input variable definitions\
-   **resource.tf** → AWS infrastructure resources\
-   **output.tf** → Terraform output values\
-   **index.html / error.html** → Static website files

------------------------------------------------------------------------

# ⚙ Terraform Design Approach

## 1️⃣ Infrastructure as Code

Terraform is used to define AWS infrastructure declaratively.

Benefits include: - Version-controlled infrastructure - Repeatable
deployments - Automated provisioning - Reduced manual configuration
errors

------------------------------------------------------------------------

## 2️⃣ Static Website Hosting

Amazon S3 provides native static website hosting functionality.

Features used: - index document configuration - error page
configuration - public access policy

------------------------------------------------------------------------

## 3️⃣ Automated Content Deployment

Terraform uploads website files directly to the S3 bucket using the
**aws_s3_object resource**, ensuring the website content is deployed
automatically.

------------------------------------------------------------------------

# 🚀 Deployment Instructions

### Initialize Terraform

terraform init

### Validate Configuration

terraform validate

### Review Execution Plan

terraform plan

### Apply Infrastructure

terraform apply

------------------------------------------------------------------------

# 🔍 Terraform Deployment Output

Example:

website_endpoint =
http://your-bucket-name.s3-website-region.amazonaws.com

Deployment Screenshot:

<img width="1156" height="483" alt="image" src="https://github.com/user-attachments/assets/8c050609-90dc-490c-b634-efab7e66e700" />

------------------------------------------------------------------------

# 🌐 Website Validation

Once Terraform completes deployment:

1.  Copy the website endpoint URL
2.  Open it in your browser
3.  Verify the static website loads successfully

Website Screenshot:

<img width="1918" height="1017" alt="image" src="https://github.com/user-attachments/assets/272a5f63-af2d-4b2f-9c04-32286df030a6" />


------------------------------------------------------------------------

# 📊 Infrastructure Summary

| Component                    | Service Used |
|------------------------------|--------------|
| Website Hosting              | Amazon S3    |
| Infrastructure Provisioning  | Terraform    |
| Authentication               | AWS CLI      |
| Development Environment      | VS Code      |

------------------------------------------------------------------------

# 🧠 Key Concepts Demonstrated

-   Terraform AWS provider usage
-   Infrastructure as Code principles
-   Static website hosting on S3
-   Terraform resource dependencies
-   Cloud infrastructure automation
-   Public access configuration

------------------------------------------------------------------------

# 🏁 Project Outcomes

This project demonstrates the ability to:

-   Deploy cloud infrastructure using Terraform
-   Automate static website hosting on AWS
-   Structure Terraform configurations effectively
-   Implement Infrastructure as Code best practices
-   Manage cloud resources through version-controlled configurations

------------------------------------------------------------------------

# 🔮 Future Improvements

Potential enhancements:

-   CloudFront CDN integration
-   HTTPS using AWS Certificate Manager
-   Custom domain with Route53
-   CI/CD deployment with GitHub Actions
-   Terraform remote state with S3 + DynamoDB
-   Website monitoring with CloudWatch

------------------------------------------------------------------------

# 📄 Author

**Sanjog Shrestha**\

------------------------------------------------------------------------

# 📜 License

This project is intended for **educational and portfolio purposes**.
