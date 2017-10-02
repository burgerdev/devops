#!/bin/bash

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
        if [[ "$?" != 0 ]]
        then
            echo "Could not install basic dependencies" >&2
            exit 1
        fi
    fi
    DEVOPS_FETCH=(curl -sL)
    DEVOPS_LOCATION="https://raw.githubusercontent.com/burgerdev/devops/master"
fi

if (( $# < 1 ))
then
    DEVOPS_SUBS=(ubuntu-basic-packages add-dotfiles add-github-public-keys \
                 ubuntu-docker-setup ubuntu-kubernetes-setup)
else
    DEVOPS_SUBS=("$@")
fi


function run_sub_installer {
    logs=`mktemp`

    set -o pipefail
    "${DEVOPS_FETCH[@]}" "${DEVOPS_LOCATION}/$1" | bash 2>&1 > "${logs}"

    status=$?
    if [[ "$status" != 0 ]]
    then
        echo "*** FAILED ***"
        cat "${logs}" >&2
    fi
    rm -f "${logs}"

    return $status
}

echo "Installing: ${DEVOPS_SUBS[*]}."

for f in "${DEVOPS_SUBS[@]}"
do
    if ! (echo "${DEVOPS_DISABLED_SUBS[*]}" | grep -q "$f" )
    then
        echo "*** running '$f.sh' ***"
        run_sub_installer "$f.sh"
        status=$?
        if [[ "$status" != 0 ]]
        then
            exit $status
        fi
    fi
done

