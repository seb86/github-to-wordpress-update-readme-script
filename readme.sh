#!/bin/sh

clear

# ASK INFO
echo "---------------------------------------------------------------------"
echo "                  WordPress.org readme.txt Updater                   "
echo "---------------------------------------------------------------------"
read -p "Enter the ROOT PATH of the plugin you want to update: " ROOT_PATH

if [[ -d $ROOT_PATH ]]; then
	echo "---------------------------------------------------------------------"
	echo "New ROOT PATH has been set."
	cd $ROOT_PATH
elif [[ -f $ROOT_PATH ]]; then
	echo "---------------------------------------------------------------------"
	read -p "$ROOT_PATH is a file. Please enter a ROOT PATH: " ROOT_PATH
fi

echo "---------------------------------------------------------------------"
read -p "Version of Plugin to Update readme.txt file: " VERSION

if [[ -z ${VERSION} ]]; then
	echo "---------------------------------------------------------------------"
	read -p "No version was entered. Please enter a version tag: " VERSION
	clear
fi

# If a version still was not entered then exit the script.
if [[ -z ${VERSION} ]]; then
	echo "Program failed!"; exit 1;
fi;

echo "---------------------------------------------------------------------"
read -p "Enter the WordPress plugin slug: " SVN_REPO_SLUG
clear

if [[ -z ${SVN_REPO_SLUG} ]]; then
	echo "---------------------------------------------------------------------"
	read -p "No plugin slug entered. Please enter the plugin slug given: " SVN_REPO_SLUG
	clear
fi

# If a plugin slug still was not entered then exit the script.
if [[ -z ${SVN_REPO_SLUG} ]]; then
	echo "---------------------------------------------------------------------"
	echo "Program failed!";
	echo "---------------------------------------------------------------------"
	exit 1;
fi;

SVN_REPO_URL="https://plugins.svn.wordpress.org"

# Set WordPress.org Plugin URL
if [[ ${VERSION} = "trunk" ]]; then
	echo "---------------------------------------------------------------------"
	echo "Please Note: You are updating the development version of the plugin."

	SVN_REPO=$SVN_REPO_URL"/"$SVN_REPO_SLUG"/trunk/"
else
	SVN_REPO=$SVN_REPO_URL"/"$SVN_REPO_SLUG"/tags/"$VERSION"/"
fi;

# Set temporary SVN folder for WordPress.
TEMP_SVN_REPO=${SVN_REPO_SLUG}"-svn"

# Delete old SVN cache just incase it was not cleaned before after the last release.
rm -Rf $ROOT_PATH$TEMP_SVN_REPO

# CHECKOUT SVN DIR IF NOT EXISTS
if [[ ! -d $TEMP_SVN_REPO ]]; then
	echo "---------------------------------------------------------------------"
	echo "Checking out WordPress.org plugin repository."
	echo "---------------------------------------------------------------------"

	svn checkout $SVN_REPO $TEMP_SVN_REPO || { echo "Unable to checkout repo."; exit 1; }
fi

echo "---------------------------------------------------------------------"
read -p "Enter your GitHub username: " GITHUB_USER
echo "---------------------------------------------------------------------"
read -p "Now enter the repository slug: " GITHUB_REPO_NAME
clear

# Set temporary folder for GitHub.
TEMP_GITHUB_REPO=${GITHUB_REPO_NAME}"-git"

# Delete old GitHub cache just incase it was not cleaned before after the last release.
rm -Rf $ROOT_PATH$TEMP_GITHUB_REPO

echo "---------------------------------------------------------------------"
echo "Is the line secure?"
echo "---------------------------------------------------------------------"
echo " - y for SSH"
echo " - n for HTTPS"
read -p "" SECURE_LINE

# Set GitHub Repository URL
if [[ ${SECURE_LINE} = "y" ]]; then
	GIT_REPO="git@github.com:"${GITHUB_USER}"/"${GITHUB_REPO_NAME}".git"
else
	GIT_REPO="https://github.com/"${GITHUB_USER}"/"${GITHUB_REPO_NAME}".git"
fi;

clear

# Clone Git repository
echo "---------------------------------------------------------------------"
echo "Cloning GIT repository from GitHub"
echo "---------------------------------------------------------------------"
git clone --progress $GIT_REPO $TEMP_GITHUB_REPO || { echo "Unable to clone repo."; exit 1; }

# Move into the temporary GitHub folder
cd $ROOT_PATH$TEMP_GITHUB_REPO

clear

# Which Remote?
echo "---------------------------------------------------------------------"
read -p "Which remote are we fetching? Default is 'origin'" ORIGIN
echo "---------------------------------------------------------------------"

# IF REMOTE WAS LEFT EMPTY THEN FETCH ORIGIN BY DEFAULT
if [[ -z ${ORIGIN} ]]; then
	git fetch origin

	# Set ORIGIN as origin if left blank
	ORIGIN=origin
else
	git fetch ${ORIGIN}
fi;

clear

# List Branches
echo "---------------------------------------------------------------------"
git branch -r || { echo "Unable to list branches."; exit 1; }
echo "---------------------------------------------------------------------"
read -p "Which branch contains the updated readme.txt file? /" BRANCH

# Switch Branch
echo "---------------------------------------------------------------------"
echo "Switching to branch "${BRANCH}

# IF BRANCH WAS LEFT EMPTY THEN FETCH "master" BY DEFAULT
if [[ -z ${BRANCH} ]]; then
	BRANCH=master
else
	git checkout ${BRANCH} || { echo "Unable to checkout branch."; exit 1; }
fi;

echo "---------------------------------------------------------------------"
read -p "Press [ENTER] to remove unwanted files before release."

# Remove unwanted files and folders
echo "---------------------------------------------------------------------"
echo "Removing unwanted files..."
rm -Rf .git
rm -Rf .github
rm -Rf .wordpress-org
rm -Rf tests
rm -Rf assets
rm -Rf apigen
rm -Rf includes
rm -Rf languages
rm -Rf template
rm -Rf node_modules
rm -Rf src
rm -Rf wp-update-php
rm -Rf .idea/*
rm -f .babelrc
rm -f .editorconfig
rm -f .eslintignore
rm -f .eslintrc.json
rm -f .gitattributes
rm -f .gitignore
rm -f .gitmodules
rm -f .idea
rm -f .jscrsrc
rm -f .jshintrc
rm -f .editorconfig
rm -f apigen.neon
rm -f *.lock
rm -f *.dist
rm -f *.gif
rm -f *.jpg
rm -f *.json
rm -f *.js
rm -f *.md
rm -f *.neon
rm -f *.png
rm -f *.php
rm -f *.rb
rm -f *.sh
rm -f *.xml
rm -f *.yml

# Move into the SVN temporary folder
cd "../"$TEMP_SVN_REPO

# Update SVN
echo "---------------------------------------------------------------------"
echo "Updating SVN"
svn update || { echo "Unable to update SVN."; exit 1; }

# Copy GitHub readme.txt file to SVN temporary folder.
cp -R "../"${TEMP_GITHUB_REPO}"/readme.txt" "../"${TEMP_SVN_REPO}"/readme.txt"

# Add the readme.txt file.
svn add --force "readme.txt"

# SVN Commit
clear
echo "---------------------------------------------------------------------"
echo "SVN Status."
svn status --show-updates

# Deploy Update
echo "---------------------------------------------------------------------"
echo "Committing readme.txt file to WordPress.org..."
echo "---------------------------------------------------------------------"
svn commit -m "Updated readme.txt file for version "${VERSION}"" || {
	echo "Unable to commit. Loading last log.";
	echo "---------------------------------------------------------------------"
	svn log -l 1
	exit 1;
}

read -p "readme.txt file was updated. Press [ENTER] to clean up."
clear

# Remove the temporary directories
echo "---------------------------------------------------------------------"
echo "Cleaning Up..."
echo "---------------------------------------------------------------------"
cd "../"
rm -Rf $ROOT_PATH$TEMP_GITHUB_REPO
rm -Rf $ROOT_PATH$TEMP_SVN_REPO

# Done
echo "Update Done!"
echo "---------------------------------------------------------------------"
read -p "Press [ENTER] to close program."

clear
