#!/bin/sh

. $(dirname $0)/regress_util.sh

prereq on

into_test_dir

# Now create a workspace from bar
wit init myws
cd myws

wit add-pkg https://github.com/sifive/block-pio-sifive

prereq off

# brew install coreutils
cp ~/.gitconfig .
HOME=$PWD git config --global url."https://github.com/".insteadOf 'git@github.com:'

HOME=$PWD timeout 3 wit update

ls block-pio-sifive

check "packages should not be checked out when update is interrupted" [ $? -ne 0 ]

HOME=$PWD wit update

ls block-pio-sifive

check "packages should be checked out after update is resumed" [ $? -eq 0 ]

report
finish
