#!/bin/sh

set -e
clear

# ASK INFO
echo "---------------------------------------------------------------------"
echo "                  WordPress.org readme.txt Updater                   "
echo "---------------------------------------------------------------------"
read -p "Enter the ROOT PATH of the plugin you want to update: " ROOT_PATH
echo "---------------------------------------------------------------------"
read -p "Version of Plugin to Update readme.txt file: " VERSION
echo "---------------------------------------------------------------------"
clear

read -p "Enter the WordPress plugin slug: " SVN_REPO_SLUG
clear

SVN_REPO_URL="https://plugins.svn.wordpress.org"

# Set WordPress.org Plugin URL
SVN_REPO=$SVN_REPO_URL"/"$SVN_REPO_SLUG"/"$VERSION"/"

# Set temporary SVN folder for WordPress.
TEMP_SVN_REPO=${SVN_REPO_SLUG}"-svn"

# Delete old SVN cache just incase it was not cleaned before after the last release.
rm -Rf $ROOT_PATH$TEMP_SVN_REPO

# CHECKOUT SVN DIR IF NOT EXISTS
if [[ ! -d $TEMP_SVN_REPO ]];
then
	echo "Checking out WordPress.org plugin repository."
	svn checkout $SVN_REPO $TEMP_SVN_REPO || { echo "Unable to checkout repo."; exit 1; }
fi

read -p "Enter your GitHub username: " GITHUB_USER
clear

read -p "Now enter the repository slug: " GITHUB_REPO_NAME
clear

# Set temporary folder for GitHub.
TEMP_GITHUB_REPO=${GITHUB_REPO_NAME}"-git"

# Delete old GitHub cache just incase it was not cleaned before after the last release.
rm -Rf $ROOT_PATH$TEMP_GITHUB_REPO

# Set GitHub Repository URL
GIT_REPO="https://github.com/"${GITHUB_USER}"/"${GITHUB_REPO_NAME}".git"

# Clone Git repository
echo "Cloning GIT repository from GitHub"
git clone --progress $GIT_REPO $TEMP_GITHUB_REPO || { echo "Unable to clone repo."; exit 1; }

# Move into the temporary GitHub folder
cd $ROOT_PATH$TEMP_GITHUB_REPO

# List Branches
clear
git fetch origin
echo "Which branch contains the updated readme.txt file?"
git branch -r || { echo "Unable to list branches."; exit 1; }
echo ""
read -p "origin/" BRANCH

# Switch Branch
echo "Switching to branch"
git checkout ${BRANCH} || { echo "Unable to checkout branch."; exit 1; }

# Remove unwanted files and folders
echo "Removing unwanted files"
rm -Rf .git
rm -Rf .github
rm -Rf tests
rm -Rf apigen
rm -f .gitattributes
rm -f .gitignore
rm -f .gitmodules
rm -f .jscrsrc
rm -f .jshintrc
rm -f phpunit.xml.dist
rm -f .editorconfig
rm -f *.js
rm -f *.json
rm -f *.xml
rm -f *.md
rm -f *.yml
rm -f *.neon
rm -f *.png
rm -f *.jpg
rm -f *.sh
rm -f *.php

# Move into the SVN temporary folder
cd "../"$TEMP_SVN_REPO

# Update SVN
echo "Updating SVN"
svn update || { echo "Unable to update SVN."; exit 1; }

# Copy GitHub readme.txt file to SVN temporary folder.
cp -R "../"${TEMP_GITHUB_REPO}"/readme.txt" "../"${TEMP_SVN_REPO}"/readme.txt"

# Add the readme.txt file.
svn add --force "readme.txt"

# SVN Commit
clear
echo "Showing SVN status."
svn status --show-updates

# Deploy Update
echo ""
echo "Committing readme.txt file to WordPress.org..."
svn commit -m "Updated readme.txt file for version "${VERSION}"" || {
	echo "Unable to commit. Loading last log.";
	svn log -l 1
	exit 1;
}

read -p "readme.txt file was updated. Press [ENTER] to clean up."
clear

# Remove the temporary directories
echo "Cleaning Up..."
cd "../"
rm -Rf $ROOT_PATH$TEMP_GITHUB_REPO
rm -Rf $ROOT_PATH$TEMP_SVN_REPO

# Done
echo "Update Done."
echo ""
read -p "Press [ENTER] to close program."

clear
