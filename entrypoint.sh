#!/bin/sh

set -xe

echo "$KUBE_CONFIG" | base64 -d > /tmp/kube_config
export KUBECONFIG=/tmp/kube_config

if [ -z ${KUBECTL_VERSION} ] ; then
    echo "Using kubectl version: $(kubectl version --client --short)"
else
    echo "Installing kubectl version: $KUBECTL_VERSION"
    rm /usr/local/bin/kubectl

    case $KUBECTL_VERSION in

        1.21)
            KUBECTL_VERSION="1.21.14"
            ;;
        1.22)
            KUBECTL_VERSION="1.22.17"
            ;;
        1.23)
            KUBECTL_VERSION="1.23.17"
            ;;
        1.24)
            KUBECTL_VERSION="1.24.11"
            ;;
        1.25)
            KUBECTL_VERSION="1.25.7"
            ;;
        1.26)
            KUBECTL_VERSION="1.26.2"
            ;;
    esac
    
    curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/
fi

sh -c "$*"

