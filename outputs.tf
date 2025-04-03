output "ssh_clone_url" {
  value = module.repo.github_repository.ssh_clone_url
}

output "http_clone_url" {
  value = module.repo.github_repository.http_clone_url
}

output "repo_name" {
  value = module.repo.github_repository.full_name
}

output "repo_setup_result" {
  value = {
    success = data.external.repo_setup.result.success
    message = data.external.repo_setup.result.message
    repo_dir = data.external.repo_setup.result.repo_dir
    default_branch = data.external.repo_setup.result.default_branch
  }
  description = "Result of the repository setup operation"
}
