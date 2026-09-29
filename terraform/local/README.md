# Local Infrastructure

A standalone Terraform exercise that creates two nested folders and an HTML welcome page on the local machine. The commands use PowerShell, so run this exercise on Windows.

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
- Access to create files and folders at `target_path`

## Workflow

Run these commands from this directory. Supply the destination path when planning and applying:

```powershell
terraform init
terraform fmt -recursive
terraform validate
terraform plan -var 'target_path=C:\Terraform\LocalExercise'
terraform apply -var 'target_path=C:\Terraform\LocalExercise'
```

Terraform manages `index.html`; `terraform destroy` removes that file. The folders created by the PowerShell provisioner remain after destroy to avoid deleting unrelated files from the target path.