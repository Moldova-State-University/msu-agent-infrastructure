################################################################################
# GitHub Organization Configuration
################################################################################

variable "org_name" {
  description = "Github organization name"
  type        = string
}

variable "github_token" {
  description = "GitHub token with appropriate permissions"
  type        = string
  sensitive   = true
}

################################################################################
# Users Configuration
################################################################################

variable "users" {
  description = "Users to add to organization and parent team"

  type = map(object({
    org_role = string # member or admin
  }))

  validation {
    condition     = alltrue([for user in values(var.users) : contains(["member", "admin"], user.org_role)])
    error_message = "Each user's org_role must be either 'member' or 'admin'."
  }
}

################################################################################
# Repository Configuration
################################################################################

variable "repositories" {
  description = <<-EOT
    Repositories to create with team access.
    Each repository includes:
      - name: Repository name (auto-generated from key if not provided)
      - description: Repository description
      - visibility: public, private, or internal
      - topics: List of repository topics for organization and discovery
      - team_access: Map of teams with their permissions
          * pull: Read-only access
          * triage: Read access + manage issues and pull requests
          * push: Read and write access
          * maintain: Push access + manage repository settings
          * admin: Full administrative access
      - required_approving_review_count: Number of required approvals (0-6)
      - auto_init: Whether to initialize repository with initial commit and README
  EOT

  type = map(object({
    name                            = optional(string) # repository name (defaults to key)
    description                     = string
    visibility                      = string
    topics                          = optional(list(string), []) # repository topics
    team_access                     = map(string)                # team_slug -> permission mapping
    required_approving_review_count = number
    auto_init                       = optional(bool, false) # initialize with commit and README
  }))

  # Validation for repository visibility
  validation {
    condition     = alltrue([for repo in values(var.repositories) : contains(["public", "private", "internal"], repo.visibility)])
    error_message = "Repository visibility must be one of: public, private, internal."
  }

  # Validation for team permissions
  validation {
    condition = alltrue([
      for repo in values(var.repositories) : alltrue([
        for permission in values(repo.team_access) :
        contains(["pull", "triage", "push", "maintain", "admin"], permission)
      ])
    ])
    error_message = "All team permissions must be one of: pull, triage, push, maintain, admin."
  }

  # Validation for required approving review count
  validation {
    condition     = alltrue([for repo in values(var.repositories) : repo.required_approving_review_count >= 0 && repo.required_approving_review_count <= 6])
    error_message = "required_approving_review_count must be between 0 and 6."
  }
}

################################################################################
# Team Configuration
################################################################################

variable "parent_team_slug" {
  description = "Parent team slug"
  type        = string
  default     = "msu-agent-team"
}

variable "sub_team" {
  description = "List of subteams to create under the parent team"

  type = map(object({
    description = string
    members     = list(string) # usernames
  }))

  default = {}
}
