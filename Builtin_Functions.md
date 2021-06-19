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
## Built-in Functions

---
# Built-in Functions

The Terraform language includes a number of built-in functions that you can call from within expressions to transform and combine values

---
# Built-in Functions: max

```
> max(-1, 4)
4
```

---
# Built-in Functions: file

```
> file("/etc/debian_version")
buster/sid
```

---
# Built-in Functions: merge

```
> merge({"a"="1", "b"="2"}, {"c"="3", "d"="4"})
{
  "a" = "1"
  "b" = "2"
  "c" = "3"
  "d" = "4"
}
```

---
# Built-in Functions: toset

```
> toset(["a", "b", "a"])
[
  "a",
  "b",
]
```

---
# Built-in Functions: uuid

```
> uuid()
"06e721d4-7122-6e3a-4a48-56a8875e3fed"
```

---
# Built-in Functions: uuid

man page: [Functions](https://www.terraform.io/docs/language/functions/index.html)
