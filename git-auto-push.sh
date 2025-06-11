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
      git commit -m "Auto backup: $(date) in $(basename "$REPO")"
      git push origin main
    fi
  fi
done