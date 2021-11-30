# escape=`
# The above statement changes the expected escape character in the dockerfile from "\" to "`".
# This is done as a compatibility adjustment to account for Windows file paths which make use of
# the "\" character instead of the Linux "/".

# Denotes that the prebuilt python dockerfile for Debian 10 will be used as the starting point for
# this container.
FROM python:3.8-buster

# Sets the base argument for "RUN" commands to be non-interactive shells, this is required for the
# installation of x11vnc, xvfb, fluxbox, and wmctrl
ARG DEBIAN_FRONTEND=noninteractive

# Sets the timezone for the container to be US, this is needed for setup of x11vnc, xvfb, fluxbox,
# and wmctrl
ENV TZ=US

# Prepares the timezone to be called as a variable later during the install of x11nvc, xvfb,
# fluxbox, and wmctrl
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Updates, upgrades, and installs required packages.
# x11vnc, xvfb, fluxbox, wmctrl are required for instantiating x11 interfaces on the host machine.
# gcc, default-jdk, and make are required for the complete operation of autograder.
# wget is required to install Miniconda and Chrome.
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y x11vnc xvfb fluxbox wget wmctrl gcc default-jdk make

# Pulls the latest copy of Miniconda such that Numba can be installed.
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# Executes install script for Miniconda.
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p /miniconda
# Sets environment path such that conda can be called from shell.
ENV PATH=$PATH:/miniconda/condabin:/miniconda/bin

# Pulls latest copy of Chrome such that Autograder can run using the browser.
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# Installs Chrome, cleans apt, and purges record of existing repositories to minimize space.
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb && apt-get clean && rm -rf /var/lib/apt/lists/*

# Installs Numba, a required dependency of autograder.
RUN conda install -y numba

# Creates a new group to restrict autograder user privileges.
RUN groupadd -r autograder

# Create a new user and adds them to the autograder users group.
RUN useradd -r node -g autograder

# Creates the working directory for the container.
RUN mkdir /home/autograder

# Sets the working directory for the container.
WORKDIR /autograder

# Installs autograder.
RUN pip install autograder_gui

# Launches bash on container start for testing purposes.
# This will be replaced with "CMD autograder_gui" when autograder can be successfully lanched
# from inside the container.
CMD /bin/bash

# All further development on this branch has been halted pending updates to autograder-gui.
