output "ssh_clone_url" {
    value = "${github_repository.repo_dest.ssh_clone_url}"
}

output "http_clone_url" {
    value = "${github_repository.repo_dest.http_clone_url}"
}

output "repo_name" {
    value = "${github_repository.repo_dest.full_name}"
}
