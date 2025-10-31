FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y openssh-server sudo python3 python3-apt ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -s /bin/bash ubuntu && echo 'ubuntu:ubuntu' | chpasswd && \
    adduser ubuntu sudo && \
    mkdir -p /var/run/sshd && \
    sed -ri 's/^#?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    printf "ubuntu ALL=(ALL) NOPASSWD:ALL\n" >/etc/sudoers.d/90-ubuntu

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
