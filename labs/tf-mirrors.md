* https://registry.comcloud.xyz/
* https://tf.org.ru/
* https://terraform-mirror.mcs.mail.ru/
* https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#configure-provider

```bash
cat << 'EOF' >> ~/.tofurc
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.opentofu.org/*/*"]
  }
  direct {
    exclude = ["registry.opentofu.org/*/*"]
  }
}
EOF
```
