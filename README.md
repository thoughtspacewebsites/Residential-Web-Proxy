# Residential Web Proxy #

#### A static IP for your homelab!  ####

Utilizes docker to install both OpenVPN server and HAProxy. Using OpenVPN, clients can connect to the server and be used to forward incoming web connections to. HAProxy sits on the front end on both port 80 and 443, and redirects requests to the backend servers (which can be behind a dynamic residential IP, and referenced with a DynDNS domain). Can be used to set up secure load balancers off site. This is meant to run on a public VPS somewhere like Digital Ocean in order to obtain a static IP that can be forwarded to a dynamic IP. Really, it's a cheater way to get a static IP for your homelab in a secure way, at least for web redirect use.

## How To ##

This image depends on the kylemanna/openvpn docker image. This image must be installed and correctly configured. You'll want to set this image up on a cloud VPS service like Digital Ocean. Install Docker and docker compose, and then follow the docker-compose quick start guide here: https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md

After getting the server set up, and configuring a client certificate for your home lab, we'll want to make sure we have our port configuration for Docker set up right. You can do this by opening the docker-compose.yml file and editing the ports area to your liking. This will link publicly accessible ports on the host machine through to a port within our OpenVPN docker container. From there, we'll be able to route that internal container port to the proper port on our client machine. For example, if you want to forward SSH through your server (recommended otherwise you'll be limited to console access), you would add a section to the ports in docker-compose for it. I like to use a random public and container port for this service. The random public port keeps it from conflicting with SSH access to the server itself. For example, I use "2613:12344" in the ports of my docker-compose. This will forward port 2613 on the host machine through to port 12344 within the container, where we'll be able to further forward it after connecting our client.

After configuring your docker-compose ports for any public services you'll need, make sure the container is online by running

	docker-compose up -d

After bringing the container online, we now have an OpenVPN server running on our machine. At this point, you'll need to copy your generated client config file down to your homelab and use an OpenVPN client to create a connection. Any will do. The server will handle DHCP (or static address assignment if configured below) for the homelab client. Once the server is connected, we'll need to properly forward our required ports through the server to the client.

Back over on the server machine, run:

	docker exec -i openvpn bash -s VPN_CLIENT_IP VPN_CLIENT_PORT DOCKER_CONTAINER_PORT < forward.sh 

So for our SSH example above, and assuming a static VPN client IP of 192.168.255.100, the command would look like this:

	docker exec -i openvpn bash -s 192.168.255.100 22 12344 < forward.sh

In this example, port 12344 from our docker container inbound will be forwarded through to port 22 on our homelab (the SSH port). You need to run this command for every port combo that you'd like to forward through to the client. Every instance of the forward.sh command run should have a corresponding entry in docker-compose.yml ports section, otherwise the traffic won't be properly forwarded into the container for further forwarding to our client.

If you ever rebuild the openvpn server container, you'll need to rerun the above command to reconfigure routing.

If following the example above, you'll now SSH both the homelab and VPN server with the same IP address, but a different port. This is due to all traffic being routed through the VPN for added security.


## Setting Client Static IP ##

In order to define the static IP for each connected client, after creating your client config files, create a file in /openvpn-data/conf/ccd with the name of your client (for example, "my-client". Then, in this file, paste the following, replacing the first IP with your desired static IP address

	ifconfig-push 192.168.255.xxx 192.168.255.1

## Use, abuse, and expand this! ##

This is a labor of love, trying to figure out a way to create a static IP tied to a homelab that doesn't require paying your residential ISP for business class service just to get a static address. Also, you can keep this static IP as long as you pay for your cloud service server. It will move with you if you ever move, creating a very reliable way to keep a static IP on a homelab setup. 

Anyway, there may be bugs or other issues, and this is a young repo that's continuing to grow. Contributions and recommendations are highly welcome!
