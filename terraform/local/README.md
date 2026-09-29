# Local Infrastructure

A standalone Terraform exercise that enables the IIS web server feature, creates two nested folders, and writes an HTML welcome page on the local Windows machine. The commands use PowerShell, so run this exercise on Windows.

## Structure

```text
local/
|-- README.md
|-- main.tf
|-- variables.tf
|-- versions.tf
`-- .gitignore
```

The resulting structure is:

```text
<target_path>/
`-- folder1/
	`-- folder2/
		`-- index.html
```

The generated page displays `Welcome to my Program world`.

## Requirements

- Terraform CLI 1.4 or later
- PowerShell
- Windows optional feature management cmdlets (`Enable-WindowsOptionalFeature` and `Get-WindowsOptionalFeature`)
- An elevated PowerShell session (Run as Administrator) to enable IIS
- Access to create files and folders at `target_path`

## Workflow

Run these commands from an elevated PowerShell session and from this directory. Supply the destination path when planning and applying:

```powershell
terraform init
terraform fmt -recursive
terraform validate
terraform plan -var 'target_path=C:\Terraform\LocalExercise'
terraform apply -var 'target_path=C:\Terraform\LocalExercise'
```

Terraform manages `index.html`; `terraform destroy` removes that file but does not disable IIS or remove the folders created by the PowerShell provisioner. This avoids removing Windows functionality or unrelated files during cleanup. The IIS provisioner runs when its Terraform resource is first created; to re-run it after removing or repairing IIS, replace the resource with `terraform apply -replace=terraform_data.iis` from the elevated session.