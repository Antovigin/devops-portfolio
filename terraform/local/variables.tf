variable "target_path" {
  description = "Absolute or relative path where the directory structure will be created."
  type        = string

  validation {
    condition     = length(trimspace(var.target_path)) > 0
    error_message = "target_path must not be empty."
  }
}

variable "first_folder" {
  description = "Name of the first folder under target_path."
  type        = string
  default     = "folder1"

  validation {
    condition     = length(trimspace(var.first_folder)) > 0 && !strcontains(var.first_folder, "\\") && !strcontains(var.first_folder, "/")
    error_message = "first_folder must be a non-empty folder name without path separators."
  }
}

variable "second_folder" {
  description = "Name of the second folder under first_folder."
  type        = string
  default     = "folder2"

  validation {
    condition     = length(trimspace(var.second_folder)) > 0 && !strcontains(var.second_folder, "\\") && !strcontains(var.second_folder, "/")
    error_message = "second_folder must be a non-empty folder name without path separators."
  }
}