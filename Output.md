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
## terraform output

---
# terraform output

The terraform output command is used to extract the value of an output variable from the state file.

Usage: `terraform output [options] [NAME]`

```
output "arn" {
  value = aws_s3_bucket.main.arn
}
```

```bash
$ terraform output
arn = arn:aws:s3:::cf08973879519fa5610bc8b6ff6541
```

---
# Usage

```
$cat output.tf
output "arn_alarm_sns" {
  value       = "${aws_cloudformation_stack.sns_alert_topic.outputs["ARN"]}"
  description = "Email SNS topic ARN"
}
```

```
$cat main.tf
...
module codedeploy {
...
  arn_trigger_alarm_sns = $(module.CloudWatch.arn_alarm_sns)
}
...
```
