provider "github" {}

data "github_repository" "repo_src" {
  full_name = var.repo_src
}

# resource "github_repository" "repo_dest" {
#   name        = "${var.repo_dest}"
#   description = "${var.repo_desc}"
#   gitignore_template = "Terraform"
#   private = false
# }

module "repo" {
  source                 = "HappyPathway/repo/github"
  force_name             = var.force_name
  github_is_private      = var.github_is_private
  repo_org               = var.repo_org
  name                   = var.repo_dest
  enforce_prs            = var.enforce_prs
  pull_request_bypassers = var.pull_request_bypassers
  
  # GitHub repository settings
  github_codeowners_team                = var.github_codeowners_team
  github_repo_description               = var.github_repo_description != null ? var.github_repo_description : var.repo_desc
  github_repo_topics                    = var.github_repo_topics
  github_push_restrictions              = var.github_push_restrictions
  github_auto_init                      = var.github_auto_init
  github_allow_merge_commit             = var.github_allow_merge_commit
  github_allow_squash_merge             = var.github_allow_squash_merge
  github_allow_rebase_merge             = var.github_allow_rebase_merge
  github_delete_branch_on_merge         = var.github_delete_branch_on_merge
  github_has_projects                   = var.github_has_projects
  github_has_issues                     = var.github_has_issues
  github_has_wiki                       = var.github_has_wiki
  github_default_branch                 = var.github_default_branch
  github_required_approving_review_count = var.github_required_approving_review_count
  github_require_code_owner_reviews     = var.github_require_code_owner_reviews
  github_dismiss_stale_reviews          = var.github_dismiss_stale_reviews
  github_enforce_admins_branch_protection = var.github_enforce_admins_branch_protection
  github_allow_auto_merge               = var.github_allow_auto_merge
  github_has_downloads                  = var.github_has_downloads
  additional_codeowners                 = var.additional_codeowners
  prefix                                = var.prefix
  github_org_teams                      = var.github_org_teams
  template_repo_org                     = var.template_repo_org
  template_repo                         = var.template_repo
  is_template                           = var.is_template
  admin_teams                           = var.admin_teams
  required_status_checks                = var.required_status_checks
  archived                              = var.archived
  secrets                               = var.secrets
  vars                                  = var.vars
  extra_files                           = var.extra_files
  managed_extra_files                   = var.managed_extra_files
  create_codeowners                     = var.create_codeowners
  collaborators                         = var.collaborators
  archive_on_destroy                    = var.archive_on_destroy
  vulnerability_alerts                  = var.vulnerability_alerts
  gitignore_template                    = var.gitignore_template
  homepage_url                          = var.homepage_url
  create_repo                           = var.create_repo
  security_and_analysis                 = var.security_and_analysis
  environments                          = var.environments
  license_template                      = var.license_template
  github_has_discussions                = var.github_has_discussions
  github_merge_commit_title             = var.github_merge_commit_title
  github_merge_commit_message           = var.github_merge_commit_message
  github_squash_merge_commit_title      = var.github_squash_merge_commit_title
  github_squash_merge_commit_message    = var.github_squash_merge_commit_message
  github_allow_update_branch            = var.github_allow_update_branch
  pages_config                          = var.pages_config
  allow_unsigned_files                  = var.allow_unsigned_files
  commit_author                         = var.commit_author
  commit_email                          = var.commit_email
  require_signed_commits                = var.require_signed_commits
  require_last_push_approval            = var.require_last_push_approval
  github_pro_enabled                    = var.github_pro_enabled
  deploy_keys                           = var.deploy_keys
}

data "external" "repo_setup" {
  program = ["python3", "${path.module}/templates/git_setup.py"]

  query = {
    repo_dir = var.repo_dir
    # Use specific source repository URL type based on use_ssh_source
    src_clone_url = var.use_ssh_source ? data.github_repository.repo_src.ssh_clone_url : data.github_repository.repo_src.http_clone_url
    # Use specific destination repository URL type based on use_ssh_destination
    dest_clone_url = var.use_ssh_destination ? module.repo.github_repo.ssh_clone_url : module.repo.github_repo.http_clone_url
    repo_branch = var.repo_branch
    sub_dir = var.sub_dir
    default_branch = var.github_default_branch != null ? var.github_default_branch : "main"
    use_ssh_source = var.use_ssh_source ? "true" : "false"
    use_ssh_destination = var.use_ssh_destination ? "true" : "false"
  }

  # Ensure this runs after the GitHub repository is created
  depends_on = [module.repo]
}

resource "github_release" "initial_release" {
  count       = var.module ? 1 : 0
  
  # Ensure this runs after the repository setup
  depends_on = [
    data.external.repo_setup
  ]
  
  # Only create if the repo setup was successful
  repository  = var.repo_dest
  tag_name    = "v1.0.0"
  name        = "Initial Release"
  body        = "Initial release from source repository"
  draft       = false
  prerelease  = false
  
  # Point the release to the default branch
  target_commitish = data.external.repo_setup.result.default_branch
}
