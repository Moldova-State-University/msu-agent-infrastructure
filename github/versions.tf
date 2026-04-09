terraform {
  required_version = ">= 1.6.0"

  cloud {
    organization = "msu-agent"

    workspaces {
      name = "msu-agent-github-infra"
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
