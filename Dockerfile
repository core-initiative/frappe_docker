FROM ubuntu:22.04

RUN apt update -y && apt upgrade -y
RUN apt install software-properties-common -y
RUN apt install -y git curl cron python3-dev python3-setuptools python3-pip \
virtualenv python3.10-venv libmysqlclient-dev redis-server libpq-dev \
mariadb-client zlib1g libffi-dev libssl-dev libxml2-dev libxslt1-dev libjpeg8-dev zlib1g-dev
RUN pip3 install frappe-bench==5.20.0 && pip3 install redis
RUN useradd -m ihram -s /bin/bash
RUN usermod -aG sudo ihram
RUN echo "ihram ALL=NOPASSWD: ALL" >> /etc/sudoers

ENTRYPOINT ["tail", "-f", "/dev/null"]