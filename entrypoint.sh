#!/bin/sh

set -e

echo ${KUBE_CONFIG_DATA} | base64 -d > kubeconfig
export KUBECONFIG="${PWD}/kubeconfig"
chmod 600 ${PWD}/kubeconfig

if [[ -n "${INPUT_PLUGINS// /}" ]]
then
    plugins=$(echo $INPUT_PLUGINS | tr ",")

    for plugin in $plugins
    do
        # check if helm plugin already installed and if not, install it
        if ! helm plugin list | grep -q $plugin
        then
            echo "installing helm plugin: [$plugin]"
            helm plugin install $plugin
        fi
    done
fi

if [[ -n "$INPUT_GPG_PRIVATE_KEY" ]]
then
    echo "importing GPG private key"
    echo "$INPUT_GPG_PRIVATE_KEY" | gpg --import
fi

echo "running entrypoint command(s)"

response=$(sh -c " $INPUT_COMMAND")

echo "::set-output name=response::$response"