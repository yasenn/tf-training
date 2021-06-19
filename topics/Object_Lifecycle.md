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
## Lifecycle Customizations

---
# Terraform Flow

1. Configuration Loader -> Backend -> State Manager
1. Create terraform.Context
1. Graph Builder
1. Graph Walker
1. Vertex Evaluation

---
# Lifecycle Customizations

The following lifecycle meta-arguments are supported:
- `create_before_destroy (bool)`: a new replacement object is created first, and then the prior object is destroyed only once the replacement is created
- `prevent_destroy (bool)`: will cause Terraform to reject with an error any plan that would destroy the infrastructure object
- `ignore_changes (list of attribute names)`: he given attribute names are considered when planning a create operation, but are ignored when planning an update
