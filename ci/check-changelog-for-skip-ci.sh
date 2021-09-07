#!/usr/bin/env bash

###################################################################################
# This script checks to see if a changelog file has been added
# with the "skipCI" field set to true.
###################################################################################

echo "SKIP_CI=false" >> $GITHUB_ENV

if [[ $(git diff main | grep "+++ b/changelog/" | wc -l) = "       1" ]]; then
    echo "exactly one changelog added since main"
    gitFileChange=$(git diff main | grep "+++ b/changelog/")
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
