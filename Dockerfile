# base
FROM ubuntu:18.04

# set the github runner version
ARG RUNNER_VERSION="2.296.3"

# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker
# Change this section if you would like to install other dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y curl jq wget build-essential libssl-dev libffi-dev zlib1g-dev libbz2-dev libsqlite3-dev

RUN wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz && \
    tar -xf Python-3.10.0.tgz && \
    cd Python-3.10.0 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf Python-3.10.0* && \
    ln -s /usr/local/bin/python3.10 /usr/bin/python

RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3.10 get-pip.py && \
    ln -s /usr/local/bin/pip /usr/bin/pip

# cd into the user directory, download and unzip the github actions runner
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# install some additional dependencies
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# copy over the start.sh script
COPY start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
