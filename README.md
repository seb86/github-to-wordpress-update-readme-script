# Github to WordPress.org Update readme.txt Script
Sometimes you just want to update the readme.txt file so that you are up to date with the latest release of WordPress or you want to correct some spelling or change a link instead of a full plugin release. This allows you to do that.

This script is dummy proof. No need to configure anything. Just run the script and follow the instructions as you go along.

## What does the script do?
This script will pull down your remote GIT and the SVN you want to update, copy the readme.txt file and commit it to WordPress.org.

Before or that it asks a few questions to setup the process of the script such as the ROOT Path of the plugin your GitHub username, repository slug and so on.

To use it you must:

1. Host your code on GitHub
2. Already have a WordPress.org SVN repository setup for your plugin.
3. Have both GIT and SVN setup on your machine and available from the command line.

## Getting started

All you have to do is download the script readme.sh from this repository and place it in a location of your choosing.

## Usage

1. Open up terminal and cd to the directory containing the script.
2. Run: ```sh readme.sh```
3. Follow the prompts.

## Final notes

- This will checkout the remote version of your readme.txt from your Github Repo.
- I have tested this on Mac only.
- Use at your own risk of course :)
