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

[![Terraform Validation](https://github.com/HappyPathway/terraform-github-repo-subdir/actions/workflows/terraform.yaml/badge.svg)](https://github.com/HappyPathway/terraform-github-repo-subdir/actions/workflows/terraform.yaml)


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.4 |
| <a name="provider_github"></a> [github](#provider\_github) | 6.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_repo"></a> [repo](#module\_repo) | HappyPathway/repo/github | n/a |

## Resources

| Name | Type |
|------|------|
| [github_release.initial_release](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/release) | resource |
| [external_external.repo_setup](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [github_repository.repo_src](https://registry.terraform.io/providers/hashicorp/github/latest/docs/data-sources/repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_codeowners"></a> [additional\_codeowners](#input\_additional\_codeowners) | Additional entries for CODEOWNERS file | `list(string)` | `[]` | no |
| <a name="input_admin_teams"></a> [admin\_teams](#input\_admin\_teams) | Teams to grant admin access | `list(string)` | `[]` | no |
| <a name="input_allow_unsigned_files"></a> [allow\_unsigned\_files](#input\_allow\_unsigned\_files) | Whether to allow file management even when signed commits are required | `bool` | `false` | no |
| <a name="input_archive_on_destroy"></a> [archive\_on\_destroy](#input\_archive\_on\_destroy) | Archive repository instead of deleting on destroy | `bool` | `true` | no |
| <a name="input_archived"></a> [archived](#input\_archived) | Archive this repository | `bool` | `false` | no |
| <a name="input_collaborators"></a> [collaborators](#input\_collaborators) | Map of collaborators and their permission levels | `map(string)` | `{}` | no |
| <a name="input_commit_author"></a> [commit\_author](#input\_commit\_author) | The author name to use for file commits | `string` | `"Terraform"` | no |
| <a name="input_commit_email"></a> [commit\_email](#input\_commit\_email) | The email to use for file commits | `string` | `"terraform@github.com"` | no |
| <a name="input_create_codeowners"></a> [create\_codeowners](#input\_create\_codeowners) | Create CODEOWNERS file | `bool` | `true` | no |
| <a name="input_create_repo"></a> [create\_repo](#input\_create\_repo) | Whether to create a new repository or manage an existing one | `bool` | `true` | no |
| <a name="input_deploy_keys"></a> [deploy\_keys](#input\_deploy\_keys) | List of SSH deploy keys to add to the repository | <pre>list(object({<br>    title     = string<br>    key       = optional(string, "")<br>    read_only = optional(bool, true)<br>    create    = optional(bool, false)<br>  }))</pre> | `[]` | no |
| <a name="input_enforce_prs"></a> [enforce\_prs](#input\_enforce\_prs) | Whether to enforce pull request reviews before merging | `bool` | `true` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | List of GitHub environments to create for the repository | <pre>list(object({<br>    name = string<br>    reviewers = optional(object({<br>      teams = optional(list(string), [])<br>      users = optional(list(string), [])<br>    }), {})<br>    deployment_branch_policy = optional(object({<br>      protected_branches     = optional(bool, true)<br>      custom_branch_policies = optional(bool, false)<br>    }), {})<br>    secrets = optional(list(object({<br>      name  = string<br>      value = string<br>    })), [])<br>    vars = optional(list(object({<br>      name  = string<br>      value = string<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_extra_files"></a> [extra\_files](#input\_extra\_files) | Additional files to create in the repository | <pre>list(object({<br>    path    = string<br>    content = string<br>  }))</pre> | `[]` | no |
| <a name="input_force_name"></a> [force\_name](#input\_force\_name) | Keep exact repository name (no date suffix) | `bool` | `false` | no |
| <a name="input_github_allow_auto_merge"></a> [github\_allow\_auto\_merge](#input\_github\_allow\_auto\_merge) | Allow pull requests to be automatically merged | `bool` | `false` | no |
| <a name="input_github_allow_merge_commit"></a> [github\_allow\_merge\_commit](#input\_github\_allow\_merge\_commit) | Allow merge commits | `bool` | `false` | no |
| <a name="input_github_allow_rebase_merge"></a> [github\_allow\_rebase\_merge](#input\_github\_allow\_rebase\_merge) | Allow rebase merging | `bool` | `false` | no |
| <a name="input_github_allow_squash_merge"></a> [github\_allow\_squash\_merge](#input\_github\_allow\_squash\_merge) | Allow squash merging | `bool` | `true` | no |
| <a name="input_github_allow_update_branch"></a> [github\_allow\_update\_branch](#input\_github\_allow\_update\_branch) | Allow updating pull request branches | `bool` | `true` | no |
| <a name="input_github_auto_init"></a> [github\_auto\_init](#input\_github\_auto\_init) | Initialize repository with README | `bool` | `true` | no |
| <a name="input_github_codeowners_team"></a> [github\_codeowners\_team](#input\_github\_codeowners\_team) | GitHub team to use for CODEOWNERS file | `string` | `"terraform-reviewers"` | no |
| <a name="input_github_default_branch"></a> [github\_default\_branch](#input\_github\_default\_branch) | Default branch name | `string` | `"main"` | no |
| <a name="input_github_delete_branch_on_merge"></a> [github\_delete\_branch\_on\_merge](#input\_github\_delete\_branch\_on\_merge) | Delete head branch after merge | `bool` | `true` | no |
| <a name="input_github_dismiss_stale_reviews"></a> [github\_dismiss\_stale\_reviews](#input\_github\_dismiss\_stale\_reviews) | Dismiss stale pull request approvals | `bool` | `true` | no |
| <a name="input_github_enforce_admins_branch_protection"></a> [github\_enforce\_admins\_branch\_protection](#input\_github\_enforce\_admins\_branch\_protection) | Enforce branch protection rules on administrators | `bool` | `true` | no |
| <a name="input_github_has_discussions"></a> [github\_has\_discussions](#input\_github\_has\_discussions) | Enable discussions feature | `bool` | `false` | no |
| <a name="input_github_has_downloads"></a> [github\_has\_downloads](#input\_github\_has\_downloads) | Enable downloads feature | `bool` | `false` | no |
| <a name="input_github_has_issues"></a> [github\_has\_issues](#input\_github\_has\_issues) | Enable issues feature | `bool` | `false` | no |
| <a name="input_github_has_projects"></a> [github\_has\_projects](#input\_github\_has\_projects) | Enable projects feature | `bool` | `true` | no |
| <a name="input_github_has_wiki"></a> [github\_has\_wiki](#input\_github\_has\_wiki) | Enable wiki feature | `bool` | `true` | no |
| <a name="input_github_is_private"></a> [github\_is\_private](#input\_github\_is\_private) | Whether the GitHub repository should be private | `bool` | `false` | no |
| <a name="input_github_merge_commit_message"></a> [github\_merge\_commit\_message](#input\_github\_merge\_commit\_message) | Message for merge commits | `string` | `"PR_TITLE"` | no |
| <a name="input_github_merge_commit_title"></a> [github\_merge\_commit\_title](#input\_github\_merge\_commit\_title) | Title for merge commits | `string` | `"MERGE_MESSAGE"` | no |
| <a name="input_github_org_teams"></a> [github\_org\_teams](#input\_github\_org\_teams) | Organization teams configuration | `list(any)` | `null` | no |
| <a name="input_github_pro_enabled"></a> [github\_pro\_enabled](#input\_github\_pro\_enabled) | Is this a Github Pro Account? If not, then it's limited in feature set | `bool` | `false` | no |
| <a name="input_github_push_restrictions"></a> [github\_push\_restrictions](#input\_github\_push\_restrictions) | List of team/user IDs with push access | `list(string)` | `[]` | no |
| <a name="input_github_repo_description"></a> [github\_repo\_description](#input\_github\_repo\_description) | Repository description | `string` | `null` | no |
| <a name="input_github_repo_topics"></a> [github\_repo\_topics](#input\_github\_repo\_topics) | Repository topics | `list(string)` | `[]` | no |
| <a name="input_github_require_code_owner_reviews"></a> [github\_require\_code\_owner\_reviews](#input\_github\_require\_code\_owner\_reviews) | Require code owner review | `bool` | `true` | no |
| <a name="input_github_required_approving_review_count"></a> [github\_required\_approving\_review\_count](#input\_github\_required\_approving\_review\_count) | Number of approvals needed for pull requests | `number` | `1` | no |
| <a name="input_github_squash_merge_commit_message"></a> [github\_squash\_merge\_commit\_message](#input\_github\_squash\_merge\_commit\_message) | Message for squash merge commits | `string` | `"COMMIT_MESSAGES"` | no |
| <a name="input_github_squash_merge_commit_title"></a> [github\_squash\_merge\_commit\_title](#input\_github\_squash\_merge\_commit\_title) | Title for squash merge commits | `string` | `"COMMIT_OR_PR_TITLE"` | no |
| <a name="input_gitignore_template"></a> [gitignore\_template](#input\_gitignore\_template) | Gitignore template to use | `string` | `null` | no |
| <a name="input_homepage_url"></a> [homepage\_url](#input\_homepage\_url) | Repository homepage URL | `string` | `null` | no |
| <a name="input_is_template"></a> [is\_template](#input\_is\_template) | Make this repository a template | `bool` | `false` | no |
| <a name="input_license_template"></a> [license\_template](#input\_license\_template) | License template to use for the repository | `string` | `null` | no |
| <a name="input_managed_extra_files"></a> [managed\_extra\_files](#input\_managed\_extra\_files) | Additional files to manage in the repository | <pre>list(object({<br>    path    = string<br>    content = string<br>  }))</pre> | `[]` | no |
| <a name="input_module"></a> [module](#input\_module) | Is this a Terraform Module? if so, set to true | `string` | `false` | no |
| <a name="input_pages_config"></a> [pages\_config](#input\_pages\_config) | Configuration for GitHub Pages | <pre>object({<br>    branch = optional(string, "gh-pages")<br>    path   = optional(string, "/")<br>    cname  = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix to add to repository name | `string` | `null` | no |
| <a name="input_pull_request_bypassers"></a> [pull\_request\_bypassers](#input\_pull\_request\_bypassers) | List of GitHub usernames that can bypass pull request requirements | `list(string)` | `[]` | no |
| <a name="input_repo_branch"></a> [repo\_branch](#input\_repo\_branch) | n/a | `string` | `"master"` | no |
| <a name="input_repo_desc"></a> [repo\_desc](#input\_repo\_desc) | Description of newly created github repo | `string` | n/a | yes |
| <a name="input_repo_dest"></a> [repo\_dest](#input\_repo\_dest) | Name of newly created github repo | `string` | n/a | yes |
| <a name="input_repo_dir"></a> [repo\_dir](#input\_repo\_dir) | Location to save repo on Local System | `string` | n/a | yes |
| <a name="input_repo_org"></a> [repo\_org](#input\_repo\_org) | GitHub organization or user name where the repository will be created | `string` | n/a | yes |
| <a name="input_repo_src"></a> [repo\_src](#input\_repo\_src) | Name of Source Repo, must be in form <GithubOrg>/<GithubRepo> | `string` | n/a | yes |
| <a name="input_require_last_push_approval"></a> [require\_last\_push\_approval](#input\_require\_last\_push\_approval) | Require approval from the last pusher | `bool` | `false` | no |
| <a name="input_require_signed_commits"></a> [require\_signed\_commits](#input\_require\_signed\_commits) | Whether to require signed commits for the default branch | `bool` | `false` | no |
| <a name="input_required_status_checks"></a> [required\_status\_checks](#input\_required\_status\_checks) | Required status checks for protected branches | <pre>object({<br>    contexts = list(string)<br>    strict   = optional(bool, false)<br>  })</pre> | `null` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | GitHub Actions secrets | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_security_and_analysis"></a> [security\_and\_analysis](#input\_security\_and\_analysis) | Security and analysis settings for the repository | <pre>object({<br>    advanced_security = optional(object({<br>      status = string<br>    }), { status = "disabled" })<br>    secret_scanning = optional(object({<br>      status = string<br>    }), { status = "disabled" })<br>    secret_scanning_push_protection = optional(object({<br>      status = string<br>    }), { status = "disabled" })<br>  })</pre> | `null` | no |
| <a name="input_sub_dir"></a> [sub\_dir](#input\_sub\_dir) | Subdirectory containing desired repo content | `string` | `false` | no |
| <a name="input_template_repo"></a> [template\_repo](#input\_template\_repo) | Template repository name | `string` | `null` | no |
| <a name="input_template_repo_org"></a> [template\_repo\_org](#input\_template\_repo\_org) | Template repository organization | `string` | `null` | no |
| <a name="input_use_ssh"></a> [use\_ssh](#input\_use\_ssh) | Whether to use SSH URLs for Git operations (true) or HTTPS URLs (false) | `bool` | `true` | no |
| <a name="input_use_ssh_destination"></a> [use\_ssh\_destination](#input\_use\_ssh\_destination) | Whether to use SSH URLs for destination repository Git operations (true) or HTTPS URLs (false) | `bool` | `true` | no |
| <a name="input_use_ssh_source"></a> [use\_ssh\_source](#input\_use\_ssh\_source) | Whether to use SSH URLs for source repository Git operations (true) or HTTPS URLs (false) | `bool` | `true` | no |
| <a name="input_vars"></a> [vars](#input\_vars) | GitHub Actions variables | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_vulnerability_alerts"></a> [vulnerability\_alerts](#input\_vulnerability\_alerts) | Enable Dependabot alerts | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_http_clone_url"></a> [http\_clone\_url](#output\_http\_clone\_url) | n/a |
| <a name="output_repo_name"></a> [repo\_name](#output\_repo\_name) | n/a |
| <a name="output_repo_setup_result"></a> [repo\_setup\_result](#output\_repo\_setup\_result) | Result of the repository setup operation |
| <a name="output_ssh_clone_url"></a> [ssh\_clone\_url](#output\_ssh\_clone\_url) | n/a |
<!-- END_TF_DOCS -->