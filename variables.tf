variable "acme_server_url" {
  type        = string
  description = "ACME directory URL (defaults to Let's Encrypt Staging)"
  default     = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

variable "acme_email" {
  type        = string
  description = "Email address for ACME account registration"
}

variable "router_hostname" {
  type        = string
  description = "Domain name to register for the router, expected to already resolve to the router's IP for SSH"
  default     = "router.i.dnh.nz"
}

variable "router_username" {
  type        = string
  description = "Username to use to SSH to the router. Your SSH agent should contain a private key that can be used to SSH in as this user"
  default     = "ubnt"
}

variable "router_cert_file" {
  type        = string
  description = "File to place the router certificate in. Should match the 'service gui cert-file' setting"
  default     = "/config/auth/ssl/https-certificate.pem"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile to use for Route 53 registration"
  default     = "dnh"
}
