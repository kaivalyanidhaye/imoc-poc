# Core rules are built-in. Enable AWS plugin rules if your network allows plugin download.
plugin "aws" {
  enabled = true
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
  version = "0.33.0"  # optional; pin if you prefer
}

# Helpful generic checks
rule "terraform_unused_declarations"     { enabled = true }
rule "terraform_deprecated_interpolation" { enabled = true }
