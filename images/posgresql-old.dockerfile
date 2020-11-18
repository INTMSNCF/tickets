FROM intm:ubuntu14

# Note: The official Debian and Ubuntu images automatically ``apt-get clean``
# after each ``apt-get``
RUN apt -y update && apt -y upgrade && \
    apt-get -y install software-properties-common && \
    add-apt-repository -y ppa:git-core/ppa && \
    apt -y update && apt -y upgrade && \
    apt-get -y install \
        build-essential \
        libreadline-dev \
        zlib1g-dev \
        flex \
        bison \
        libxml2-dev \
        libxslt-dev \
        libssl-dev \
        libxml2-utils \
        xsltproc \
        git \
        jade \
        docbook \
        docbook-dsssl \
        docbook-xsl \
        openjade1.3 \
        opensp \
        xsltproc \
        libdbd-pg-perl \
        && \
    apt-get clean && \
    useradd -m postgres --uid=1001 && echo "postgres:postgres" | chpasswd && \
    mkdir -p /usr/local/pgsql/data && \
    chown -R postgres /usr/local/pgsql/data && \
    mkdir -p /usr/intm && \
    cd /usr/intm && \
    git clone https://github.com/INTMSNCF/postgres.git && \
    cd /usr/intm/postgres && \
    git checkout intm-t-52 && \
    ./configure && \
    chown -R intm:intm /usr/intm/
