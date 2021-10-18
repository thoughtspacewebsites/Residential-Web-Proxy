# Residential Web Proxy #

Utilizes docker to install both OpenVPN server and HAProxy. Using OpenVPN, clients can connect to the server and be used to forward incoming web connections to. HAProxy sits on the front end on both port 80 and 443, and redirects requests to the backend servers (which can be behind a dynamic residential IP, and referenced with a DynDNS domain). Can be used to set up secure load balancers off site. This is meant to run on a public VPS somewhere like Digital Ocean in order to obtain a static IP that can be forwarded to a dynamic IP. Really, it's a cheater way to get a static IP for your homelab in a secure way, at least for web redirect use.

## How To ##

This image depends on the kylemanna/openvpn docker image. This image must be installed and correctly configured. You'll want to set this image up on a cloud VPS service like Digital Ocean. Install Docker and docker compose, and then follow the docker-compose quick start guide here: https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md

After getting the server set up, and configuring a client certificate for your home lab, make sure the container is online by running

	docker-compose up -d

Afterwards, edit the forward.sh file and change all instances of the static IP address for the server to your actual homelabs IP address on the VPN network. The easiest way to figure this out is by just setting it to a static IP as described below. Anyway, edit forward.sh and make sure your proper IP for your homelab is in there. The defined ports will determine which port is exposed to the docker container instance that you'll then be able to forward out using the ports option in docker-compose. Right now, SSH to the client server after connection is defined on port 2613, but this can be easily changed by editing the docker-compose.yml and rerunning docker-compose up -d

After editing the forward.sh file to your liking, and ensuring the openvpn container is running, run the following to apply the rules to the running container.

	docker-compose exec -T openvpn /bin/sh < ./forward.sh

This will create the required routing rules to pass an SSH connection through the VPN to the client machine, and port 80

If you ever rebuild the openvpn server container, you'll need to rerun the above command to reconfigure routing.

You'll need to copy your generated client config file down to your homelab and use an OpenVPN client to create a connection. Any will do. The server will handle DHCP (or static address assignment if configured below) for the homelab client, and if everything is set up correctly, inbound traffic on port 80 to the VPN server should now be handed off over an encrypted connection straight to port 80 on your homelab!

At this point, SSH connections to the client machine must be routed through the VPN server. You can configure the external SSH port in the docker-compose.yml file. Essentially, you'll now SSH both the client and server with the same IP address, but a different port. This is due to all traffic being routed through the VPN.


## Setting Client Static IP ##

In order to define the static IP for each connected client, after creating your client config files, create a file in /openvpn-data/conf/ccd with the name of your client (for example, "my-client". Then, in this file, paste the following, replacing the first IP with your desired static IP address

	ifconfig-push 192.168.255.xxx 192.168.255.1

## Use, abuse, and expand this! ##

This is a labor of love, trying to figure out a way to create a static IP tied to a homelab that doesn't require paying your residential ISP for business class service just to get a static address. Also, you can keep this static IP as long as you pay for your cloud service server. It will move with you if you ever move, creating a very reliable way to keep a static IP on a homelab setup. 

Anyway, there may be bugs or other issues, and this is a young repo that's continuing to grow. Contributions and recommendations are highly welcome!
