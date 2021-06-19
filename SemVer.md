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
## SemVer and back compatibility

---
# SemVer

[Semantic Versioning 2.0.0 | Semantic Versioning](https://SemVer.org/)

> In the world of software management there exists a dreaded place called “dependency hell.” The bigger your system grows and the more packages you integrate into your software, the more likely you are to find yourself, one day, in this pit of despair.

---
# SemVer format

[Semantic Versioning 2.0.0 | Semantic Versioning](https://SemVer.org/)

> Given a version number MAJOR.MINOR.PATCH, increment the:
> 
> 1. MAJOR version when you make incompatible API changes,
> 2. MINOR version when you add functionality in a backwards compatible manner, and
> 3. PATCH version when you make backwards compatible bug fixes.
> 
> Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

---
# SemVer playground

[Semantic Versioning 2.0.0 | Semantic Versioning](https://SemVer.org/)

> There are two RegExex to check a SemVer string. 
> 
> 1. One with named groups for those systems that support them (PCRE \[Perl Compatible Regular Expressions, i.e. Perl, PHP and R\], Python and Go).
> See: [https://regex101.com/r/Ly7O1x/3/](https://regex101.com/r/Ly7O1x/3/)
> 1. Another with numbered capture groups instead (so cg1 = major, cg2 = minor, cg3 = patch, cg4 = prerelease and cg5 = buildmetadata) that is compatible with ECMA Script (JavaScript), PCRE (Perl Compatible Regular Expressions, i.e. Perl, PHP and R), Python and Go.
> See: [https://regex101.com/r/vkijKf/1/](https://regex101.com/r/vkijKf/1/)

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
# ... and beyond )

[1.1.0 (Unreleased)](https://github.com/hashicorp/terraform/releases/tag/v1.1.0-alpha20210616)

* lang/funcs: add a new `type()` function, only available in `terraform console` 
* configs: Terraform now checks the syntax of and normalizes module source addresses (the `source` argument in `module` blocks) during configuration decoding rather than only at module installation time. This is largely just an internal refactoring, but a visible benefit of this change is that the `terraform init` messages about module downloading will now show the canonical module package address Terraform is downloading from, after interpreting the special shorthands for common cases like GitHub URLs. 
* command/show: The -json output now indicates which state values are sensitive. 
