# GitHub to WordPress.org Update readme.txt Script

A simple script to update the readme.txt file in the trunk or any tagged version from your GitHub repository to your WordPress.org plugin SVN.

## 🔔 Overview

Sometimes you just want to update the readme.txt file so that you are up to date with the latest release of WordPress or you want to correct some spelling or change a link instead of a full plugin release. This allows you to do that.

This script is dummy proof and you do NOT need to configure anything so long as you have setup your GIT and SVN login globally. This is to insure you have write permission. Otherwise you will be asked to login every step of the way a GIT or SVN command runs before it proceeds.

Just run the script and follow the instructions as you go along and your readme.txt file will be up in no time.


### Is This Free?

Yes, it's free. But here's what you should _really_ care about:
* Steps are easy to understand.
* Does everything for you.


## ✔️ Features

* Supports HTTPS and SSH connections.
* Specify your remote when fetching from your repository.


## What does the script do?
This script will pull down your remote GIT and the SVN you want to update, copy the readme.txt file and commit it to WordPress.org.

Before or that it asks a few questions to setup the process of the script such as the ROOT Path of the plugin your GitHub username, repository slug and so on.


## Getting started

All you have to do is download the script readme.sh from this repository and place it in a location of your choosing.


## ✅ Requirements

To use the script you must:

1. Host your code on GitHub.
2. Already have a WordPress.org SVN repository setup for your plugin.
3. Have both GIT and SVN setup on your machine and available from the command line.


## Usage

1. Open up terminal and cd to the directory containing the script.
2. Run: ```sh readme.sh```
3. Follow the prompts.

> If you wish to update the development repository of the plugin on WordPress.org simply enter the word `trunk` when it asks for the version of the plugin you want to update.


## ⭐ Feedback

GitHub to WordPress.org Update readme.txt Script is released freely and openly. Feedback or ideas and approaches to solving limitations in GitHub to WordPress.org Update readme.txt Script is greatly appreciated.


#### 📝 Reporting Issues

If you think you have found a bug in the script, please [open a new issue](https://github.com/seb86/github-to-wordpress-update-readme-script/issues/new) and I will do my best to help you out.


## Contribute

If you or your company use GitHub to WordPress.org Update readme.txt Script or appreciate the work I’m doing in open source, please consider supporting me directly so I can continue maintaining it and keep evolving the project. It's pretty clear that software actually costs something, and even though it may be offered freely, somebody is paying the cost.

You'll be helping to ensure I can spend the time not just fixing bugs, adding features, releasing new versions, but also keeping the project afloat. Any contribution you make is a big help and is greatly appreciated.

Please also consider starring ✨ and sharing 👍 the repo! This helps the project getting known and grow with the community. 🙏

If you want to do a one-time donation, you can donate to:
- [My PayPal](https://www.paypal.me/codebreaker)
- [BuyMeACoffee.com](https://www.buymeacoffee.com/sebastien)

Thank you for your support! 🙌


## Final Notes

- This will checkout the remote version of your GitHub repository.
- Use at your own risk of course 😄
