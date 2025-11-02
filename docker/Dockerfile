FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openssh-server sudo python3 python3-apt ca-certificates netcat-traditional curl && \
    rm -rf /var/lib/apt/lists/*

# Create user and configure ssh
RUN groupadd -f sudo && \
    id -u ubuntu >/dev/null 2>&1 || useradd -m -s /bin/bash ubuntu && \
    echo 'ubuntu:ubuntu' | chpasswd && \
    usermod -aG sudo ubuntu && \
    printf "ubuntu ALL=(ALL) NOPASSWD:ALL\n" > /etc/sudoers.d/90-ubuntu && \
    chmod 0440 /etc/sudoers.d/90-ubuntu

# SSH configuration
RUN mkdir -p /var/run/sshd && \
    (grep -q '^PasswordAuthentication' /etc/ssh/sshd_config \
    && sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    || echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config) && \
    (grep -q '^PermitRootLogin' /etc/ssh/sshd_config \
    && sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config \
    || echo 'PermitRootLogin no' >> /etc/ssh/sshd_config)

EXPOSE 22
CMD ["/usr/sbin/sshd","-D","-e"]
