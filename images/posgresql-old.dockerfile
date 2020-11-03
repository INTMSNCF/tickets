FROM intm:ubuntu14

# Note: The official Debian and Ubuntu images automatically ``apt-get clean``
# after each ``apt-get``
RUN apt -y update && apt -y upgrade && \
    apt-get -y install build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc git && \
    mkdir -p /usr/intm && \
    cd /usr/intm && \
    git clone https://github.com/INTMSNCF/postgres.git && \
    cd /usr/intm/postgres && \
    git checkout intm-t-52 && \
    ./configure
