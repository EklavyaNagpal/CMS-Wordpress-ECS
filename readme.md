# WordPress on AWS Fargate (ECS) with EFS, RDS, and CloudFront

This guide outlines how to deploy a WordPress site on AWS using ECS Fargate, EFS for storage, RDS for the database, and CloudFront for secure content delivery. It includes secrets management with AWS Secrets Manager, image hosting via ECR, and HTTPS via ACM.

---

## Prerequisites


## 1. AWS Secrets Manager - Store DB Credentials

Create a secret in Secrets Manager with the following structure:

**Name:** `db-creds`

**Secret Key/Value:**

```
username: <DB Username>
password: <DB Password>
```

### AWS Console Steps:

* Go to **Secrets Manager**.
* Click **Store a new secret**.
* Select **Other type of secrets**.
* Add the key-value pairs.
* Name the secret `db-creds`.
* Save and copy the **ARN**.

---

## 2. Amazon ECR - Create and Push WordPress Docker Image

### Step 1: Create an ECR Repository

```bash
aws ecr create-repository \
  --repository-name wordpress-repo \
  --region us-east-1
```

### Step 2: Pull and Tag WordPress Image

```bash
docker pull wordpress:6.4.2-php8.2-apache
docker tag wordpress:6.4.2-php8.2-apache \
  <account-id>.dkr.ecr.us-east-1.amazonaws.com/wordpress-repo:6.4.2-php8.2
```

### Step 3: Login to ECR

```bash
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS \
  --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
```

### Step 4: Push the Tagged Image

```bash
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/wordpress-repo:6.4.2-php8.2
```

---

## 3. AWS ACM - Create and Use an HTTPS Certificate

### Step 1: Request Certificate

* Navigate to **Certificate Manager (ACM)**.
* Click **Request certificate**.
* Select **Public certificate**.
* Add your domain.
* Complete DNS verification.

### Step 2: Note Down the ARN

Update your Terraform file with:

```hcl
acm_certificate_arn = "arn:aws:acm:us-east-1:<account-id>:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
domain_name         = "cms.cyberCX.net"
```

## 6. Verify

* Load your site using the domain.
* Ensure SSL certificate is valid.
* Confirm CloudFront no longer throws 502/503 errors.


## Summary

You have successfully:

* Stored DB credentials securely.
* Uploaded a custom WordPress image to ECR.
* Configured ECS to run WordPress using Fargate.
* Mounted EFS to retain WordPress data.
* Secured traffic via HTTPS using ACM + CloudFront.