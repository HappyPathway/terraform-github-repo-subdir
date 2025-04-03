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
    success = data.external.repo_setup.result.success
    message = try(data.external.repo_setup.result.message, null)
    repo_dir = try(data.external.repo_setup.result.repo_dir, null)
    default_branch = try(data.external.repo_setup.result.default_branch, null)
  }
  description = "Result of the repository setup operation"
}
