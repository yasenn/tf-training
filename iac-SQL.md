# steampipe.io 

https://steampipe.io 

```
select * from cloud;
```


15 облачных провайдеров, 86 плагинов и 35 модов

## Примеры использования:

* сколько у меня лямбда-функций?
* как сделать рассылку в slack по всем AWS IAM учеткам?
* когда истекает срок регистрации таких-то доменов?
* какие пользователи (не) включили MFA?
* какие security группы торчат игресами в интернет?
* каким ресурсам владельцы забыли проставить тэги?
* какие блочные хранилища созданы и не используются?
* когда были созданы данные IAM роли?
* etc

# Альтернативы

## osquery

* [osquery | Easily ask questions about your Linux, Windows, and macOS infrastructure](https://osquery.io/)
* Query your devices like a database
* Osquery uses basic SQL commands to leverage a relational data-model to describe a device

## IaSQL

[IaSQL](https://iasql.com/)

* Infrastructure as data in PostgreSQL
* Manage cloud infrastructure as data in a hosted PostgreSQL database

## CloudQuery

[CloudQuery | The open-source cloud asset inventory powered by SQL | CloudQuery](https://www.cloudquery.io/)

* Regain access to your data
  * Apply the best practices in data engineering to solve infrastructure security, compliance, cost and search use cases.
* Cloud asset inventory
  * Build your own multi-cloud asset inventory with standard SQL and BI tools.

* CSPM

  * Customize pre-built open source SQL policies and visualize them with your any of your favorite BI tools.

* Open source

  * Easily extensible plugin architecture. Contribute to our official plugins or develop your own with CloudQuery SDK.

* Blazing fast

  * CloudQuery concurrency system utilizes the excellent Go concurrency model with light-weight goroutines.

* Database agnostic

  * CloudQuery can store your configuration in any supported destination such as database, datalake, streaming for further analysis.

* Raw access to data

  * Decouple data ingestion and get raw access to your data in structured and unstructured formats.

## Data analysis, security, auditing, and compliance

Leverage SQL to get visibility into your cloud infrastructure and SaaS applications.

Security

Find all public facing AWS load balancers
```
SELECT    *FROM    aws_elbv2_load_balancersWHERE    scheme = 'internet-facing'
```

Compliance

AWS CIS 1.5 Ensure IAM password policy requires at least one uppercase letter

```
SELECT    account_id,    require_uppercase_charactersFROM    aws_iam_password_policiesWHERE    require_uppercase_characters = FALSE
```

Query across clouds and SaaS apps

Find dormant access keys by joining your AWS IAM users and Okta directory

```
SELECT    arnFROM    aws_iam_users    JOIN aws_iam_user_tags ON aws_iam_users.id = aws_iam_user_tags.user_id    JOIN okta_users ON aws_iam_users.tags.value = okta_users.profile_emailWHERE    aws_iam_users.tags_key = "email"
```



## commercial
* [Resmo - Continuous Asset Visibility and Security for Cloud and SaaS assets](https://www.resmo.com/) `Select * from cloud & SaaS` + a fully managed SaaS platform with a free offering

# SQL-related tools

## PRQL

[PRQL](https://prql-lang.org/)

* Pipelined Relational Query Language, pronounced “Prequel”
* PRQL is a modern language for transforming data
* a simple, powerful, pipelined SQL replacement

## multicorn - FDW

[Foreign Data Wrappers - Multicorn - A Foreign Data Wrapper Library for PostgreSQL](https://multicorn.org/foreign-data-wrappers/)

Multicorn is bundled with a small set of Foreign Data Wrappers, which you can use or customize for your needs.
