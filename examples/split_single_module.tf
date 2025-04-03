# Example: Split a single module from a monolithic Terraform repository
# This example shows how to extract just the codebuild module from terraform-aws-image-pipeline

provider "github" {
  # Configure with your preferred GitHub provider settings
  # token = "your-github-token"  # Set via environment variable GITHUB_TOKEN instead of hardcoding
}

module "codebuild_repo" {
  source = "../"  # Use the parent module
  
  # Source repository information
  repo_src = "HappyPathway/terraform-aws-image-pipeline"
  repo_branch = "main"
  sub_dir = "modules/codebuild"  # The specific subdirectory to extract
  
  # Destination repository information
  repo_org = "HappyPathway"
  repo_dest = "terraform-aws-codebuild"
  repo_desc = "AWS CodeBuild module extracted from the terraform-aws-image-pipeline"
  
  # Local filesystem path where repo will be cloned
  repo_dir = "/tmp/terraform-aws-codebuild"
  
  # Mark as a Terraform module
  module = "true"
  
  # GitHub repository settings
  github_is_private = false
  enforce_prs = true
  pull_request_bypassers = ["admin-user"]  # Allow specific users to bypass PR requirements
  
  # Use SSH for the source repo (if you have SSH keys configured), but HTTPS for destination
  # This can be useful in mixed environments
  use_ssh_source = true
  use_ssh_destination = false
  
  # Additional GitHub settings
  github_repo_topics = ["terraform", "aws", "codebuild", "ci-cd"]
  github_has_issues = true
  github_has_wiki = false
  github_allow_merge_commit = false
  github_allow_squash_merge = true
  github_allow_rebase_merge = false
  github_delete_branch_on_merge = true
}

output "new_repo_urls" {
  description = "URLs of the newly created repository"
  value = {
    ssh = module.codebuild_repo.ssh_clone_url
    http = module.codebuild_repo.http_clone_url
    name = module.codebuild_repo.repo_name
  }
}