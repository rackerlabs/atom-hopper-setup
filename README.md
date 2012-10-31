atom-hopper-setup
=================

setup scripts for installing atom hopper on a server for automated testing


General workflow for this repo:

The 'master' branch is release-ready.
The 'develop' branch contains active development. Whenever a new release is to be cut, this branch will be merged into master.
A feature branch contains all of the changes pertaining to a particular new feature. It will be merged into 'develop' when done.

A. If you have push access to the repo:
  1. git clone the repo, if you haven't already
  2. create a feature branch starting from the 'develop' branch. call the new branch something like "username-description-of-feature"
  3. make all of your commits to the feature branch.
  4. when all changes are finished, run "git push origin username-description-of-feature". This will upload your branch to the main repo.
  5. issue a pull request for your feature branch to be merged into the 'develop' branch.

B. If you don't have push access to the repo:
  1. if you haven't done so already, fork the repo and then git clone your fork
  2. create a feature branch from 'develop'
  3. make changes to that feature branch
  4. push the feature branch to your fork
  5. issue a pull request for the feature branch in your fork to be merged into the 'develop' branch of the main repo.
