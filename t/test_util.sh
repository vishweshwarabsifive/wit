#!/bin/sh

wit_repo='git@github.com:sifive/wit'
test_root=$(dirname $(perl -MCwd -e "print Cwd::realpath('$0')"))
wit_root=$(perl -MCwd -e "print Cwd::realpath('$test_root/..')")

if [[ -z "${WIT}" ]]; then
  export PATH=$wit_root:${PATH}
else
  export PATH=${WIT}:${PATH}
fi

wit_bin=$(which wit)
echo "Running with wit: ${wit_bin}"

fail=0
pass=0
in_prereq=0

into_test_dir() {
    filename=`basename $0`
    dir="testdir.${filename%.*}"
    mkdir $dir
    cd $dir
}

make_repo() {
    repo_name=$1

    mkdir $repo_name
    git -C $repo_name init
    echo $RANDOM > $repo_name/file
    git -C $repo_name add -A
    git -C $repo_name commit -m "commit1"
}

check() {
    check_name=$1
    shift;

    if $@
    then echo "PASS - ${check_name}"; pass=$((pass+1))
    else echo "FAIL - ${check_name}"; fail=$((fail+1))
    fi
}

prereq() {
    if [ "$1" = "off" ]
    then in_prereq=0; set +e -x
    else in_prereq=1; set -e +x
    fi
}

report() {
    set +x
    echo "PASS: $pass"
    echo "FAIL: $fail"
}

finish() {
    if [ $in_prereq -eq 1 ]
    then fail=$((fail+1))
    fi

    if [ $pass -eq 0 ] && [ $fail -eq 0 ]
    then fail=$((fail+1))
    fi

    if [ $fail -eq 0 ]
    then echo "Test passed"; exit 0
    else echo "Test failed"; exit 1
    fi
}
