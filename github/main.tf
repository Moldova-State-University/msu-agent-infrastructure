# Add Users to Organization
resource "github_membership" "org_members" {
  for_each = var.users

  username = each.key
  role     = each.value.org_role
}

# Parent Team Data
data "github_team" "parent_team" {
  slug = var.parent_team_slug
}

# Add Users to Parent Team
resource "github_team_membership" "parent_team_members" {
  for_each = var.users

  team_id  = data.github_team.parent_team.id
  username = each.key
  role     = "member"

  # Ensure users are added to the organization before adding to the team
  depends_on = [github_membership.org_members]
}

# Add Sub-Teams Data
resource "github_team" "sub_teams" {
  for_each = var.sub_team_slugs

  name           = each.key
  description    = each.value.description
  parent_team_id = data.github_team.parent_team.id
  privacy        = "closed"
}

# Add Members to Sub-Teams

# Logic: Create a local map that combines team names with their members
# e.g. for team "devs" with members ["alice", "bob"], create keys "devs-alice", "devs-bob"
# this allows us to use for_each to create memberships
# without this we cannot directly iterate over nested lists in Terraform

locals {
  sub_team_memberships = merge([
    for team_name, team_config in var.sub_team_slugs : {
      for member in team_config.members :
      "${team_name}-${member}" => {
        team_id  = github_team.sub_teams[team_name].id
        username = member
      }
    }
  ]...)
}

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


# Create Repository
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

# Grant Team Access to Repository
# Logic: Create a local map that combines repository names with team access
# e.g. for repo "msu-agent" with team access {"ai-team": "maintain", "web-team": "push"}
# create keys "msu-agent-ai-team", "msu-agent-web-team"

locals {
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

resource "github_team_repository" "team_access" {
  for_each = local.team_repository_access

  team_id    = each.value.team_id
  repository = each.value.repository_name
  permission = each.value.permission

  # Ensure sub-team members are added before granting access
  depends_on = [github_team_membership.sub_team_members]
}

# Branch Protection for main branch
resource "github_branch_protection" "main" {
  for_each = var.repositories

  repository_id = github_repository.repos[each.key].name
  pattern       = "main"

  enforce_admins = true

  required_pull_request_reviews {
    # dismiss stale reviews - true/false is to dismiss previous approvals when new commits are pushed
    dismiss_stale_reviews = true
    # Require code owner reviews - true/false to enforce reviews from code owners
    require_code_owner_reviews = true
    # required_approving_review_count - set from variable is the number of required approvals
    required_approving_review_count = each.value.required_approving_review_count
    # require_last_push_approval - true/false to require approval for the last push
    require_last_push_approval = false
  }

  required_status_checks {
    strict   = true
    contexts = []
  }

  # Restrict Direct Pushes to main branch
  restrict_pushes {
    blocks_creations = true
    push_allowances  = []
  }
}
