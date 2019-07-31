#!/bin/sh

. $(dirname $0)/regress_util.sh

# Now create a workspace from bar
wit init myws
cd myws

wit add-pkg https://github.com/sifive/block-pio-sifive

set -x

# brew install coreutils

echo $CI

if [ "$CI" = "TRUE" ]; do
    git config --global url."https://github.com/".insteadOf 'git@github.com:'
fi

timeout 3 wit update

ls block-pio-sifive

check "packages should not be checked out when update is interrupted" [ $? -ne 0 ]

if [ "$CI" = "TRUE" ]; do
    git config --global url."https://github.com/".insteadOf 'git@github.com:'
fi

wit update

ls block-pio-sifive

check "packages should be checked out after update is resumed" [ $? -eq 0 ]

set +x

report
finish
