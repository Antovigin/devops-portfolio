locals {
  target_path     = abspath(var.target_path)
  first_dir_path  = "${local.target_path}\\${var.first_folder}"
  second_dir_path = "${local.first_dir_path}\\${var.second_folder}"
  html_path       = "${local.second_dir_path}\\index.html"
  html_content    = <<-HTML
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<title>Welcome</title>
		</head>
		<body>
			<h1>Welcome to my Program world</h1>
		</body>
		</html>
	HTML
}

resource "terraform_data" "directories" {
  triggers_replace = [
    local.target_path,
    local.first_dir_path,
    local.second_dir_path,
  ]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-NonInteractive", "-Command"]
    command     = <<-POWERSHELL
			New-Item -ItemType Directory -Force -Path @(
				'${replace(local.target_path, "'", "''")}',
				'${replace(local.first_dir_path, "'", "''")}',
				'${replace(local.second_dir_path, "'", "''")}'
			) | Out-Null
		POWERSHELL
  }
}

resource "local_file" "welcome_page" {
  filename = local.html_path
  content  = local.html_content

  depends_on = [terraform_data.directories]
}

output "created_directories" {
  description = "Directories created for this exercise."
  value       = [local.first_dir_path, local.second_dir_path]
}

output "html_file" {
  description = "Path to the generated welcome page."
  value       = local.html_path
}