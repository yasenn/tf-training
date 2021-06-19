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
## tfenv

---
# tfenv

[tfenv](https://github.com/tfutils/tfenv#tfenv): Terraform version manager inspired by [rbenv](https://github.com/rbenv/rbenv)

---
# Installation: tfenv

```
$ git clone --depth=1 'https://github.com/tfutils/tfenv.git' ~/.tfenv
$ export PATH="$HOME/.tfenv/bin:$PATH"
$ tfenv install 0.7.0
$ tfenv use 0.7.0
$ terraform version
Terraform v0.7.0

Your version of Terraform is out of date! The latest version
is 0.12.24. You can update by downloading from www.terraform.io
```

---
# TF Versions

* [v0.12](https://github.com/hashicorp/terraform/blob/v0.12/CHANGELOG.md) ( May 22, 2019 → March 19, 2020 )
* [v0.13](https://github.com/hashicorp/terraform/blob/v0.13/CHANGELOG.md) ( Aug 10, 2020 )
* [v0.14](https://github.com/hashicorp/terraform/releases/tag/v0.14.11) ( Apr 2021 )
* [v0.15](https://github.com/hashicorp/terraform/releases/tag/v0.15.5) ( Apr - May 2021 )
* [v1.0.0](https://github.com/hashicorp/terraform/releases/tag/v1.0.0) (June 08, 2021)

---
# TV v1

> Terraform v1.0.0 intentionally has no significant changes compared to Terraform v0.15.5. You can consider the v1.0 series as a direct continuation of the v0.15 series; we do not intend to issue any further releases in the v0.15 series, because all of the v1.0 releases will be only minor updates to address bugs.
> For all future minor releases with major version 1, we intend to preserve backward compatibility as described in detail in the Terraform v1.0 Compatibility Promises. The later Terraform v1.1.0 will, therefore, be the first minor release with new features that we will implement with consideration of those promises.

---
# terraform.tfstate

```
{
  "version": 4,
  "terraform_version": "0.12.24",
  "serial": 1,
  "lineage": "6ef09c9d-f7ec-2f35-3fd0-af5fe8e3b53a",
  "outputs": {
    "all_server_ips": {
      "value": "value",
      "type": "string"
    }
  },
  "resources": []
}
```
