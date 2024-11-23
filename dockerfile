# dockerfile
# https://github.com/actions/runner/pkgs/container/actions-runner // runner 버전확인
FROM ghcr.io/actions/actions-runner:__BASE_IMAGE_VERSION__

# Add Docker's official GPG key:
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends ca-certificates curl \
    && install -m 0755 -d /etc/apt/keyrings \
    && sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
    && sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && sudo apt-get update

# docker/compose cli only
RUN sudo apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin

# set kr locale
RUN sudo apt-get install -y --no-install-recommends  locales language-pack-ko && sudo locale-gen ko_KR.UTF-8 && sudo dpkg-reconfigure locales
ENV LC_ALL ko_KR.UTF-8

# install screen, vim
RUN sudo apt-get install -y --no-install-recommends screen vim

# install mysql
RUN sudo apt-get install -y --no-install-recommends mysql-server \
    && sudo usermod -d /var/lib/mysql/ mysql

# install java21
RUN sudo apt-get install -y --no-install-recommends openjdk-21-jdk

# install deploy-tools
RUN sudo apt update \
    && sudo apt-get install -y --no-install-recommends git openssh-client wget unzip jq less \
    && sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && sudo chmod +x /usr/local/bin/yq

# cleanup cache
RUN sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*