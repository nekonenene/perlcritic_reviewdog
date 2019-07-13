FROM ubuntu:18.04

ARG REVIEWDOG_VERSION="0.9.12"

WORKDIR /home/perl

RUN apt-get update && \
  apt-get install -y \
    build-essential \
    cpanminus \
    curl \
    git \
    wget

COPY . .

RUN cpanm Carton && \
  carton install

RUN wget -q -O - "https://github.com/reviewdog/reviewdog/releases/download/v${REVIEWDOG_VERSION}/reviewdog_${REVIEWDOG_VERSION}_$(uname -s)_$(uname -m).tar.gz" | tar xzvf - reviewdog && \
  mv reviewdog /usr/local/bin
