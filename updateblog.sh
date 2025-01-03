#!/bin/bash
set -euo pipefail

# Change to the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
# This script assumes you have a Python script called imgproc.py in the same directory

# Set variables for Obsidian to Hugo copy
sourcePath="/Path/To/Obsidian/Posts/"
destinationPath="/Path/to/HUGO/Project/posts/"

# Set GitHub Repo
myrepo="gitrepo"

# Set Hugo project directory
HUGO_DIR="/Path/to/HUGO/Project/"

# Varbiables for Web Server Publishing
# Assumes you have a VPS with SSH access and rsync installed
# Other means of publiushing to a web server require different commands
vps="hostname"
vpsUser="username"
vpsPath="/var/www/html/"
#Change the sshPort if you are using a different port for ssh
sshPort="22"
websitePath="/Path/to/HUGO/Project/public/"

# Check for required commands
for cmd in git rsync python3 hugo; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd is not installed or not in PATH."
        exit 1
    fi
done

# Step 1: Sync posts from Obsidian to Hugo content folder using rsync
echo "Syncing posts from Obsidian..."

if [ ! -d "$sourcePath" ]; then
    echo "Source path does not exist: $sourcePath"
    exit 1
fi

if [ ! -d "$destinationPath" ]; then
    echo "Destination path does not exist: $destinationPath"
    exit 1
fi
# Sync posts from Obsidian to Hugo content folder
# The -u flag skips files that are newer in the destination folder.
# this is useful for updating posts in Hugo that have been edited in Obsidian.
# I do not use the --delete flag to avoid deleting posts in Hugo that are not in Obsidian.
# This way, I can add posts by other means if I want to
# The --exclude flag is used to exclude the Drafts folder in Obsidian from syncing
# If you don't have a Drafts folder, you can remove the --exclude flag
#if ! rsync -avu "$sourcePath" "$destinationPath"; then
if ! rsync -avu --exclude 'Drafts' "$sourcePath" "$destinationPath"; then
    echo "Failed to sync posts from Obsidian."
    exit 1
fi

echo "Posts synced from Obsidian to Hugo content folder."

# Step 2: Process Markdown files with Python script to handle image links
echo "Processing image links in Markdown files..."
if [ ! -f "imgproc.py" ]; then
    echo "Python script imgproc.py not found."
    exit 1
fi

if ! python3 imgproc.py; then
    echo "Failed to process image links."
    exit 1
fi
echo "Blog post image links processed."

# Step 3: Build the Hugo site
# Change to the Hugo project directory for these steps
cd $HUGO_DIR || error_exit "Failed to change to Hugo project directory: $HUGO_DIR"
echo "Building the Hugo site..."
if ! hugo; then
    echo "Hugo build failed."
    exit 1
fi

echo "Hugo site build successful."

# Step 4: Add changes to Git
echo "Staging changes for Git..."
if git diff --quiet && git diff --cached --quiet; then
    echo "No changes to stage."
else
    git add .
fi
echo "Changes staged."

# Step 5: Commit changes
commit_message="New Auto Blog Post(s) on $(date +'%Y-%m-%d %H:%M:%S')"
if git diff --cached --quiet; then
    echo "No changes to commit."
else
    echo "Committing changes..."
    git commit -m "$commit_message"
fi
echo "Changes committed."

# Step 6: Push all changes to the main branch
echo "Deploying to GitHub Main..."
if ! git push origin main; then
    echo "Failed to push to main branch."
    exit 1
fi

echo "Changed pushed to Github successfully."

# Step 7: Publish to VPS Web Server
echo "Deploying to VPS Web Server..."
if ! rsync -avz -e "ssh -p $sshPort" --delete "$websitePath" "$vpsUser@$vps:$vpsPath"; then
    echo "Failed to deploy to VPS Web Server."
    exit 1
fi  

echo "Done. New Blog Post(s) published."