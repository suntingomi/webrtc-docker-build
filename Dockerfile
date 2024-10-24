FROM ubuntu:20.04

COPY scripts/ /root/scripts/
RUN /root/scripts/apt_install_x86_64.sh \
  && sudo apt-get install -y openjdk-11-jdk \
  && sudo apt-get install -y build-essential
ENV LC_ALL=C.UTF-8

RUN mkdir -p /source
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /source/depot_tools
ENV PATH="$PATH:/source/depot_tools"
