#!/bin/bash

# Check if both target branches are provided
if [ $# -lt 1 ]; then
  echo "Usage: $0 <target_branch>"
  exit 1
fi

# store current git branch name
current_branch=$(git rev-parse --short HEAD)

BASEDIR=$(dirname $(realpath $0))

target_branch=$1

# init use_filter to true if $2 is provided

if [ -z $2 ]; then
  use_filter=false
else 
  if [ $2 == "dashboard-v2" ]; then
    use_filter=true
  fi
fi

# Display the provided target branches
echo "compare $current_branch branch to $target_branch"

git diff --name-only $current_branch $target_branch > $BASEDIR/changed_files.txt

cat $BASEDIR/changed_files.txt | sed -n -e '/\.test\.js$/p' | tr '\n' ' ' > $BASEDIR/changed_test_files.txt

cat $BASEDIR/changed_files.txt | sed -n -e '/\.test\.js/!p' | tr '\n' ',' > $BASEDIR/changed_non_test_files.txt

# Run nvm use (if nvm is installed)
export NVM_DIR=$HOME/.nvm;
source $NVM_DIR/nvm.sh;

nvm use
npm i

# Run npm run test:coverage and append output to a file
npm run test:coverage -- $(cat $BASEDIR/changed_test_files.txt) --collectCoverageFrom={$(cat $BASEDIR/changed_non_test_files.txt)} > $BASEDIR/branch_current_coverage.txt

# clean up change files after install (package-lock.json)
git restore .

# Checkout the second target branch
git checkout $target_branch
git pull origin $target_branch

nvm use
npm i

# Run npm run test:coverage and append output to a file
npm run test:coverage -- $(cat $BASEDIR/changed_test_files.txt) --collectCoverageFrom={$(cat $BASEDIR/changed_non_test_files.txt)} > $BASEDIR/branch_target_coverage.txt

nvm use stable
# running index.js in this file directory even calling from another directory
node $BASEDIR/index.js $BASEDIR/branch_current_coverage.txt $BASEDIR/branch_target_coverage.txt $BASEDIR/changed_files.txt $use_filter

# clean up change files after install (package-lock.json)
git restore .
git checkout $current_branch
# End of the script
