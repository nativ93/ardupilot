FROM ubuntu:bionic
WORKDIR /ardupilot

RUN useradd -U -d /ardupilot ardupilot && \
    usermod -G users ardupilot

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --no-install-recommends -y \
    lsb-release \
    sudo ntp \
    software-properties-common && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV USER=ardupilot

ADD Tools/scripts/install-prereqs-ubuntu.sh /tmp/install-prereqs-ubuntu.sh
RUN bash -c "export DEBIAN_FRONTEND=noninteractive; SKIP_GIT=true /tmp/install-prereqs-ubuntu.sh -y && apt-get install gcc-arm-none-eabi -y" && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 14550

ADD . /ardupilot
RUN modules/waf/waf-light configure --board sitl && \
    modules/waf/waf-light build --target bin/ardurover && \
    modules/waf/waf-light build --target bin/arduplane && \
    modules/waf/waf-light build --target bin/arducopter && \
    modules/waf/waf-light build --target bin/arducopter-heli

ENV CCACHE_MAXSIZE=1G
ENV PATH /usr/lib/ccache:/ardupilot/Tools:${PATH}
