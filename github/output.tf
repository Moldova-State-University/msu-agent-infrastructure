################################################################################
# Organization Outputs
################################################################################

output "organization_members" {
  description = "List of users added to organization"
  value       = keys(var.users)
}

################################################################################
# Parent Team Outputs
################################################################################

output "parent_team" {
  description = "Parent team information"
  value = {
    name = data.github_team.parent_team.name
    slug = data.github_team.parent_team.slug
    id   = data.github_team.parent_team.id
  }
}

################################################################################
# Sub-Teams Outputs
################################################################################

output "sub_teams" {
  description = "Created sub-teams with their members"
  value = {
    for name, team in github_team.sub_teams : name => {
      id          = team.id
      slug        = team.slug
      description = team.description
      members     = var.sub_team_slugs[name].members
    }
  }
}

################################################################################
# Repository Outputs 
################################################################################

output "repositories" {
  description = "Created repositories with details"
  value = {
    for name, repo in github_repository.repos : name => {
      url         = repo.html_url
      ssh_url     = repo.ssh_clone_url
      visibility  = repo.visibility
      description = repo.description
      topics      = repo.topics
    }
  }
}

################################################################################
# Repository Access Summary 
################################################################################

output "repository_access_summary" {
  description = "Summary of repository access by teams"
  value = {
    for name, config in var.repositories : name => {
      repository       = name
      topics           = config.topics
      team_access      = config.team_access
      required_reviews = config.required_approving_review_count
      auto_init        = config.auto_init
      # Примечание: Прямой push в main ЗАПРЕЩЕН для всех - только через Pull Requests
      main_branch_protection = "No direct push allowed - PR only"
    }
  }
}

################################################################################
# Team Repository Access Matrix 
################################################################################

output "team_repository_access_matrix" {
  description = "Detailed matrix of team access to repositories"
  value = {
    for access_key, access_info in local.team_repository_access : access_key => {
      repository = access_info.repository_name
      team_id    = access_info.team_id
      permission = access_info.permission
    }
  }
}


################################################################################
# Complete Summary Output 
################################################################################

output "summary" {
  description = "Complete summary of organization, teams, members, and repositories"
  value = {
    organization_members = keys(var.users)
    parent_team = {
      name = data.github_team.parent_team.name
      slug = data.github_team.parent_team.slug
      id   = data.github_team.parent_team.id
    }
    sub_teams = {
      for name, team in github_team.sub_teams : name => {
        id          = team.id
        slug        = team.slug
        description = team.description
        members     = var.sub_team_slugs[name].members
      }
    }
    repositories = {
      for name, repo in github_repository.repos : name => {
        url         = repo.html_url
        ssh_url     = repo.ssh_clone_url
        visibility  = repo.visibility
        description = repo.description
        topics      = repo.topics
      }
    }
  }
}


