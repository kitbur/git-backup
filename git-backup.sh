#!/bin/bash

set -e 
set -o pipefail

# ----------- CONFIGURATION ------------

# Absolute path to log
FAILURE_LOG="$HOME/logs/git-backup.log"

# Absolute paths to your git repositories
REPOS=(
  "/path/to/repo1"
  "/path/to/repo2"
)

# -------------- LOG FILE --------------

TMP_LOG=$(mktemp) || exit 1

cleanup() {
  EXIT_CODE=$?
  if [ "$EXIT_CODE" -ne 0 ]; then
    (
      echo "--- SCRIPT FAILED at $(date) with exit code $EXIT_CODE ---"
      cat "$TMP_LOG"
    ) > "$FAILURE_LOG"
  fi
  rm -f "$TMP_LOG"
}

trap cleanup EXIT
exec > "$TMP_LOG" 2>&1

# --------------- SCRIPT ---------------

echo "--- Starting repository check ---"

for REPO in "${REPOS[@]}"; do
  echo "----------------------------------------"
  echo "Checking repository: $REPO"
  
  if [ ! -d "$REPO" ]; then
    echo "Warning: Directory not found. Skipping."
    continue
  fi

  cd "$REPO" || continue
  
  if [ ! -d ".git" ]; then
    echo "Warning: Not a git repository. Skipping."
    continue
  fi
  
  if [ -z "$(git status --porcelain)" ]; then
    echo "No changes detected. Nothing to commit."
  else
    echo "Changes detected. Preparing commit."
    
    git add .
    
    COMMIT_SUBJECT="chore: Automated backup"
    COMMIT_BODY=$(git status --porcelain)
    
    echo "Committing changes..."
    echo "Changed files:"
    echo "$COMMIT_BODY"

    git commit -m "${COMMIT_SUBJECT}" -m "${COMMIT_BODY}"
    
    echo "Commit successful. Pushing to origin..."
    git push origin main
    echo "Push complete."
  fi
done

echo "----------------------------------------"
echo "--- Script finished ---"