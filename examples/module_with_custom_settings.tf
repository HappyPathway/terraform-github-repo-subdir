# Example: Creating a module repository with custom GitHub settings
# This example demonstrates advanced configuration options when creating a new module repository

provider "github" {
  # Configure with your preferred GitHub provider settings
  # token = "your-github-token"  # Set via environment variable GITHUB_TOKEN instead of hardcoding
}

module "iam_role_repo" {
  source = "../"  # Use the parent module
  
  # Source repository information
  repo_src = "HappyPathway/terraform-aws-image-pipeline"
  repo_branch = "main"
  sub_dir = "modules/iam-role"
  
  # Destination repository information
  repo_org = "HappyPathway"
  repo_dest = "terraform-aws-iam-roles"
  repo_desc = "AWS IAM roles module for infrastructure pipelines"
  
  # Local filesystem path where repo will be cloned
  repo_dir = "/tmp/terraform-aws-iam-roles"
  
  # Mark as a Terraform module
  module = "true"
  
  # GitHub repository settings
  github_is_private = true  # Make this repository private
  enforce_prs = true
  
  # Branch protection settings
  github_required_approving_review_count = 2  # Require 2 approvals for PRs
  github_require_code_owner_reviews = true    # Require review from code owners
  github_dismiss_stale_reviews = true         # Dismiss approvals when PR is updated
  github_enforce_admins_branch_protection = true  # Apply to admins too
  
  # Advanced security settings
  vulnerability_alerts = true  # Enable Dependabot alerts
  security_and_analysis = {
    advanced_security = {
      status = "enabled"
    }
    secret_scanning = {
      status = "enabled"
    }
    secret_scanning_push_protection = {
      status = "enabled"
    }
  }
  
  # Repository features
  github_has_issues = true
  github_has_wiki = true
  github_has_projects = true
  github_has_discussions = true
  
  # Team access
  admin_teams = ["devops", "platform-team"]
  github_codeowners_team = "platform-team"
  additional_codeowners = ["@security-team"]
  
  # Repository topics and metadata
  github_repo_topics = ["terraform", "aws", "iam", "security", "infrastructure"]
  homepage_url = "https://internal-docs.example.com/terraform/iam-roles"
  
  # Add collaborators
  collaborators = {
    "security-reviewer" = "maintain",
    "junior-dev" = "pull"
  }
  
  # Merging strategy
  github_allow_merge_commit = false
  github_allow_squash_merge = true
  github_allow_rebase_merge = true
  github_delete_branch_on_merge = true
  
  # Add extra files to the repository
  extra_files = [
    {
      path = "SECURITY.md",
      content = <<-EOT
        # Security Policy

        ## Reporting a Vulnerability

        Please report security vulnerabilities to security@example.com.
        
        We will acknowledge receipt of your vulnerability report and send you regular updates about our progress.
      EOT
    },
    {
      path = ".github/CODEOWNERS",
      content = <<-EOT
        # These owners will be the default owners for everything in the repo
        *       @platform-team
        
        # Security-related files
        *.tf     @security-team
        README.md  @docs-team
      EOT
    }
  ]
}

output "new_repo_details" {
  description = "Details of the newly created repository"
  value = {
    name = module.iam_role_repo.repo_name
    ssh_url = module.iam_role_repo.ssh_clone_url
    http_url = module.iam_role_repo.http_clone_url
    setup_result = module.iam_role_repo.repo_setup_result
  }
}