FROM ubuntu:focal

# Set versions for all downloaded tools
ARG TERRAFORM_VERSION=1.0.7
ARG GO_VERSION=1.17.1
ARG GOTESTSUM_VERSION=1.7.0
ARG GOLANGCILINT_VERSION=1.42.1
ARG TFLINT_VERSION=0.32.1
ARG TFLINT_AZURE_VERSION=0.13.1

# To build without user input
ENV DEBIAN_FRONTEND=noninteractive

# Install common tools and packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    software-properties-common \
    gnupg \
    apt-transport-https \
    lsb-release \
    ca-certificates \
    jq \
    curl \
    git \
    unzip

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Terraform latest
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get update && apt-get install terraform=${TERRAFORM_VERSION}

# Make shared download folder
RUN mkdir -p /tmp/docker-downloads

# Install Go into /usr/local/go
RUN curl -fsS https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz -o /tmp/docker-downloads/golang.tar.gz \
    && tar -C /usr/local -xvf /tmp/docker-downloads/golang.tar.gz 

# Install gotestsum into /usr/bin
RUN curl -fsSL https://github.com/gotestyourself/gotestsum/releases/download/v${GOTESTSUM_VERSION}/gotestsum_${GOTESTSUM_VERSION}_linux_amd64.tar.gz -o /tmp/docker-downloads/gotestsum.tar.gz \
    && tar -C /tmp/docker-downloads -xzf /tmp/docker-downloads/gotestsum.tar.gz \
    && mv /tmp/docker-downloads/gotestsum /usr/bin

# Install golangci-lint into /usr/bin
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/bin v${GOLANGCILINT_VERSION}

# Golang environmentals and path
ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV PATH=$PATH:/usr/local/go/bin

# Install tflint
ENV TFLINT_PLUGIN_DIR=/.tflint.d/plugins
RUN curl -sSL https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip -o /tmp/docker-downloads/tflint.zip \
    && unzip /tmp/docker-downloads/tflint.zip \
    && mv tflint /usr/local/bin \
    && curl -sSL https://github.com/terraform-linters/tflint-ruleset-azurerm/releases/download/v${TFLINT_AZURE_VERSION}/tflint-ruleset-azurerm_linux_amd64.zip -o /tmp/docker-downloads/tflint-ruleset-azurerm.zip \
    && unzip /tmp/docker-downloads/tflint-ruleset-azurerm.zip \
    && mkdir -p ${TFLINT_PLUGIN_DIR} \
    && mv tflint-ruleset-azurerm ${TFLINT_PLUGIN_DIR}/tflint-ruleset-azurerm

# Remove shared download folder
RUN rm -rf /tmp/docker-downloads

# Copy in our shared scripts & config
RUN mkdir /scripts
COPY scripts /scripts
RUN mkdir /configuration
COPY configuration /configuration

# change /bin/sh symlink from dash (default in ubuntu:focal) to bash
# because dash won't run some scripts that we use
RUN mv /bin/sh /bin/sh.old && ln -s bash /bin/sh

# Set the path and other runtime env vars
ENV DEBIAN_FRONTEND=interactive
ENV PATH=$PATH:/scripts

# Set up a non root user called 'vscode'
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
# Note. We don't switch to it, so the pipelines still run as root
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
