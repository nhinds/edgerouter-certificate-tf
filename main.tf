terraform {
  required_providers {
    acme = {
      source = "vancluever/acme"
      version = "~> 2.5"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.1"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 3.1"
    }
  }
  required_version = ">= 0.13"
}

provider "acme" {
  server_url = var.acme_server_url
}

resource "tls_private_key" "acme_reg_private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.acme_reg_private_key.private_key_pem
  email_address   = var.acme_email
}

resource "acme_certificate" "router" {
  account_key_pem = acme_registration.reg.account_key_pem
  common_name     = var.router_hostname

  dns_challenge {
    provider = "route53"

    config = {
      AWS_PROFILE         = var.aws_profile
      AWS_SDK_LOAD_CONFIG = 1
    }
  }
}

resource "null_resource" "deploy_certificate" {
  # Changes to the certificate should trigger a redeploy
  triggers = {
    certificate_pem = acme_certificate.router.certificate_pem,
    issuer_pem      = acme_certificate.router.issuer_pem,
    private_key_pem = acme_certificate.router.private_key_pem,
  }

  connection {
    type = "ssh"
    user = var.router_username
    host = var.router_hostname
  }

  provisioner "file" {
    content     = "${acme_certificate.router.certificate_pem}\n${acme_certificate.router.issuer_pem}\n${acme_certificate.router.private_key_pem}"
    destination = var.router_cert_file
  }

  provisioner "remote-exec" {
    inline = [
      "sudo pkill lighttpd",
      "sudo /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf",
    ]
  }
}
