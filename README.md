# Docker container for Forticlient

This is a Docker container for Forticlient and other useful commands foar avoiding the direct connection to a VPN with your computer.

This docker container is able to launch the following applications:

- Forticlient VPN using X.
- Squid proxy for routing SSH connections for the host machine.
- Chromium browser using X.

## Quick Start

**NOTE**: The Docker command provided in this quick start is given as an example and parameters should be adjusted to your need.

- Launch the docker container with the following command:

``` bash
docker run --rm -it \
        --privileged \
        --name fortisslvpn \
        --env="DISPLAY" \
        --env="LC_ALL=C" \
        --env="QT_X11_NO_MITSHM=1" \
        -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        -v <PATH_TO_CPN_HISTORY_CONFIG_FILE>:/root/.fctsslvpnhistory \
        -v <PATH_TO_CERTIFICATE>:/opt/cer.p12 \
        -p 3128:3128
        alvsanand/forticlient-vpn-docker
```

- Configure SSH client to use the Proxy server of the container:

``` bash
cat <<EOF >> ~/.ssh/config
    Host VPN_NETWORK_WILCARD # Ex: 10.*
      ProxyCommand socat - "PROXY:localhost:%h:%p,proxyport=3128"
      IdentityFile <PATH_TO_PEM_CERTIFICATE>
    EOF
```

- Open SSH connection:

``` bash
SSH_HOST=100.1.1.1
ssh ec2-user@$SSH_HOST
```

- Open SSH connection with port forwarding:

``` bash
SSH_HOST=100.1.1.1
ssh -L 443:127.0.0.1:443 ec2-user@$SSH_HOST
```

- Open chromium browser:

``` bash
xhost +local:root
docker exec --env="LC_ALL=C" -it $(docker ps -aqf "name=fortisslvpn") chromium-browser --no-sandbox --proxy-pac-url="<AUTO_PROXY_CONFIGURATION_URL>"
```
