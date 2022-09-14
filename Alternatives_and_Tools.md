---
marp: true
remark
theme: default
style: |
  section {
    font-size: 30px;
  }
---
# Terraform: Infrastructure as Code 
## IaC Tools Landscape

---
# Evolution of Management IaC

- Manual(documentation?)
- Scripts
- Scripts of Scripts: 
- CMS (Configuration Management Software)
- Infrastructure as code
  - Chef (Ruby)
  - Puppet (Clojure, Ruby)
  - SaltStack (Python)
  - CFEngine (C)
  - Ansible Tower (Python)
  - Terraform (Go)
- Immutable Infrastructure

----
# Types of approaches

- **declarative** (functional): you specify the desired final state of the infrastructure you want to provision and the IaC software handles the rest
- **imperative** (procedural): helps you prepare automation scripts that provision your infrastructure

---
# Methods of Delivery

Two methods of Delivery
- **push**: the server to be configured will pull its configuration from the controlling server
- **pull**: the controlling server pushes the configuration to the destination system


---
# Tools

| Configuration Management Systems  	Ansible, Chef, Puppet, SaltStack | Infrastructure provisioning    	Terraform, CloudFormation, Heat |
|----------------------------------------------------------------------|-----------------------------------------------------------------|
| OS Configuration                                                     | Infrastructure Automation                                       |
| Application Installation                                             | VM and Cloud Provisioning                                       |
| Declarative                                                          | Declarative                                                     |
| Limited Infrastructure Automation                                    | Limited OS Configuration Management                             |

---
# Tools

| Tool      | Approach                 | Delivery Method  |
|-----------|--------------------------|------------------|
| Ansible   | Declarative & Imperative | Push (and Pull)* |
| Chef      | Declarative & Imperative | Pull             |
| Puppet    | Declarative              | Pull             |
| SaltStack | Declarative & Imperative | Push and Pull    |
| Terraform | Declarative              | Push             |

---
# Q/As @ Stack Exchange
| Tool                            | Result | Tag  |
|---------------------------------|--------|------|
| Terraform                       | 14,733 | 4971 |
| CloudFormation                  | 9,547  | 4557 |
| Azure Resource Templates        | 1801   | 1806 |
| Google Cloud Deployment Manager | 250    | 174  |

---

# CloudFormation

## About CF

CloudFormation is the historical configuration management system offered by AWS. It operates around the concept of “stacks”. When you update a stack, you send a new template to the AWS service, the template is received, compared with the previous version stored (if any) and the difference is applied to your infrastructure. You then have tens of resources that are attached to your stack that should be managed only via infrastructure as code.

![CloudFormation](https://miro.medium.com/max/1098/1*UBwKe67ABvoXhOM3qfuqLw.png)
Credits: [Adevinta & AWS CloudFormation documentation](https://medium.com/adevinta-tech-blog/deprecating-aws-cloudformation-stacks-towards-terraform-105b85e79780)

---

# CloudFormation Pitfalls

## An (in)complete modeling

E.g., it is not possible to:

- Define the settings related to Cognito UserPool for federation with an external IDP
- Add a route to a routing table that points to a Transit Gateway
- Implement SSH key provisioning for EC2 (probably for security reasons)

### Workaround:

You may **Extend the capabilities of AWS CloudFormation**using custom resources. In fact, they allow the deployment of a Lambda function and execute it as a “Custom Resource” at a given time during the creation of the stack.

[Here is the official documentation of this feature.](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-custom-resources.html)


---

# CloudFormation Pitfalls

## The whole stack is reapplied each time

Which results in errors having a significant impact, such as the recreation of a database that destroys all your data in a snap or resetting the whole network base configuration (VPC), preventing anyone from connecting to your account in no time.

So, prior to arriving at a working version, you have to go through numerous attempts, each having long execution times.

On CloudFormation, when you apply a configuration change on a stack, you need to regenerate the whole manifest (“template”) even if your change only concerns 1% of the stack (like a basic DNS record creation). This requires you to maintain complex manifests for a long time.

---

# CloudFormation Pitfalls


- A single failure rolls back all stack changes

There’s no sequencing while pushing the changes and it only takes one change to fail, causing CloudFormation to try and revert all your changes, which means accepted changes are also lost.


---

# CloudFormation Pitfalls


- CloudFormation applies your changes blindly

CloudFormation will only compare the new template submitted with the previous one, then apply the difference, without checking if any other modification took place. Any manual changes will be ignored and erased.

---

# CloudFormation Pitfalls

### Unintelligible errors

Error messages are often meaningless, misleading, useless, or simply wrong.

One can only be certain that the stack has failed. **What has actually failed and why is as useful to know as it is difficult to find out.**

The only way to quickly find the reason for failure is to **analyze the execution log** to see exactly on which resource an error is found, and when the provisioning for that resource occurred.


---

# CloudFormation Pitfalls



- The CloudFormation manifests are long and painful to write

The files ingested by CloudFormation are declarative JSON files, which are long, requiring several lines of code where a missing comma can invalidate the whole document. There’s also no validation service available until you attempt to effectively create the stack (or create a ChangeSet on existing stacks).

Even software meant to simplify manifest generation (Troposphere library) had its own complexities so AWS released a custom SDK (the CDK) available in several languages.


---

# CloudFormation Pitfalls

[AWS CloudFormation: the “top 5” reasons for not using it - Proud2beCloud Blog](https://www.proud2becloud.com/aws-cloudformation-the-top-5-reasons-for-not-using-it/)

### Hard limit to 200 resources per stack

It is not possible to create more than 200 resources in a single stack.

Many argue that this is not a problem at all and that it is easily circumvented with common sense. After all, why should you create more than 200 things at a time?

**The problem lies in what is defined as a “resource”;** in fact, there are many objects that are normally invisible while creating resources from the web console. When creating a simple infrastructure with a dozen lambdas, an API Gateway with relative policies, and some additional resources, **the hard limit can be easily reached.**

**The microservices should be small, and a complex application should, therefore, consist of multiple CloudFormation stacks…** however, even having many stacks becomes burdensome from an organizational and management point of view, thus **it is better to measure the amount of resources to be included in a single template** well, and to develop a strategy to partition a complex architecture.

---

# CloudFormation Pitfalls

## Stateful Resource Management

When using AWS CloudFormation to update stateful resources such as DynamoDB, S3, RDS and R53 it is possible to modify attributes within a CloudFormation stack that require replacement. This can lead to the resource being deleted and a new one created, which can cause huge problems if done in production.

Accidental deletion can be avoided using the retain deletion policy, as shown [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-attribute-deletionpolicy.html). However, this would then require management of the resource outside CloudFormation or importing the resource back into the stack.

It is also possible to hit edge cases in AWS CloudFormation that can break the stack due to the complexity of managing infrastructure. When this happens the recommended solution from AWS is usually to delete the stack and create it again, however doing this in production can be complex and risky.

The risk of accidently deleting databases and the complexity of importing/exporting state is enough for me to recommend using APIs directly over CloudFormation for any stateful resource.

---

# CloudFormation Pitfalls

## Region Bound Stacks

Firstly, AWS CloudFormation templates are always deployed within a region. This can become confusing to manage for global resources as it isn’t always apparent where to look for the stack.

Secondly, cross region connectivity can become complicated when using CloudFormation. The sequencing of changes managed by CloudFormation only works within a stack. When resources in multiple regions (such as security groups and peering connections) need to connect extra work is required in addition to CloudFormation. This can be resolved with code to manage the CloudFormation Stacks, but in my experience it is easier to manage these resources directly with the APIs.

---

# CloudFormation Pitfalls

## Nested Stacks

AWS CloudFormation can use nested stacks to allow for re-use of templates within a stack but it causes more problems than it solves.

AWS CloudFormation is generally slow to deploy resources and this gets much worse when using nested stacks. The more nesting is used the slower deployments get due to the overheads of CloudFormation.

Another issue that arises when using nested stacks is failure recovery. As stacks get bigger and more complicated the risk of failures increases, and when AWS CloudFormation fails, it fails hard. This usually requires a complete teardown and rebuild, which can lead to manual work with outages.

![Nested Stacks](https://miro.medium.com/max/483/1*Ndqj5H-bjiVNcCa05NeHNw.png)


---

# CloudFormation Pitfalls
## Exported Output Values

AWS CloudFormation stacks can output values from resources for other stacks to consume. This seems like a helpful tool, however using any of these values will prevent you from modifying the value or deleting the stack. Depending on the value this could be helpful, but generally it leads to drastically increased complexity in managing stack dependencies.

---

# CloudFormation Pitfalls

## Secret Management

AWS CloudFormation cannot manage certain resources such as EC2 SSH keys due to the risk of exposing the secret values within the resource state. It is also risky to include any secrets within a stack such as in AWS Lambda environment variables, EC2 instance userdata, etc. This is due to the CloudFormation API storing all parameters and the template which is accessible in the AWS console and CloudFormation API.


---

# CloudFormation Pitfalls

## Cloudformation drift detection

AWS CloudFormation’s drift detection was loudly requested by many users, and consists of the ability to **automatically detect if changes were made to the configuration of the stack resources outside CloudFormation** via the AWS management console, the CLI and the SDK

This is a very useful feature, unfortunately, in practice, it gives many false positives. In general, it indicates that it is likely that something has been modified externally and, therefore, that the stack can no longer be updated automatically. **Unfortunately, it does not indicate that the stack is not actually editable.**

It is best not to consider it as a reliable indication, at least for now.


---
# Terraformer

A CLI tool that generates tf/json and tfstate files based on existing infrastructure (reverse Terraform)

```
$ terraformer import aws --resources=vpc,subnet
2020/05/02 20:56:49 aws importing default region
2020/05/02 20:56:49 aws importing... vpc
2020/05/02 20:56:56 Refreshing state... aws_vpc.tfer--vpc-002D-505d8d3b
2020/05/02 20:57:05 aws importing... subnet
2020/05/02 20:57:12 Refreshing state... aws_subnet.tfer--subnet-002D-d1bc47ba
2020/05/02 20:57:12 Refreshing state... aws_subnet.tfer--subnet-002D-0e487974
2020/05/02 20:57:12 Refreshing state... aws_subnet.tfer--subnet-002D-46a0390a
2020/05/02 20:57:19 aws Connecting.... 
2020/05/02 20:57:19 aws save vpc
2020/05/02 20:57:19 aws save tfstate for vpc
2020/05/02 20:57:19 aws save subnet
2020/05/02 20:57:19 aws save tfstate for subnet
```

---
# Terraformer

```
$ cat generated/aws/subnet/variables.tf 
data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../../../generated/aws/vpc/terraform.tfstate"
  }
}
$ cat generated/aws/subnet/subnet.tf 
resource "aws_subnet" "tfer--subnet-002D-0e487974" {
  assign_ipv6_address_on_creation = "false"
  cidr_block                      = "172.31.16.0/20"
  map_public_ip_on_launch         = "true"
  vpc_id                          = "${data.terraform_remote_state.vpc.outputs.aws_vpc_tfer--vpc-002D-505d8d3b_id}"
}
```

---
# HashiCorp Suite

### Find the odd one

![hashicorp_suite.webp height:500px](images/terraform_hashicorp_suite.webp)

---
# HashiCorp Suite

- Vagrant is written in Ruby, uses extremely feature rich DSL
- All others are written in Go, uses HCL
- HCL is not a format for serializing data structures(like JSON, YAML, etc). HCL is a syntax and API for building structured configuration formats
- HCL attempts to strike a compromise between generic serialization formats such as YAML and configuration formats built around full programming languages such as Ruby


---
# Terragrunt

- Keep your Terraform code DRY(remote source)
- Keep your remote state configuration DRY(support expressions, variables and functions)
- Keep your CLI flags DRY(extra CLI arguments)
- Execute Terraform commands on multiple modules at once(run terragrunt once)
- Work with multiple AWS accounts(assume an IAM role)
- Inputs(inputs block)
- Locals
- Before and After Hooks(actions that will be called either before or after execution)
- ...

---
# bash-completion

```bash
$ bash_it enable completion terraform
```
```bash
$ wget "https://raw.githubusercontent.com/Bash-it/bash-it/\
master/completion/available/terraform.completion.bash"
$ source terraform.completion.bash
```

---
# Blast Radius

![height:250px](images/terraform_blast_radius.png)

[_Blast Radius_ ](https://github.com/28mm/blast-radius)is a tool for reasoning about [Terraform](https://www.terraform.io/) dependency graphs with interactive visualizations.

Use _Blast Radius_ to:

* **Learn** about _Terraform_ or one of its providers through real [examples](https://28mm.github.io/blast-radius-docs/)
* **Document** your infrastructure
* **Reason** about relationships between resources and evaluate changes to them
* **Interact** with the diagram below (and many others) [in the docs](https://28mm.github.io/blast-radius-docs/)

---
# [Cloudcraft](https://www.cloudcraft.co/)

![height:250px](images/terraform_Cloudcraft.png)

Create a professional architecture diagram in minutes with the Cloudcraft visual designer, optimized for AWS with smart components.  
  
Whether you're starting a new project, or importing your existing AWS environment, Cloudcraft is the fastest and easiest way to iterate on your design.

---
# Cloudcraft: Terraform

```
terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds.git?ref=v2.14.0"
}

include {
  path = find_in_parent_folders()
}

###########################################################
# View all available inputs for this module:
# https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/2.14.0?tab=inputs
###########################################################
inputs = {
  # The allocated storage in gigabytes
  # type: string
  allocated_storage = "5"
```
