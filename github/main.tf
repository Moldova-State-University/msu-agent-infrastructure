################################################################################
# Local Values 
################################################################################

locals {
  # Transform nested team membership structure into flat map for Terraform iteration
  # This converts team -> [members] into individual team-member pairs
  # Example: {"ai-team": ["alice", "bob"]} becomes {"ai-team-alice": {...}, "ai-team-bob": {...}}
  sub_team_memberships = merge([
    for team_name, team_config in var.sub_team : {
      for member in team_config.members :
      "${team_name}-${member}" => {
        team_id  = github_team.sub_teams[team_name].id
        username = member
      }
    }
  ]...)

  # Transform repository team access structure into flat map for Terraform iteration
  # This converts repo -> {team: permission} into individual repo-team-permission triplets
  # Example: {"repo1": {"ai-team": "maintain"}} becomes {"repo1-ai-team": {...}}
  team_repository_access = merge([
    for repo_key, repo_config in var.repositories : {
      for team_slug, permission in repo_config.team_access :
      "${repo_key}-${team_slug}" => {
        repository_name = github_repository.repos[repo_key].name
        team_id         = github_team.sub_teams[team_slug].id
        permission      = permission
      }
    }
  ]...)
}

################################################################################
# Data Sources 
################################################################################

# Parent Team Data
data "github_team" "parent_team" {
  slug = var.parent_team_slug
}

################################################################################
# Organization Management
################################################################################

# Add Users to Organization
resource "github_membership" "org_members" {
  for_each = var.users

  username = each.key
  role     = each.value.org_role
}

################################################################################
# Team Management
################################################################################

# Add Users to Parent Team
resource "github_team_membership" "parent_team_members" {
  for_each = var.users

  team_id  = data.github_team.parent_team.id
  username = each.key
  role     = "member"

  # Ensure users are added to the organization before adding to the team
  depends_on = [github_membership.org_members]
}

# Create Sub-Teams
resource "github_team" "sub_teams" {
  for_each = var.sub_team

  name           = each.key
  description    = each.value.description
  parent_team_id = data.github_team.parent_team.id
  privacy        = "closed"
}

# Add Members to Sub-Teams
resource "github_team_membership" "sub_team_members" {
  for_each = local.sub_team_memberships

  team_id  = each.value.team_id
  username = each.value.username
  role     = "member"

  # Ensure users are added to the organization and parent team before adding to sub-teams
  depends_on = [
    github_membership.org_members,
    github_team_membership.parent_team_members
  ]
}


################################################################################
# Repository Management
################################################################################

# Create Repositories
resource "github_repository" "repos" {
  for_each = var.repositories

  name        = each.value.name != null ? each.value.name : each.key
  description = each.value.description
  visibility  = each.value.visibility
  topics      = each.value.topics

  # Initialize repository with initial commit if requested
  auto_init = each.value.auto_init

  # Best Practices Settings
  delete_branch_on_merge = true
  vulnerability_alerts   = true
  has_issues             = true
  has_wiki               = true
  has_projects           = false

  # Lifecycle rule to ignore changes to auto_init after creation
  lifecycle {
    ignore_changes = [
      auto_init
    ]
  }
}

# Grant Team Access to Repositories
resource "github_team_repository" "team_access" {
  for_each = local.team_repository_access

  team_id    = each.value.team_id
  repository = each.value.repository_name
  permission = each.value.permission

  # Ensure sub-team members are added before granting access
  depends_on = [github_team_membership.sub_team_members]
}

################################################################################
# Branch Protection
################################################################################

# Branch Protection for main branch
resource "github_branch_protection" "main" {
  for_each = var.repositories

  repository_id = github_repository.repos[each.key].name
  pattern       = "main"

  enforce_admins = true

  required_pull_request_reviews {
    # Dismiss stale reviews when new commits are pushed
    dismiss_stale_reviews = true
    # Require code owner reviews when CODEOWNERS file exists
    require_code_owner_reviews = true
    # Number of required approvals before merge
    required_approving_review_count = each.value.required_approving_review_count
    # Require approval for the last push
    require_last_push_approval = false
  }

  required_status_checks {
    strict   = true
    contexts = []
  }

  # Completely restrict direct pushes to main branch
  # All changes must go through pull requests
  restrict_pushes {
    blocks_creations = true
    push_allowances  = []
  }
}
