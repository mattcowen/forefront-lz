# Intro

This project creates a dev container prepared with the TF, GO and other dependencies. This container image is then made available in the ACR created in the bootstrapping and then used to run the workflows in GitHub Actions.

When needing to update the build-agent-tools container image then it might be best to open this build-agent-tools folder in VS Code independently on a machine with Docker installed before running Docker build etc.  

>Note: before building this image, create an empty subdirectory named `configuration` alongside the Dockerfile.

