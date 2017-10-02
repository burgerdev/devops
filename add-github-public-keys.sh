#!/bin/bash

set -eo pipefail

github_user="${GITHUB_USER:-burgerdev}"
ssh_dir="${DEVOPS_SSH_AUTHORIED_KEYS:-${HOME:-/root}/.ssh}"
auth_key_file="${ssh_dir}/authorized_keys"

mkdir -p `dirname "${ssh_dir}"`
chmod 700 `dirname "${ssh_dir}"`

tmp=`mktemp`

if [[ -f "${auth_key_file}" ]]
then
    cat "${auth_key_file}" >"${tmp}"
fi

num_keys=`wc -l <"${tmp}"`

curl -s "https://api.github.com/users/${github_user}/keys" | \
    jq -r ".[].key + \" ${github_user}@github.com\"" >> "${tmp}"

tmp2=`mktemp`

sort < "${tmp}" | uniq > "${tmp2}"

num_keys_after=`wc -l <"${tmp2}"`

if (( "${num_keys_after}" < "${num_keys}" ))
then
    echo "Error: keys would be lost by this operation, not modifying ${auth_key_file}" >&2
    exit 1
fi

case $OSTYPE in
    darwin*) CP=gcp;;
    *) CP=cp;;
esac
${CP} --backup=t "${tmp2}" "${auth_key_file}"
chmod 600 "${auth_key_file}"*
