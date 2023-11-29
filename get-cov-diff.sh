#!/bin/bash

# Check if both target branches are provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <target_branch>"
  exit 1
fi
# store current git branch name
current_branch=$(git branch --show-current)

BASEDIR=$(dirname "$0")
echo "BASEDIR: $BASEDIR"

BASEDIR1=$(realpath "$0")
echo "BASEDIR: $BASEDIR1"

BASEDIR2=$(realpath "$0/get-cov-diff")
echo "BASEDIR: $BASEDIR2"

# target_branch=$1

# # Display the provided target branches
# echo "compare $current_branch branch to $target_branch"

# # Run nvm use (if nvm is installed)
# export NVM_DIR=$HOME/.nvm;
# source $NVM_DIR/nvm.sh;

# nvm use
# npm i

# # Run npm run test:coverage and append output to a file
# npm run test:coverage > $BASEDIR/coverage/branch_current_coverage.txt

# # clean up change files after install (package-lock.json)
# git restore .

# # Checkout the second target branch
# git checkout $target_branch
# git pull origin $target_branch

# nvm use
# npm i

# # Run npm run test:coverage and append output to a file
# npm run test:coverage > $BASEDIR/coverage/branch_target_coverage.txt

# nvm use stable
# # running index.js in this file directory even calling from another directory
# node $BASEDIR/index.js $BASEDIR/coverage/branch_current_coverage.txt $BASEDIR/coverage/branch_target_coverage.txt

# # clean up change files after install (package-lock.json)
# git restore .
# git checkout $current_branch
# # End of the script
