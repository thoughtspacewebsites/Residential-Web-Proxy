# Residential Web Proxy #

Utilizes docker to install both OpenVPN server and HAProxy. Using OpenVPN, clients can connect to the server and be used to forward incoming web connections to. HAProxy sits on the front end on both port 80 and 443, and redirects requests to the backend servers (which can be behind a dynamic residential IP, and referenced with a DynDNS domain). Can be used to set up secure load balancers off site. This is meant to run on a public VPS somewhere like Digital Ocean in order to obtain a static IP that can be forwarded to a dynamic IP. Really, it's a cheater way to get a static IP for your homelab in a secure way, at least for web redirect use.

## How To ##

Run docker-compose up -d, and then afterwards, run:

	docker-compose exec -T openvpn /bin/sh < ./forward.sh

This will create the required routing rules to pass an SSH connection through the VPN to the client machine
