# Git Backup Script

This script automatically iterates through a list of specified local Git repositories. If it finds any changes, it creates a backup commit backup commit using the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format and pushes it to the `origin main` branch. The script is designed to be "silent on success" and will only create a log file if an error occurs.

## Setup

1.  **Save the Script**: Save the code to a file, for example, `git-backup.sh`.

2.  **Configure Repositories**: Open `git-backup.sh` and edit the `REPOS` array to include the absolute paths to the Git repositories you want to back up.

    ```bash
    REPOS=(
      "/path/to/your/repo1"
      "/path/to/your/repo2"
    )
    ```

## How to Use

### 1. Make the script executable

Give the script execute permissions.

```sh
chmod +x git-backup.sh
```

### 2. Run manually

You can now run the backup process at any time by executing the script from your terminal:

```sh
./git-backup.sh
```

## Automation

To run this script automatically at a timed interval, you can use `cron`.

### 1. Open your crontab file

```sh
crontab -e
```

### 2. Customize the timing and add `git-backup.sh` to a new line

Example (the script will run daily at 4:00am):

```cron
0 4 * * * /path/to/your/git-backup.sh
```

### 3. Save and close the editor

The script will now run automatically at the scheduled time. Because the script only logs on failure, you do not need to redirect the output to a log file with `>> /path/to/log 2>&1` unless you also want to capture output from cron itself.
