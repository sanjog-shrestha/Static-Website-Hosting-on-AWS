# 🌐 Static Website Hosting with Terraform (AWS S3 + CloudFront)

> This repo includes Terraform for infra + GitHub Actions workflow for automated CI/CD deployment.

## 📌 Overview

This project demonstrates how to deploy a **static website on Amazon Web Services (AWS)** using **HashiCorp Terraform Infrastructure as Code (IaC)**.

Terraform provisions and configures the required AWS resources automatically, enabling **repeatable and version-controlled infrastructure deployments**.

The infrastructure includes:
- Amazon S3 bucket (private)
- Static website hosting configuration
- CloudFront CDN distribution
- Origin Access Control (OAC)
- Bucket policy (CloudFront-only access)
- Website file uploads
- **GitHub Actions CI/CD pipeline for automated deployment and cache invalidation**

This project highlights **cloud automation, infrastructure security, CDN integration, and DevOps deployment practices**.

---

## 🏗 Architecture

```
User Browser
↓ HTTPS
CloudFront Edge Location (450+ locations worldwide)
↓ Signed Request (sigv4)
Private Amazon S3 Bucket
├── index.html
└── error.html
```

> Direct S3 access is blocked. All traffic is routed through CloudFront which enforces HTTPS and caches content globally.

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/a488d752-287a-4bdc-839f-fb0784b8c054" />

---

## ☁ AWS Deployment

### Provisioned Resources

| # | Resource | Purpose |
|---|----------|---------|
| 1 | `aws_s3_bucket` | Stores website files |
| 2 | `aws_s3_bucket_public_access_block` | Blocks all direct public S3 access |
| 3 | `aws_s3_bucket_website_configuration` | Configures index and error documents |
| 4 | `aws_cloudfront_origin_access_control` | Allows CloudFront to securely access private S3 |
| 5 | `aws_cloudfront_distribution` | CDN with HTTPS, caching, and error handling |
| 6 | `aws_s3_bucket_policy` | Restricts S3 access to this CloudFront distribution only |
| 7 | `aws_s3_object` (x2) | Uploads index.html and error.html to S3 |

<img width="1477" height="516" alt="image" src="https://github.com/user-attachments/assets/b2880b54-0be4-4409-9019-a821c6f818d4" />
<img width="1571" height="256" alt="image" src="https://github.com/user-attachments/assets/ced7dd18-561c-4696-a724-f22bf92513c0" />

---

## 📂 Repository Structure

```
terraform-aws-static-website/
├── .github/
│   └── workflows/
│       └── deploy.yml    → GitHub Actions CI/CD pipeline
├── screenshots/
│   ├── architecture.png
│   ├── s3-private-access.png
│   ├── cloudfront-distribution.png
│   ├── terraform-apply.png
│   ├── website-https.png
│   └── error-page.png
├── provider.tf           → AWS provider configuration
├── variables.tf          → Input variable definitions
├── resource.tf           → AWS infrastructure resources
├── output.tf             → Terraform output values
├── index.html            → Website homepage
└── error.html            → Custom error page
```

---

## ⚙ Terraform Design Approach

### 1️⃣ Infrastructure as Code

Terraform defines all AWS infrastructure declaratively, enabling:
- Version-controlled infrastructure
- Repeatable deployments across environments
- Automated provisioning with zero manual steps
- Reduced configuration errors

### 2️⃣ Private S3 + CloudFront CDN

Rather than exposing S3 directly, CloudFront acts as the secure entry point:

- S3 bucket is **fully private** — no direct public access
- CloudFront uses **Origin Access Control (OAC)** to fetch files from S3 using signed requests
- All HTTP traffic is **automatically redirected to HTTPS**
- Content is **cached at edge locations** for fast global delivery

### 3️⃣ Security via Bucket Policy

The S3 bucket policy uses a `Condition` block to ensure **only this specific CloudFront distribution** can read objects — preventing any other AWS account's CloudFront from accessing your bucket.

### 4️⃣ Automated Content Deployment

Terraform uploads website files directly to S3 using `aws_s3_object`, ensuring content is deployed automatically alongside infrastructure.

### 5️⃣ GitHub Actions CI/CD Pipeline

Every push to `main` triggers an automated 7-step pipeline that removes both manual deployment steps entirely. The pipeline runs `terraform apply` to sync infrastructure and website content to S3, then immediately reads the CloudFront distribution ID from Terraform output and submits a cache invalidation — so changes go live within 1–2 minutes of a push without any local tooling or credentials required. A `workflow_dispatch` trigger also allows manual runs directly from the GitHub Actions tab.

AWS credentials and the S3 bucket name are stored as GitHub Secrets and injected into the runner as environment variables. The `TF_VAR_bucket_name` secret maps directly to `var.bucket_name` via Terraform's `TF_VAR_*` convention — no changes to `variables.tf` were needed.

> 📸 **GitHub Actions Pipeline Screenshot:**
<!-- TO ADD: Go to your repository → Actions tab → click the latest Deploy Static Website run → take a screenshot showing all 7 steps passing → upload to GitHub and replace this line with the img tag -->
> ⚠️ *Replace this line with your GitHub Actions pipeline screenshot after the first successful run*

---

## 🚀 Deployment Instructions

### Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/install) installed
- [AWS CLI](https://aws.amazon.com/cli/) configured with valid credentials
- GitHub repository with Actions enabled

---

### Option A — Automated Deployment via GitHub Actions (Recommended)

**1. Add GitHub Secrets**

Navigate to **Settings → Secrets and variables → Actions → New repository secret** and add:

| Secret Name | Value |
|---|---|
| `AWS_ACCESS_KEY_ID` | Your IAM user access key |
| `AWS_SECRET_ACCESS_KEY` | Your IAM user secret key |
| `TF_VAR_BUCKET_NAME` | Your globally unique S3 bucket name |

> 📸 **GitHub Secrets Screenshot:**
<!-- TO ADD: Go to Settings → Secrets and variables → Actions → take a screenshot showing the three secrets exist → upload to GitHub and replace this line with the img tag -->
> ⚠️ *Replace this line with your GitHub Secrets screenshot after configuring*

**2. Push to main**

```bash
git add .
git commit -m "deploy: update website content"
git push origin main
```

The pipeline runs automatically. Monitor progress under the **Actions** tab. Changes are live within 1–2 minutes of the pipeline completing.

---

### Option B — Manual Deployment (Local)

**Step 1 — Initialize Terraform**
```bash
terraform init
```

**Step 2 — Validate Configuration**
```bash
terraform validate
```

**Step 3 — Review Execution Plan**
```bash
terraform plan
```

**Step 4 — Apply Infrastructure**
```bash
terraform apply
```

> ⚠️ CloudFront distributions take **10–15 minutes** to propagate globally after creation. This is normal.

---

## 🔍 Terraform Deployment Output

After `terraform apply` completes you will see:

```bash
website_endpoint                = "https://d1234abcdef.cloudfront.net"
aws_cloudfront_distribution_id  = "E1234ABCDEFGH"
s3_bucket_name                  = "your-bucket-name"
```

<img width="923" height="163" alt="image" src="https://github.com/user-attachments/assets/336c90c6-c77a-4222-a9db-ae01a815f76a" />

---

## 🌐 Website Validation

Once deployment completes and CloudFront has propagated (~15 mins):

1. Copy the `website_endpoint` from the Terraform output
2. Open it in your browser
3. Verify the website loads over **HTTPS** — padlock 🔒 should be visible in the address bar
4. Visit a non-existent page to verify `error.html` loads correctly

<img width="1918" height="1003" alt="image" src="https://github.com/user-attachments/assets/eeca9c6d-017d-4df0-b323-4107ee1e9880" />
<img width="1918" height="972" alt="image" src="https://github.com/user-attachments/assets/5e07b495-9935-4c02-9384-b88b84f464fc" />

---

## 🔄 Updating Website Content

### With GitHub Actions (Recommended)

Simply edit `index.html` or `error.html`, commit, and push to `main`. The pipeline handles the apply and cache invalidation automatically.

```bash
git add index.html
git commit -m "update: homepage content"
git push origin main
```

### Manually (Without GitHub Actions)

```bash
# Redeploy files to S3
terraform apply -auto-approve

# Clear CloudFront cache so changes appear immediately
aws cloudfront create-invalidation \
  --distribution-id $(terraform output -raw aws_cloudfront_distribution_id) \
  --paths "/*"
```

> Without cache invalidation, visitors may see the old version for up to 1 hour.

---

## 📊 Infrastructure Summary

| Component | Service Used |
|-----------|-------------|
| Website Hosting | Amazon S3 (private) |
| CDN & HTTPS | Amazon CloudFront |
| CI/CD Pipeline | GitHub Actions |
| Infrastructure Provisioning | Terraform |
| Authentication | AWS CLI / GitHub Secrets |
| Development Environment | VS Code |

---

## 🧠 Key Concepts Demonstrated

- Terraform AWS provider usage
- Infrastructure as Code principles
- Private S3 static website hosting
- CloudFront CDN with HTTPS enforcement
- Origin Access Control (OAC) for secure S3 access
- Least-privilege bucket policies
- Cache invalidation workflow
- Terraform resource dependencies
- **GitHub Actions CI/CD pipeline for automated deployment**
- **`TF_VAR_*` environment variable pattern for secret injection**
- **`terraform output -raw` in shell scripts for dynamic value resolution**
- **`workflow_dispatch` for manual pipeline trigger support**

---

## 🏁 Project Outcomes

This project demonstrates the ability to:

- Deploy secure cloud infrastructure using Terraform
- Implement a production-grade static hosting architecture
- Configure CloudFront CDN with HTTPS and global caching
- Apply least-privilege security principles to S3 access
- Structure Terraform configurations effectively
- Manage cloud resources through version-controlled configurations
- **Automate end-to-end deployment with GitHub Actions**
- **Eliminate manual steps through CI/CD pipeline integration**

---

## 🔮 Future Improvements

- ~~CloudFront CDN integration~~ ✅ Completed
- ~~CI/CD deployment with GitHub Actions~~ ✅ Completed
- Custom domain with Route53
- HTTPS using AWS Certificate Manager (ACM)
- Terraform remote state with S3 + DynamoDB
- Website monitoring with CloudWatch

---

## 📄 Author

**Sanjog Shrestha**

---

## 📜 License

This project is intended for **educational and portfolio purposes**.
