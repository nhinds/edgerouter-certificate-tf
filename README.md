# EdgeRouter HTTPS Certificate Terraform

Terraform configuration to create and renew the HTTPS certificate for Ubiquiti's EdgeRouter.

## Prerequisites

1. A public DNS name that resolves to the EdgeRouter - probably pointing to its private IP
2. SSH access to the EdgeRouter via its DNS name using a SSH private key in your SSH agent
3. The `service gui cert-file` setting pointing at a location where the HTTPS certificate should be written

## Applying

Apply a staging certificate, using default username/hostname:

    terraform apply -var acme_email=your-email@example.com

Apply a production certificate, overriding username/hostname:

    terraform apply -var-file letsencrypt-prod.tfvars -var acme_email=your-email@example.com -var router_username=nhinds -var router_hostname=router.example.com

See `variables.tf` for all available settings.
