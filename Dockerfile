FROM ubuntu:18.04


### Set environment variables
# Change default Shell to bash
SHELL ["/bin/bash", "-c"]
# Set noninteract for tzdata
ARG DEBIAN_FRONTEND=noninteractive


### Change settings
# Change bash shell prompt color of root account
RUN sed -i 's/    xterm-color) color_prompt=yes;;/    #xterm-color) color_prompt=yes;;\n    xterm-color|*-256color) color_prompt=yes;;/' /root/.bashrc
# Change original green color of bash shell prompt to red color
RUN sed -i 's/    PS1=\x27${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;32m\\\]\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]\\\$ \x27/    PS1=\x27\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;31m\\\]\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]\\\$ \x27/' /root/.bashrc
# Install essential packages
RUN apt update \
    && apt install -y \
        tzdata \
        beep \
        git \
        ca-certificates
# Change Ubuntu repository address to Kakao server in Republic of Korea
RUN sed -i 's/^deb http:\/\/archive.ubuntu.com/deb https:\/\/mirror.kakao.com/g' /etc/apt/sources.list
RUN sed -i 's/^deb http:\/\/security.ubuntu.com/deb https:\/\/mirror.kakao.com/g' /etc/apt/sources.list

### Settings SSH-tunneling
RUN apt update \
    && apt install -y \
        openssh-server
# Set sshd_config
RUN sed -i 's/^#AllowTcpForwarding yes/AllowTcpForwarding yes/g' /etc/ssh/sshd_config
RUN sed -i 's/^#GatewayPorts no/GatewayPorts yes/g' /etc/ssh/sshd_config
RUN sed -i 's/^#TCPKeepAlive yes/TCPKeepAlive yes/g' /etc/ssh/sshd_config


### Postprocessing & Cleaning
# Add Bash alias
RUN echo 'alias l="ls -alh --full-time"' >> ~/.bashrc
RUN echo 'alias cls="clear"' >> ~/.bashrc
# Clean the cache
RUN apt clean \
    && rm -rf /var/lib/apt/lists/*
# Set workspace
WORKDIR /root