# Example: Split all submodules from a monolithic Terraform repository
# This example shows how to create separate GitHub repositories for each submodule 
# in the terraform-aws-image-pipeline repository

provider "github" {
  # Configure with your preferred GitHub provider settings
  # token = "your-github-token"  # Set via environment variable GITHUB_TOKEN instead of hardcoding
}

locals {
  # Source repository details
  source_repo = "HappyPathway/terraform-aws-image-pipeline"
  github_org = "HappyPathway"  # Target GitHub organization
  
  # List of modules to split into separate repositories
  modules = [
    {
      name = "build_user"
      description = "Terraform module for AWS image pipeline build user"
      path = "modules/build_user"
    },
    {
      name = "codebuild"
      description = "Terraform module for AWS CodeBuild configuration"
      path = "modules/codebuild"
    },
    {
      name = "codepipeline"
      description = "Terraform module for AWS CodePipeline configuration"
      path = "modules/codepipeline"
    },
    {
      name = "iam-role"
      description = "Terraform module for IAM roles used in AWS image pipeline"
      path = "modules/iam-role"
    },
    {
      name = "kms"
      description = "Terraform module for KMS keys used in AWS image pipeline"
      path = "modules/kms"
    },
    {
      name = "s3"
      description = "Terraform module for S3 buckets used in AWS image pipeline"
      path = "modules/s3"
    }
  ]
}

# Create separate repositories for each module
module "repo_split" {
  source = "../"  # Use the parent module
  
  # Create one resource per module
  for_each = { for m in local.modules : m.name => m }
  
  # Source repository information
  repo_src = local.source_repo
  repo_branch = "main"  # Specify your source branch
  sub_dir = each.value.path
  
  # Destination repository information
  repo_org = local.github_org
  repo_dest = "terraform-aws-${each.key}"
  repo_desc = each.value.description
  
  # Local filesystem path where repo will be cloned
  repo_dir = "/tmp/terraform-aws-${each.key}"
  
  # Mark as a Terraform module
  module = "true"
  
  # GitHub repository settings
  github_is_private = false
  github_default_branch = "main"
  enforce_prs = true
  github_has_issues = true
  github_has_wiki = false
  github_has_downloads = false
  github_has_projects = false
  
  # Use HTTPS for cloning (more CI/CD friendly)
  use_ssh_source = false
  use_ssh_destination = false
  
  # Add appropriate topics
  github_repo_topics = ["terraform", "aws", "module", each.key]
  
  # License and README configuration
  license_template = "apache-2.0"
}

output "new_repositories" {
  description = "URLs of the newly created repositories"
  value = {
    for name, repo in module.repo_split : name => {
      ssh_url = repo.ssh_clone_url
      http_url = repo.http_clone_url
    }
  }
}