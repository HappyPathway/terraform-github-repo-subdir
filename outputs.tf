output "ssh_clone_url" {
  value = module.repo.github_repo.ssh_clone_url
}

output "http_clone_url" {
  value = module.repo.github_repo.http_clone_url
}

output "repo_name" {
  value = module.repo.github_repo.full_name
}