#!/usr/bin/env python3
"""
Script to set up a GitHub repository from a source repository.
This script clones a source repository, extracts a subdirectory if specified,
and pushes the content to a new GitHub repository.

Modified to read parameters from a file instead of stdin.
"""

import os
import sys
import json
import shutil
import tempfile
import subprocess
import argparse

def run_command(command, cwd=None):
    """Run a shell command and print its output."""
    print(f"Running: {command}", file=sys.stderr)
    try:
        result = subprocess.run(
            command,
            cwd=cwd,
            shell=True,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        if result.stdout:
            print(result.stdout, file=sys.stderr)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {command}", file=sys.stderr)
        print(f"Error message: {e.stderr}", file=sys.stderr)
        return False

def setup_repository(query):
    """Set up a GitHub repository from parameters in the query."""
    repo_dir = query.get('repo_dir')
    src_clone_url = query.get('src_clone_url')
    dest_clone_url = query.get('dest_clone_url')
    repo_branch = query.get('repo_branch')
    sub_dir = query.get('sub_dir', 'false')
    default_branch = query.get('default_branch', 'main')
    use_ssh_source = query.get('use_ssh_source', 'true').lower() == 'true'
    use_ssh_destination = query.get('use_ssh_destination', 'true').lower() == 'true'
    
    # Validate required variables
    required_vars = ['repo_dir', 'src_clone_url', 'dest_clone_url', 'repo_branch']
    missing_vars = [var for var in required_vars if not query.get(var)]
    
    if missing_vars:
        error_msg = f"Missing required parameters: {', '.join(missing_vars)}"
        print(error_msg, file=sys.stderr)
        return {
            "success": "false",
            "error": error_msg
        }
    
    # Log which protocol is being used for each repository
    src_protocol = "SSH" if use_ssh_source else "HTTPS"
    dest_protocol = "SSH" if use_ssh_destination else "HTTPS"
    print(f"Using {src_protocol} protocol for source repository", file=sys.stderr)
    print(f"Using {dest_protocol} protocol for destination repository", file=sys.stderr)
    
    # Clean up existing directory if it exists
    if os.path.exists(repo_dir):
        print(f"Removing existing directory: {repo_dir}", file=sys.stderr)
        shutil.rmtree(repo_dir)
    
    # Clone source repository
    print(f"Cloning source repository from {src_clone_url}...", file=sys.stderr)
    if not run_command(f"git clone {src_clone_url} {repo_dir}"):
        return {
            "success": "false",
            "error": "Failed to clone source repository"
        }
    
    # Switch to the desired branch
    print(f"Checking out branch {repo_branch}...", file=sys.stderr)
    if not run_command(f"git checkout {repo_branch}", cwd=repo_dir):
        return {
            "success": "false",
            "error": f"Failed to checkout branch: {repo_branch}"
        }
    
    # If subdirectory is specified, extract content from that directory
    sub_dir_path = os.path.join(repo_dir, sub_dir)
    if sub_dir != "false" and os.path.isdir(sub_dir_path):
        print(f"Processing subdirectory: {sub_dir}", file=sys.stderr)
        
        try:
            # Create a temporary directory to store contents of subdirectory
            temp_dir = tempfile.mkdtemp()
            
            # Copy subdirectory contents to temp directory
            for item in os.listdir(sub_dir_path):
                source = os.path.join(sub_dir_path, item)
                destination = os.path.join(temp_dir, item)
                if os.path.isdir(source):
                    shutil.copytree(source, destination)
                else:
                    shutil.copy2(source, destination)
            
            # Remove all files in repo directory except .git
            for item in os.listdir(repo_dir):
                if item != ".git":
                    item_path = os.path.join(repo_dir, item)
                    if os.path.isdir(item_path):
                        shutil.rmtree(item_path)
                    else:
                        os.unlink(item_path)
            
            # Copy temp contents to repo directory
            for item in os.listdir(temp_dir):
                source = os.path.join(temp_dir, item)
                destination = os.path.join(repo_dir, item)
                if os.path.isdir(source):
                    shutil.copytree(source, destination)
                else:
                    shutil.copy2(source, destination)
            
            # Clean up temp directory
            shutil.rmtree(temp_dir)
        except Exception as e:
            return {
                "success": "false",
                "error": f"Failed to process subdirectory: {str(e)}"
            }
    
    # Remove Git history
    git_dir = os.path.join(repo_dir, ".git")
    if os.path.exists(git_dir):
        shutil.rmtree(git_dir)
    
    # Initialize new repository
    print("Initializing new Git repository...", file=sys.stderr)
    if not run_command("git init", cwd=repo_dir):
        return {
            "success": "false",
            "error": "Failed to initialize new repository"
        }
    
    if not run_command("git config core.autocrlf false", cwd=repo_dir):
        return {
            "success": "false",
            "error": "Failed to configure Git"
        }
    
    # Configure remote
    print(f"Configuring remote origin to {dest_clone_url}...", file=sys.stderr)
    if not run_command(f"git remote add origin {dest_clone_url}", cwd=repo_dir):
        return {
            "success": "false",
            "error": "Failed to add remote"
        }
    
    # Add all files
    if not run_command("git add .", cwd=repo_dir):
        return {
            "success": "false",
            "error": "Failed to add files to Git"
        }
    
    # Commit changes
    print("Committing files...", file=sys.stderr)
    if not run_command('git commit -m "Initial commit from source repository"', cwd=repo_dir):
        return {
            "success": "false",
            "error": "Failed to commit files"
        }
    
    # Push to the default branch
    print(f"Pushing to default branch: {default_branch}...", file=sys.stderr)
    if not run_command(f"git branch -M {default_branch}", cwd=repo_dir):
        return {
            "success": "false",
            "error": f"Failed to create branch: {default_branch}"
        }

    # Attempt to pull remote changes before pushing
    print("Pulling remote changes to avoid conflicts...", file=sys.stderr)
    if not run_command(f"git pull origin {default_branch} --rebase", cwd=repo_dir):
        return {
            "success": "false",
            "error": f"Failed to pull remote changes for branch: {default_branch}"
        }

    # Push changes to the remote repository
    if not run_command(f"git push -u origin {default_branch}", cwd=repo_dir):
        return {
            "success": "false",
            "error": f"Failed to push to remote branch: {default_branch}"
        }

    print("Repository setup completed successfully!", file=sys.stderr)
    return {
        "success": "true",
        "repo_dir": repo_dir,
        "default_branch": default_branch,
        "message": "Repository setup completed successfully!"
    }

def main():
    # Set up command line argument parsing
    parser = argparse.ArgumentParser(description='Set up a GitHub repository from a source repository.')
    parser.add_argument('--params-file', required=True, help='Path to the JSON file containing parameters')
    args = parser.parse_args()
    
    # Read parameters from file
    try:
        with open(args.params_file, 'r') as f:
            input_data = json.load(f)
    except (json.JSONDecodeError, FileNotFoundError) as e:
        sys.stderr.write(f"Error: Failed to read parameters file: {str(e)}\n")
        json.dump({"success": False, "error": f"Failed to read parameters file: {str(e)}"}, sys.stdout)
        sys.exit(1)
    
    # Process the repository setup
    result = setup_repository(input_data)
    
    # Write the result as JSON to stdout
    json.dump(result, sys.stdout)
    
    # Also write the result to a result file next to the params file
    result_file = args.params_file.replace('_params.json', '_result.json')
    try:
        with open(result_file, 'w') as f:
            json.dump(result, f, indent=2)
        print(f"Results written to: {result_file}", file=sys.stderr)
    except Exception as e:
        print(f"Warning: Unable to write results to file: {str(e)}", file=sys.stderr)

if __name__ == "__main__":
    main()