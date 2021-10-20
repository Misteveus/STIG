FROM ubuntu:focal

# use bash in place of sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt update && apt upgrade
WORKDIR /app
COPY . .

# set timezone and locale
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=US/Hawaii
RUN apt-get install -y tzdata

# install programs & libs for build
RUN apt-get -y install python3 \
    build-essential \
    libssl-dev \
    apt-transport-https \
    git \
    curl \
    wget \
    libglib2.0 \
    libnss3 \
    libgtk-3-0 \
    libx11-xcb1 \
    libx11-dev \
    libxss1 \
    libasound2 

# install nvm, npm, node
RUN mkdir /root/.nvm
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 14.18.1

RUN curl https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

RUN source $NVM_DIR/nvm.sh \
    && nvm ls-remote \
    && nvm install $NODE_VERSION --latest npm \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add to PATH
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# update npm and install yarn & electron
RUN npm update \
    && npm install -g yarn \
    && npm install electron

CMD ["yarn", "start"]