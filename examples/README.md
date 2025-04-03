# Examples: Splitting a Terraform Repository by Submodule

This directory contains examples of how to use the `terraform-github-repo-subdir` module to split a monolithic Terraform repository into smaller, focused repositories organized around individual submodules.

## Use Cases

These examples demonstrate how to:

1. Create a new GitHub repository from a subdirectory of an existing repository
2. Maintain the Git history of the specific subdirectory
3. Configure different protocols (SSH/HTTPS) for source and destination repositories
4. Customize GitHub repository settings for each new repository

## Examples

- `split_monolith.tf`: Shows how to split all submodules from a monolithic repository into separate repositories
- `split_single_module.tf`: Shows how to split just one submodule into its own repository
- `module_with_custom_settings.tf`: Shows how to create a new module repository with custom GitHub settings

## Usage

To use these examples:

1. Copy one of the example files to your working directory
2. Modify the parameters as needed for your use case
3. Run `terraform init` and `terraform apply`

Each example includes comments explaining the parameters and their purpose.