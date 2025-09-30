FROM debian:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openfortivpn \
        openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash vpnuser \
    && echo 'vpnuser:changeme' | chpasswd

RUN mkdir -p /var/run/sshd

RUN sed -i 's/^#\?Port .*/Port 8022/' /etc/ssh/sshd_config

RUN mkdir -p /opt/app

COPY config opt/app/config

RUN echo '/usr/sbin/sshd -D & openfortivpn -c /opt/app/config/vpn_config' > /opt/app/go.sh

EXPOSE 8022

CMD ["/bin/bash", "/opt/app/go.sh"]
