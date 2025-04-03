output "ssh_clone_url" {
  value = module.repo.github_repo.ssh_clone_url
}

output "http_clone_url" {
  value = module.repo.github_repo.http_clone_url
}

output "repo_name" {
  value = module.repo.github_repo.full_name
}

output "repo_setup_result" {
  value = {
    repo_dir = null_resource.repo_setup.triggers.repo_dir
    default_branch = null_resource.repo_setup.triggers.default_branch
  }
  description = "Information about the repository setup operation"
}
