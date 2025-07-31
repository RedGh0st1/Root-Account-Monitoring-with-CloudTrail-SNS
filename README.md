# Project title II - Root Account Monitoring with CloudTrail SNS

## Table of Contents

- [Objective](#objective)
- [Project Overview](#project-overview)
- [Tools Needed](#tools-needed)
- [Terraform Modules and Resources](#terraform-modules-and-resources)
- [Setup and Deployment](#setup-and-deployment)
  - [Terraform File Structure](#terraform-file-structure)
  - [Deployment Steps](#deployment-steps)
- [Testing the Setup](#testing-the-setup)
- [Outcome](#outcome)
- [Documentation](#documentation)
- [Comparison with Commercial Tools](#comparison-with-commercial-tools)

## Objective

This project demonstrates how to effectively monitor and detect sensitive activities performed using an AWS root account. By setting up logging with CloudTrail and creating alerts with SNS, you can quickly identify and respond to potentially risky actions. The goal is to enhance the security of your AWS environment by minimizing the impact of root account compromise.

## Project Overview

This project will use Terraform to provision specific AWs resources for monitoring a root account acitivity. The configuration:

- AWS CloudTrail - log all management events to an S3 bucket.
- An SNS topic - sending alerts.
- An Amazon EventBridge (formerly CloudWatch Events) rule to detect root user actions from CloudTrail logs and trigger notifications via the SNS topic.

## Tools Needed

- [AWS CloudTrail](https://aws.amazon.com/cloudtrail/): For logging all AWS account activity.
- [Amazon SNS (Simple Notification Service)](https://aws.amazon.com/sns/): For sending alerts and notifications.
- [AWS IAM (Identity and Access Management)](https://aws.amazon.com/iam/): For managing user identities and permissions (primarily for understanding the root user context).
- AWS Management Console: For testing and verification.
- [Amazon S3](https://aws.amazon.com/s3/): For storing CloudTrail logs.
- [Amazon EventBridge (CloudWatch Events)](https://aws.amazon.com/eventbridge/): To create a rule that detects root login events.
- [Terraform](https://www.terraform.io/): For provisioning and managing AWS resources as Infrastructure as Code (IaC).

## Terraform Modules and Resources

This project will provision the following AWS resources using Terraform:

- **aws_s3_bucket**: An S3 bucket to store CloudTrail logs securely.
- **aws_s3_bucket_policy**: A policy for the S3 bucket allowing CloudTrail to write logs.
- **aws_cloudtrail_trail**: The CloudTrail trail itself, configured to log management events to the S3 bucket.
- **aws_sns_topic**: The SNS topic to which alerts will be published.
- **aws_sns_topic_subscription**: Subscriptions to the SNS topic for email or SMS notifications (manual confirmation required).
- **aws_cloudwatch_event_rule**: An EventBridge rule that detects root user activity based on CloudTrail logs.
- **aws_cloudwatch_event_target**: The target for the EventBridge rule, directing the detected events to the SNS topic.
- **Optional Security Enhancements**:
  - `aws_kms_key` and `aws_kms_alias`: For encrypting CloudTrail logs at rest in the S3 bucket.
  - `aws_iam_role` and `aws_iam_role_policy_attachment`: If centralized logging is desired, these resources would be used to configure cross-account access for CloudTrail to deliver logs to a separate logging account.

## Setup and Deployment

The AWS resources are defined within these `.tf` files. Examples include:

- `main.tf`: Contains the primary resource definitions (CloudTrail, SNS, EventBridge rule).
- `variables.tf`: Defines input variables like `sns_email_endpoint` or `s3_bucket_name`.
- `outputs.tf`: Exports important values like the SNS topic ARN or the S3 bucket name.
- `provider.tf`: Specifies provider versions.

### Terraform File Structure

The Terraform configuration files should be structured as follows:

```
project-root/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars?
├── provider.tf
└── README.md
```

### Deployment Steps

1.  **Configure AWS Credentials:** Ensure AWS CLI and Terraform are configured with the necessary credentials to provision resources in your AWS account. You can use environment variables, shared credentials file, or IAM roles for this.
    - For example, using environment variables:
      ```bash
      export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"
      export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY"
      export AWS_REGION="us-east-1" # Or your desired region
      ```
2.  **Initialize Terraform:**
    ```bash
    terraform init
    ```
3.  **Review the Plan:** This command shows you exactly what resources Terraform will create, modify, or destroy.
    ```bash
    terraform plan
    ```
4.  **Apply the Configuration:**
    ```bash
    terraform apply
    ```
    - Type `yes` when prompted to confirm the changes.
5.  **Confirm SNS Subscription:** After Terraform applies the configuration, an email or SMS will be sent to the endpoint specified in your Terraform variables. You must **manually confirm** this subscription to receive alerts. Check your inbox or phone for the confirmation link/message.

## Manual Testing Steps

These steps simulate the activity that the Terraform-provisioned resources are designed to detect.

1.  **Log in Using the Root Account (Not Recommended in Production):**
    - For this simulation, temporarily log into your AWS account using the root user credentials via the AWS Management Console.
    - **Important:** In a production environment, avoid direct root account usage whenever possible. Instead, create and use IAM users with appropriate permissions.
2.  **Perform a Sensitive Action:**
    - While logged in as root in the AWS Management Console, simulate a sensitive action. This could include, but is not limited to:
      - Disabling Multi-Factor Authentication (MFA) for the root account.
      - Viewing the billing dashboard.
      - Modifying an EC2 instance.
    - This action will be recorded by the CloudTrail trail provisioned by Terraform.
3.  **Check for Notifications:** You should receive a notification (email or SMS) from the SNS topic within a few minutes, confirming the detection of root account usage.
4.  **Verify CloudTrail Logs:** Review the CloudTrail event history in the AWS Console or inspect the logs in the S3 bucket provisioned by Terraform to confirm the root user activity was logged successfully.

## Outcome

By completing this project, you will gain hands-on experience with:

- Provisioning AWS resources using [Terraform](https://www.terraform.io/).
- Leveraging [AWS CloudTrail](https://aws.amazon.com/cloudtrail/) for logging and auditing sensitive activities.
- Configuring [Amazon SNS](https://aws.amazon.com/sns/) for sending timely notifications.
- Creating [EventBridge Rules](https://aws.amazon.com/eventbridge/) to detect specific AWS events, like root user activity.
- Understanding the importance of monitoring root account usage for security.
- Developing a fundamental capability to detect and respond to root account usage, which is a high-risk action in any AWS environment.

## Documentation

As part of this project, it is encouraged to document the steps and observations thoroughly. Please include the following:

- **Terraform configuration files (`.tf` files)** used to provision the resources.
- **Screenshots of the `terraform plan` and `terraform apply` outputs**. This shows the resources being created.
- **Screenshot of the CloudTrail log entry for the root account activity** (found in the CloudTrail console or the S3 bucket).
- **Screenshot of your SNS topic and subscription configuration in the AWS Console**.
- **Screenshot of the alert received via email or SMS**.

## "What I Did and What I Learned"

Summarize the steps performed, the challenges faced (if any), and the key insights or knowledge gained about AWS security, monitoring, and Terraform during this project.

## Conclusion:

This project offers a valuable starting point for understanding and implementing basic root user monitoring on AWS. However, for robust, scalable, and feature-rich security monitoring, particularly in production or regulated environments, commercial solutions are generally the preferred choice, complementing or extending the capabilities provided here.
