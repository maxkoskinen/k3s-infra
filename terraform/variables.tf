variable "cloudflare_api_token" {
  description = "Cloudflare API token for DNS challenge"
  type        = string
  sensitive   = true
}

variable "acme_email" {
  description = "Cloudflare account email"
  type        = string
  sensitive   = true
}

variable "github_pat" {
  description = "Github personal access token for gha scale set"
  type        = string
  sensitive   = true
}

variable "mail_smtp_username" {
  type      = string
  sensitive = true
}

variable "mail_smtp_password" {
  type      = string
  sensitive = true
}

variable "vaultwarden_admin_token" {
  type      = string
  sensitive = true
}