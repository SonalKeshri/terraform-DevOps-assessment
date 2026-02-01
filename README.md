**1.a: Architecture Overview: Terraform AWS Webserver – Production Ready Design Overview**



======================================================



This project shows how to build a scalable and highly available web server setup on AWS using Terraform.



The focus is on:



-Clean and modular Terraform code

-Separate environments (dev and prod)

-Secure configuration

-Production-ready design

-This is a design and validation exercise.

-Resources are not applied to AWS.



**High-Level Architecture**



Internet Users

     |

     v

Application Load Balancer (ALB)

(Public Subnets – Multi AZ)

     |

     v

Target Group

     |

     v

Auto Scaling Group (ASG)

EC2 Web Servers (Private Subnets – Multi AZ)



====================================================

**1.b: Setup steps + deployment commands**



**1. VPC (Virtual Private Cloud)**



One VPC is created

VPC spans at least two Availability Zones

This ensures high availability



**2. Public Subnets**



Created in each Availability Zone

Used only for: Application Load Balancer (ALB)

Connected to: Internet Gateway (IGW)

Only internet-facing component



**3. Private Subnets**



Created in each Availability Zone

Used for: EC2 instances (web servers)

EC2 instances: Do not have public IPs

Are not directly reachable from internet

This improves security



**4. Internet Gateway (IGW)**



Attached to the VPC

Allows: Internet access only for public subnets

Private subnets do not use IGW directly



**5. NAT Gateway (Design Choice)**



Allows private EC2 instances to:

Download packages (like Nginx updates)

Access internet outbound only

Internet cannot initiate traffic to private subnets



**6. Application Load Balancer (ALB)**



Deployed in public subnets

Accepts traffic from: Internet (HTTP / HTTPS)

Routes traffic to: Target Group

ALB is the only internet-facing resource



**7. Target Group**



Contains EC2 instances

Performs: Health checks

Only healthy instances receive traffic



**8. Auto Scaling Group (ASG)**



Runs across private subnets

Uses: Launch Template

Automatically: Adds instances when load increases

Replaces unhealthy instances

Ensures scalability and self-healing



**9. EC2 Web Servers**



Launched in private subnets

No SSH access

Managed via: AWS SSM (Session Manager)

Nginx installed using: User Data script

Security Design (At a Glance)

EC2 has no public IP

ALB Security Group: Allows inbound HTTP/HTTPS from internet

EC2 Security Group: Allows traffic only from ALB

IAM Role attached to EC2: Least privilege

SSM access only

Availability \& Scalability

Multi-AZ setup

Auto Scaling Group handles:

Traffic spikes

Instance failures

Load Balancer distributes traffic evenly



**Deployment command:-**

Dev env:-

cd environments/dev

terraform init

terraform validate

terraform plan



Prod env:-

cd environments/prod

terraform init

terraform validate

terraform plan



**Terraform Commands Summary**



**terraform init** – Initializes Terraform, downloads providers, and sets up the backend.



**terraform validate** – Checks Terraform configuration for syntax and logical errors.



**terraform plan** – Shows what resources Terraform would create or change.



**terraform apply** – Creates or updates infrastructure based on the Terraform plan.



Notes:-



terraform validate confirms the configuration is correct.

terraform plan and terraform apply require AWS credentials.

Also, Prod Configured with an S3 backend and DynamoDB locking so initializing the backend requires AWS credentials, so after removing backend.tf, terraform validate runs successfully in the prod environment





These below commands are not executed as this project is a design-only assessment-



terraform apply

terraform destroy



====================================================

**1.c:- Assumptions /tradeoff:-**



**Assumption:-**

-A valid AWS account would be available in a real production setup.

-The infrastructure is deployed in a single AWS region.

-A domain name is not provided for HTTPS configuration.

-Instances use Amazon Linux AMI.

-Terraform is used only for infrastructure provisioning.



**Trade-offs:-**



-HTTPS is documented but not implemented due to missing domain and ACM certificate.

-Terraform plan and apply are not executed because AWS credentials are not available.

-Local Stack is not used to keep the setup simple.

-Monitoring is kept minimal using basic CloudWatch metrics.

-Advanced deployment strategies (blue/green or canary) are not implemented.



====================================================

**1.d:-How to destroy cleanly:-**

**Terraform destroy**

Terraform destroy cleanly removes all infrastructure when used in a real AWS setup.



====================================================

**2.a:-How would you do zero-downtime deployments?**

I would use Auto Scaling Group rolling updates.

When a new version is ready, I would launch new EC2 instances first and wait for them to become healthy.

Only after that, old instances would be removed.

Because the load balancer sends traffic only to healthy instances, users will not see any downtime.



Zero-downtime deployments would mainly be handled using Auto Scaling Group rolling updates.

For higher-risk changes, a blue-green deployment strategy could also be used, where traffic is switched to a new environment after validation.



**2.b:-How would you handle secrets/rotation?**

I would never store secrets in code or Terraform files.

Secrets would be stored in AWS Secrets Manager or SSM Parameter Store.

EC2 instances would access secrets using an IAM role.

Secrets can be rotated automatically without changing or redeploying the code.



**2.c:-What would you monitor in production?**

In production, I would monitor:

Load balancer health checks

EC2 CPU usage

Auto Scaling Group capacity

Application error rates (4xx and 5xx)

Response time of the application

CloudWatch alarms would notify the team if something goes wrong.



