FROM ubuntu:14.04.2

RUN apt-get update && apt-get install -y sudo && \
    useradd -m intm --uid=1000 && echo "intm:intm" | chpasswd && \
    adduser intm sudo
