# MSU Agent GitHub Infrastructure

## Overview

This Terraform module manages the GitHub infrastructure for the Moldova State University (MSU) Agent project. It provides automated provisioning and management of GitHub organization resources including teams, repositories, user access controls, and branch protection policies.

The module implements Infrastructure as Code (IaC) principles to ensure consistent, reproducible, and auditable management of the project's GitHub resources.

## Architecture

### Components

- **Organization Management**: User roles and organization-level permissions
- **Team Structure**: Hierarchical team organization with parent and sub-teams
- **Repository Management**: Automated repository creation with standardized configurations
- **Access Control**: Fine-grained team-based repository permissions
- **Branch Protection**: Enforced code review workflows and main branch protection

### Team Structure

The project utilizes a hierarchical team structure with specialized teams:

- **AI Team**: Artificial Intelligence and machine learning components
- **AR Team**: Augmented Reality and mobile development
- **Web Team**: Web development and user interfaces
- **DevOps Team**: Infrastructure, CI/CD, and deployment automation
- **QA Team**: Quality assurance, testing, and validation
- **PM Team**: Project management and coordination

## Prerequisites

### Software Requirements

- Terraform >= 1.6.0
- GitHub Provider >= 6.0

### Authentication

A GitHub Personal Access Token (PAT) with the following permissions is required:

- `admin:org` - Full organization administration
- `repo` - Full repository access
- `read:user` - Read user information
- `user:email` - Access user email addresses

### Environment Setup

```bash
export GITHUB_TOKEN="your_github_token_here"
export TF_VAR_github_token="your_github_token_here"
```

## Configuration

### Repository Configuration Schema

Each repository in the configuration supports the following attributes:

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `name` | string | No | key | Repository name (auto-generated from key if not provided) |
| `description` | string | Yes | - | Repository description |
| `visibility` | string | Yes | - | Repository visibility (public, private, internal) |
| `topics` | list(string) | No | [] | Repository topics for organization and discovery |
| `team_access` | map(string) | Yes | - | Team access mapping (team_slug -> permission) |
| `required_approving_review_count` | number | Yes | - | Number of required approvals (0-6) |
| `auto_init` | bool | No | false | Initialize repository with initial commit and README |

### Permission Levels

| Permission | Description | Repository Access | Issues & PRs | Settings | Actions |
|------------|-------------|-------------------|--------------|----------|---------|
| `pull` | Read-only access | Clone, fetch | View | None | View |
| `triage` | Issue management | Clone, fetch | Manage | None | View |
| `push` | Read and write | Clone, push | Manage | None | Manage |
| `maintain` | Repository maintenance | Clone, push | Manage | Some | Manage |
| `admin` | Full administrative | Full access | Full access | Full access | Full access |

### Branch Protection Policy

All repositories are configured with the following branch protection rules for the main branch:

- **Direct Push**: Prohibited for all users (including administrators)
- **Pull Request Required**: All changes must go through pull requests
- **Code Review Required**: Based on `required_approving_review_count`
- **Dismiss Stale Reviews**: Enabled when new commits are pushed
- **Code Owner Reviews**: Required when CODEOWNERS file exists
- **Status Checks**: Strict mode enabled
- **Administrator Enforcement**: Enabled

## Usage

### Basic Deployment

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Plan Deployment**:
   ```bash
   terraform plan
   ```

3. **Apply Configuration**:
   ```bash
   terraform apply
   ```

### Configuration Example

```hcl
repositories = {
  "project-api" = {
    name        = "msu-agent-api"
    description = "REST API for MSU Agent application"
    visibility  = "private"
    topics      = ["api", "rest", "backend", "msu"]
    auto_init   = true
    
    team_access = {
      "backend-team" = "maintain"
      "devops-team"  = "admin"
      "qa-team"      = "pull"
    }
    
    required_approving_review_count = 2
  }
}
```

### Team Management

```hcl
sub_team_slugs = {
  "backend-team" = {
    description = "Backend development team"
    members     = ["developer1", "developer2", "tech-lead"]
  }
}
```

## File Structure

```
infrastructure/github/
├── main.tf              # Core resource definitions
├── variables.tf         # Input variable declarations
├── outputs.tf           # Output value declarations
├── providers.tf         # Provider configuration
├── versions.tf          # Terraform and provider version constraints
├── terraform.tfvars     # Variable value assignments
└── README.md           # This documentation
```

## Outputs

The module provides the following outputs for integration and monitoring:

### Organization Outputs
- `organization_members`: List of users in the organization
- `parent_team`: Parent team information and metadata

### Team Outputs
- `sub_teams`: Created sub-teams with member information
- `team_repository_access_matrix`: Detailed team access matrix

### Repository Outputs
- `repositories`: Repository details including URLs and configuration
- `repository_access_summary`: Summary of team access per repository

## Security Considerations

### Access Control
- Principle of least privilege enforced through team-based permissions
- Administrative access limited to essential personnel
- Regular access reviews recommended through team membership auditing

### Branch Protection
- Main branch protection prevents direct commits
- Code review requirements ensure peer validation
- Status checks can be integrated with CI/CD pipelines

### Sensitive Data Management
- GitHub tokens marked as sensitive variables
- Terraform state should be stored securely (remote backend recommended)
- Access logs should be monitored for suspicious activity

## Troubleshooting

### Common Issues

**Permission Denied Errors**:
- Verify GitHub token has required organization permissions
- Check token expiration date
- Ensure token scope includes `admin:org`

**Team Membership Errors**:
- Verify user exists in GitHub
- Check user has accepted organization invitation
- Confirm user permissions for private repositories

**Repository Creation Failures**:
- Check organization repository limits
- Verify repository name uniqueness
- Review organization policy restrictions

### Validation Commands

```bash
# Validate Terraform configuration
terraform validate

# Check formatting
terraform fmt -check

# Plan without applying
terraform plan -out=tfplan

# View current state
terraform show
```

## Maintenance

### Regular Tasks
- Review and update team memberships quarterly
- Audit repository access permissions semi-annually
- Update Terraform provider versions as needed
- Monitor organization usage and limits

### Backup Considerations
- Terraform state files should be backed up regularly
- Repository metadata can be exported via GitHub API
- Team configurations should be documented outside of code

## Contributing

Changes to the infrastructure should follow these guidelines:

1. Create feature branch for modifications
2. Test changes in development environment
3. Submit pull request with detailed description
4. Obtain approval from DevOps team
5. Apply changes during maintenance window

## Support

For infrastructure-related issues or questions:
- Create an issue in the infrastructure repository
- Contact the DevOps team for urgent matters
- Refer to GitHub documentation for provider-specific issues

## License

This infrastructure configuration is maintained by Moldova State University for the MSU Agent project.