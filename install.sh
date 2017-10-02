#!/bin/bash

set -e

if (( "${#DEVOPS_FETCH[*]}" < 1 ))
then
    DEVOPS_FETCH=(cat)
fi

if (( "${#DEVOPS_LOCATION[*]}" < 1 ))
then
    DEVOPS_LOCATION=`dirname "${BASH_SOURCE[0]}"`
fi

if [[ ! -z "${DEVOPS_REMOTE}" ]]
then
    if ! which curl 2>&1 >/dev/null
    then
        apt-get update && apt-get install -qq curl
    fi
    DEVOPS_FETCH=(curl -sL)
    DEVOPS_LOCATION="https://raw.githubusercontent.com/burgerdev/devops/master"
fi

if (( "${#DEVOPS_SUBS[*]}" < 1 ))
then
    DEVOPS_SUBS=(ubuntu-basic-packages add-dotfiles add-github-public-keys \
                 ubuntu-docker-setup ubuntu-kubernetes-setup)
fi


logs=`mktemp`
clean=false

function clean_logs {
    if [[ "${clean}" != "true" ]]
    then
        echo "*** FAILED ***"
        cat "${logs}" >&2
    fi
    rm "${logs}"
}

trap clean_logs EXIT


function run_sub_installer {
    set -e -o pipefail
    "${DEVOPS_FETCH[@]}" "${DEVOPS_LOCATION}/$1" | bash 2>&1 > "${logs}"
}


for f in "${DEVOPS_SUBS[@]}"
do
    if ! (echo "${DEVOPS_DISABLED_SUBS[*]}" | grep -q "$f" )
    then
        echo "*** running '$f.sh' ***"
        run_sub_installer "$f.sh"
    fi
done

