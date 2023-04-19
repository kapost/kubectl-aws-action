FROM amazon/aws-cli:latest

# Installs the lastest version of kubectl -- can specify specific versions for installation during the entrypoint.sh script and action using KUBECTL_VERSION
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Installs eksctl
RUN yum install -y tar \
    gzip
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp; mv /tmp/eksctl /usr/local/bin

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
