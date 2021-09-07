#!/usr/bin/env bash

###################################################################################
# This script checks to see if a changelog file has been added
# with the "skipCI" field set to true.
###################################################################################

set -ex

echo "SKIP_CI=false" >> $GITHUB_ENV

if [[ $(git diff origin/main..$GITHUB_HEAD_REF | grep "+++ b/changelog/" | wc -l) = "       1" ]]; then
    echo "exactly one changelog added since main"
#     gitFileChange=$(git diff $GITHUB_BASE_REF..$GITHUB_HEAD_REF | grep "+++ b/changelog/")
    gitFileChange=$(git diff origin/main..$GITHUB_HEAD_REF | grep "+++ b/changelog/")
    changelogFileName=$(echo $gitFileChange | sed 's/+++ b\///g')
    echo "changelog file name == $changelogFileName"
    if [[ $(cat $changelogFileName | grep "skipCI: true") ]]; then
        echo "skip CI"
	echo "SKIP_CI=true" >> $GITHUB_ENV
    else
        echo "skipCI not set to true - not skipping CI"
    fi
else
    echo "no changelog found (or more than one changelog found) - not skipping CI"
fi
