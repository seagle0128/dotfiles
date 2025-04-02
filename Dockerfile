# This dockerfile is for Centaur dotfiles
# VERSION 1.0.0
# Author: Vincent Zhang
# Command format: Instruction [arguments / command] ..

# Base image to use
FROM ubuntu

# Maintainer:
MAINTAINER Vincent Zhang seagle0128@gmail.com

# Commands to update the image
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak
RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y software-properties-common

# Install Centaur Emacs
RUN add-apt-repository -y ppa:kelleyk/emacs
RUN apt-get update
RUN apt-get install -y wget curl sudo git zsh emacs-nox
RUN sh -c "$(wget https://github.com/seagle0128/dotfiles/raw/master/install.sh -O -)"

ENV TERM xterm-256color
WORKDIR /root
