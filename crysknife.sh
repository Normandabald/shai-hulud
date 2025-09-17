#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <organization-name>"
  echo "Example: $0 bene-gesserit"
  exit 1
fi

ORG_NAME="$1"

echo "=========================================="
echo "  Shai-Hulud Branch Report"
echo "  Organization: $ORG_NAME"
echo "  Generated on: $(date)"
echo "=========================================="
echo ""

total_repos=0
repos_with_branch=0
repos_without_branch=0

# Create temporary files for storing results
temp_with_branch=$(mktemp)
temp_without_branch=$(mktemp)
temp_shai_hulud_repos=$(mktemp)
temp_workflow_files=$(mktemp)

echo "Scanning $ORG_NAME repositories..."
echo ""

# Get all repos and check for shai-hulud branch
gh repo list "$ORG_NAME" --limit 1000 --json nameWithOwner,name --jq '.[]' | while read -r repo_json; do
  repo=$(echo "$repo_json" | jq -r '.nameWithOwner')
  repo_name=$(echo "$repo_json" | jq -r '.name')
  
  total_repos=$((total_repos + 1))
  
  # Check if repository name contains 'shai-hulud' (case insensitive)
  if [[ $(echo "$repo_name" | tr '[:upper:]' '[:lower:]') == *"shai-hulud"* ]]; then
    echo ":worm: $repo" >> "$temp_shai_hulud_repos"
  fi
  
  # Check for shai-hulud-workflow.yml file
  workflow_response=$(gh api "repos/$repo/contents/.github/workflows" 2>/dev/null)
  if [ $? -eq 0 ] && [ -n "$workflow_response" ]; then
    workflow_file_exists=$(echo "$workflow_response" | jq -r '.[] | select(.name == "shai-hulud-workflow.yml") | .name // empty')
    if [ -n "$workflow_file_exists" ]; then
      echo ":rotating_light: $repo" >> "$temp_workflow_files"
    fi
  fi
  
  # Check if shai-hulud branch exists
  branch_exists=$(gh api "repos/$repo/branches" --jq '.[] | select(.name == "shai-hulud") | .name')
  
  if [ -n "$branch_exists" ]; then
    echo "✓ $repo" >> "$temp_with_branch"
    repos_with_branch=$((repos_with_branch + 1))
  else
    echo "✗ $repo" >> "$temp_without_branch"
    repos_without_branch=$((repos_without_branch + 1))
  fi
done

echo "REPOSITORIES NAMED 'Shai-Hulud':"
echo "================================="
if [ -s "$temp_shai_hulud_repos" ]; then
  cat "$temp_shai_hulud_repos"
else
  echo "No repositories found with 'Shai-Hulud' in the name"
fi

echo ""
echo "REPOSITORIES WITH 'shai-hulud-workflow.yml' FILE:"
echo "=================================================="
if [ -s "$temp_workflow_files" ]; then
  cat "$temp_workflow_files"
else
  echo "No repositories found with 'shai-hulud-workflow.yml' file"
fi

echo ""
echo "REPOSITORIES WITH 'shai-hulud' BRANCH:"
echo "======================================="
if [ -s "$temp_with_branch" ]; then
  cat "$temp_with_branch"
else
  echo "No repositories found with 'shai-hulud' branch"
fi

echo ""
echo "SUMMARY:"
echo "========"
echo "Total repositories scanned: $(wc -l < <(gh repo list "$ORG_NAME" --limit 1000 --json nameWithOwner --jq '.[].nameWithOwner'))"
echo "Repositories named 'Shai-Hulud': $([ -s "$temp_shai_hulud_repos" ] && wc -l < "$temp_shai_hulud_repos" || echo 0)"
echo "Repositories with 'shai-hulud-workflow.yml': $([ -s "$temp_workflow_files" ] && wc -l < "$temp_workflow_files" || echo 0)"
echo "Repositories with 'shai-hulud' branch: $([ -s "$temp_with_branch" ] && wc -l < "$temp_with_branch" || echo 0)"
echo "Repositories without 'shai-hulud' branch: $([ -s "$temp_without_branch" ] && wc -l < "$temp_without_branch" || echo 0)"

rm -f "$temp_with_branch" "$temp_without_branch" "$temp_shai_hulud_repos" "$temp_workflow_files"

echo ""
echo "Report complete."