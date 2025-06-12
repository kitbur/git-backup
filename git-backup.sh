#!/bin/bash

# Repository list
REPOS=(
  "/path/to/repo1"
  "/path/to/repo2"
)

for REPO in "${REPOS[@]}"; do
  cd "$REPO" || continue
  
  # Check if it's a git repo
  if [ -d ".git" ]; then
    # Check for changes
    if [ -n "$(git status --porcelain)" ]; then
      git add .
      COMMIT_BODY=$(git status --porcelain)
      git commit -m "chore: Automated backup" -m "${COMMIT_BODY}"
      git push origin main
    fi
  fi
done