#!/bin/bash

# Check if both target branches are provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <target_branch>"
  exit 1
fi
# store current git branch name
current_branch=$(git branch --show-current)

target_branch=$1

root_dir=$0

# Display the provided target branches
echo "compare $current_branch branch to $target_branch"

# Run nvm use (if nvm is installed)
export NVM_DIR=$HOME/.nvm;
source $NVM_DIR/nvm.sh;

nvm use
npm i

# Run npm run test:coverage and append output to a file
npm run test:coverage > $root_dir/coverage/branch_current_coverage.txt

# clean up change files after install (package-lock.json)
git restore .

# Checkout the second target branch
git checkout $target_branch
git pull origin $target_branch

nvm use
npm i

# Run npm run test:coverage and append output to a file
npm run test:coverage > $root_dir/coverage/branch_target_coverage.txt

nvm use stable
# running index.js in this file directory even calling from another directory
node $root_dir/index.js $root_dir/coverage/branch_current_coverage.txt $root_dir/coverage/branch_target_coverage.txt

# clean up change files after install (package-lock.json)
git restore .
git checkout $current_branch
# End of the script
