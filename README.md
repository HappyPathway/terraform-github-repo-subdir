# terraform-github-repo-subdir

This Terraform module enables you to extract a subdirectory from an existing GitHub repository and create a new GitHub repository with that content, preserving all its files and optionally creating an initial release.

## Features

- Extract and copy a specific subdirectory from a source GitHub repository
- Create a new GitHub repository with the extracted content
- Support for both SSH and HTTPS protocols for source and destination repositories
- Configure comprehensive GitHub repository settings
- Create an optional GitHub release for the new repository
- Fully customizable repository settings (visibility, branch protection, teams, etc.)
- Support for adding extra files, CODEOWNERS, and repository metadata

## Usage

```hcl
module "example_repo" {
  source = "github.com/HappyPathway/terraform-github-repo-subdir"

  # Source repository information
  repo_src    = "org/source-repository"
  repo_branch = "main"
  sub_dir     = "path/to/subdirectory"

  # Destination repository information
  repo_org  = "destination-org"
  repo_dest = "new-repository-name"
  repo_desc = "Description for the new repository"

  # Local filesystem path where repo will be cloned
  repo_dir = "/tmp/new-repository-name"

  # Set to true if this is a Terraform module (creates a v1.0.0 tag)
  module = "true"

  # Configure Git protocol (SSH or HTTPS)
  use_ssh_source      = true  # Use SSH for source repository
  use_ssh_destination = false # Use HTTPS for destination repository
  
  # GitHub repository settings
  github_is_private = false
  enforce_prs       = true
  github_default_branch = "main"
  
  # Add appropriate topics
  github_repo_topics = ["terraform", "infrastructure", "example"]
}
```

## Requirements

- Python 3.6+
- Git
- GitHub Personal Access Token with appropriate permissions
- Terraform 0.13+

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| repo_src | Name of source repo, must be in form `<GithubOrg>/<GithubRepo>` | `string` | n/a | yes |
| repo_dest | Name of newly created GitHub repo | `string` | n/a | yes |
| repo_desc | Description of newly created GitHub repo | `string` | n/a | yes |
| repo_dir | Location to save repo on local system | `string` | n/a | yes |
| repo_org | GitHub organization or user name where the repository will be created | `string` | n/a | yes |
| repo_branch | Source repository branch to use | `string` | `"master"` | no |
| sub_dir | Subdirectory containing desired repo content | `string` | `false` | no |
| module | Is this a Terraform module? If so, set to true | `string` | `false` | no |
| github_is_private | Whether the GitHub repository should be private | `bool` | `false` | no |
| enforce_prs | Whether to enforce pull request reviews before merging | `bool` | `true` | no |
| pull_request_bypassers | List of GitHub usernames that can bypass pull request requirements | `list(string)` | `[]` | no |
| use_ssh_source | Whether to use SSH URLs for source repository Git operations | `bool` | `true` | no |
| use_ssh_destination | Whether to use SSH URLs for destination repository Git operations | `bool` | `true` | no |

This module supports many additional GitHub repository configuration options. See `variables.tf` for a complete list of supported variables.

## Outputs

| Name | Description |
|------|-------------|
| ssh_clone_url | SSH clone URL of the created repository |
| http_clone_url | HTTP clone URL of the created repository |
| repo_name | Full name of the created repository |
| repo_setup_result | Result of the repository setup operation |

## Examples

See the [examples directory](./examples) for complete examples:

1. **[Split All Submodules](./examples/split_monolith.tf)**: Split all submodules from a monolithic repository into separate repositories
2. **[Split Single Module](./examples/split_single_module.tf)**: Extract just one module into its own repository
3. **[Custom Module Settings](./examples/module_with_custom_settings.tf)**: Create a module repository with extensive custom GitHub settings

## How It Works

1. Clones the source repository
2. Extracts the specified subdirectory
3. Initializes a new Git repository with the extracted content
4. Creates a new GitHub repository with the specified settings
5. Pushes the content to the new repository
6. Optionally creates a v1.0.0 release tag

## License

This project is licensed under the terms of the MIT license.