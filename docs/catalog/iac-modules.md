# IaC Modules Catalog

## Summary

| Area | Path | Shape | Notes |
| --- | --- | --- | --- |
| Terraform placeholder | `iac/modules/terraform/` | directory | Reserved top-level bucket |
| Pulumi placeholder | `iac/modules/pulumi/` | directory | Reserved top-level bucket |
| Imported module project | `iac/modules/` | mixed tree | Includes docs, examples, scripts, skills, and provider-specific modules |

## Top-Level Layout

| Entry | Path | Type | Notes |
| --- | --- | --- | --- |
| docs | `iac/modules/docs/` | directory | Module documentation |
| example | `iac/modules/example/` | directory | Provider examples |
| pulumi | `iac/modules/pulumi/` | directory | Pulumi placeholder area |
| scripts | `iac/modules/scripts/` | directory | Helper and validation scripts |
| skills | `iac/modules/skills/` | directory | IaC-adjacent skills |
| terraform | `iac/modules/terraform/` | directory | Terraform placeholder area |
| terraform-hcl-standard | `iac/modules/terraform-hcl-standard/` | directory | Main multi-provider Terraform module library |
| vpn-overlay | `iac/modules/vpn-overlay/` | directory | VPN overlay assets and configs |

## Notable Files

| File | Path | Notes |
| --- | --- | --- |
| README | `iac/modules/README.md` | Imported project overview |
| requirements | `iac/modules/requirements.txt` | Python dependencies for helpers |
| gitmodules | `iac/modules/.gitmodules` | Imported upstream metadata |

## Provider-Oriented Areas

| Area | Path | Notes |
| --- | --- | --- |
| Example Terraform | `iac/modules/example/terraform/` | Example provider layouts including GCP |
| Terraform standards | `iac/modules/terraform-hcl-standard/` | AliCloud, AWS, Azure, GCP, Vultr provider structures |
| VPN overlay | `iac/modules/vpn-overlay/` | WireGuard, VXLAN, Xray, and topology assets |

## Notes

| Topic | Note |
| --- | --- |
| Imported metadata | `iac/modules/` still contains imported repo metadata such as `.github/`, `.gitignore`, and `.gitmodules` |
| Curation direction | Later split can separate reusable modules from repo-level baggage |
