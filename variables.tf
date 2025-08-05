variable "aws_region"{
    description = "AWS region to deploy resources in"
    type        = string
    default     = "us-east-1"
}

variable "cloudsec_rootbucket_name" {
    description = "Name of the S3 bucket for CloudTrail logs"
    type        = string
    default     = "cloudsec-rootbucket"
}

variable "cloudsec_sns_topic_name" {
    description = "Name of the SNS topic for notifications"
    type        = string
    default     = "cloudsec-sns-topic"
}

variable "cloudsec_sns_email" {
    description = "Email address to receive SNS notifications"
    type        = string
    default     = "lennienurse@pursuit.org"
}

variable "cloudsec_cloudtrail_name" {
    description = "Name of the CloudTrail trail"
    type        = string
    default     = "cloudsec-cloudtrail"
}