#!/bin/bash

# Check if both target branches are provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <target_branch>"
  exit 1
fi
# store current git branch name
current_branch=$(git branch --show-current)

target_branch=$1

# Display the provided target branches
echo "compare $current_branch branch to $target_branch"

# Run nvm use (if nvm is installed)
export NVM_DIR=$HOME/.nvm;
source $NVM_DIR/nvm.sh;
nvm use

# Run npm i
npm i

# Run npm run test:coverage and append output to a file
npm run test:coverage >> coverage/branch_current_coverage.txt

# clean up change files after install (package-lock.json)
git restore .

# Checkout the second target branch
git checkout $target_branch

git pull origin $target_branch

# Run nvm use (if nvm is installed)
nvm use

# Run npm i
npm i

# Run npm run test:coverage and append output to a file
npm run test:coverage >> coverage/branch_target_coverage.txt

# Your additional script logic goes here

nvm use stable
node /Users/nonisoon/get-cov-diff/index.js coverage/branch_current_coverage.txt coverage/branch_target_coverage.txt

# clean up change files after install (package-lock.json)
git restore .
git checkout $current_branch
# End of the script
