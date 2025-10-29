# Fortinet VPN Docker Container

A containerized solution for connecting to Fortinet VPN using OpenFortiVPN with built-in SSH access.

## Overview

This project provides a Docker/Podman-based environment for running OpenFortiVPN, an open-source client for Fortinet VPN. The container includes an SSH server, allowing you to access the VPN-connected environment remotely or use it as a jump host.

## Features

- Containerized Fortinet VPN client (OpenFortiVPN)
- Built-in SSH server for remote access
- Easy deployment with Podman or Docker
- Isolated VPN environment
- Port forwarding support via SSH tunneling

## Prerequisites

- Docker or Podman installed on your system
- Fortinet VPN credentials and server information
- Sudo/root access (required for privileged container mode)

## Setup

### 1. Create VPN Configuration

Create a `config` directory in the project root and add your VPN configuration file:

```bash
mkdir -p config
```

Create `config/vpn_config` with your Fortinet VPN settings:

```
host = vpn.example.com
port = 443
username = your_username
password = your_password
trusted-cert = <certificate_hash>
```

**Configuration Options:**
- `host`: Your Fortinet VPN server address
- `port`: VPN server port (typically 443 or 10443)
- `username`: Your VPN username
- `password`: Your VPN password (or omit for interactive prompt)
- `trusted-cert`: Certificate fingerprint (optional, but recommended)

For more configuration options, see the [OpenFortiVPN documentation](https://github.com/adrienverge/openfortivpn).

### 2. Build the Container

Using Podman:
```bash
sudo podman build -t ofn-vpn .
```

Using Docker:
```bash
sudo docker build -t ofn-vpn .
```

## Usage

### Starting the VPN Container

Run the provided start script:

```bash
./start.sh
```

Or manually with Podman:
```bash
sudo podman run --privileged -p 8022:8022 -i ofn-vpn
```

Or manually with Docker:
```bash
sudo docker run --privileged -p 8022:8022 -i ofn-vpn
```

**Note:** The `--privileged` flag is required for VPN functionality as the container needs to create network interfaces.

### SSH Access

Once the container is running, you can SSH into it:

```bash
ssh vpnuser@localhost -p 8022
```

**Default credentials:**
- Username: `vpnuser`
- Password: `changeme`

### SSH Tunneling

Use the container as a jump host to access resources behind the VPN:

```bash
# Port forwarding example
ssh -L 8080:internal-server:80 vpnuser@localhost -p 8022

# SOCKS proxy example
ssh -D 9050 vpnuser@localhost -p 8022
```

## Configuration Details

### Container Ports

- **8022**: SSH server (mapped to host)

### File Locations (inside container)

- `/opt/app/config/vpn_config`: VPN configuration file
- `/opt/app/go.sh`: Startup script
- `/var/run/sshd`: SSH daemon runtime directory

## Security Considerations

1. **Change the default password**: The default SSH password (`changeme`) is hardcoded in the Dockerfile. For production use, modify line 10 in the Dockerfile:
   ```dockerfile
   RUN echo 'vpnuser:your_secure_password' | chpasswd
   ```

2. **Protect your VPN configuration**: The `config` directory is git-ignored to prevent accidentally committing VPN credentials. Keep this directory secure and never commit it to version control.

3. **Use SSH keys**: For better security, consider adding SSH key authentication:
   ```bash
   ssh-copy-id -p 8022 vpnuser@localhost
   ```

4. **Privileged mode**: The container runs in privileged mode for VPN functionality. Be aware of the security implications.

5. **Certificate validation**: Use the `trusted-cert` option in your VPN config to prevent man-in-the-middle attacks.

## Troubleshooting

### Container won't start
- Ensure you have sudo/root privileges
- Verify Podman/Docker is installed and running
- Check that the `config/vpn_config` file exists

### VPN connection fails
- Verify your VPN credentials in `config/vpn_config`
- Check the VPN server address and port
- Review container logs: `sudo podman logs <container_id>`

### SSH connection refused
- Ensure the container is running
- Verify port 8022 is not blocked by firewall
- Check that port mapping is correct: `-p 8022:8022`

### Permission issues
- VPN requires privileged mode: `--privileged` flag is mandatory
- Ensure you're running with sudo/root

### Getting VPN certificate fingerprint

If you need the certificate fingerprint for `trusted-cert`:

```bash
# Run container without trusted-cert first, it will display the fingerprint
# in the error message when connecting
```

## Project Structure

```
fortinet/
├── Dockerfile          # Container configuration
├── start.sh           # Startup script
├── config/            # VPN configuration (git-ignored)
│   └── vpn_config     # OpenFortiVPN configuration file
├── README.md          # This file
└── LICENSE            # MIT License
```

## Advanced Usage

### Running in detached mode

```bash
sudo podman run --privileged -p 8022:8022 -d ofn-vpn
```

### Custom port mapping

```bash
sudo podman run --privileged -p 2222:8022 -i ofn-vpn
ssh vpnuser@localhost -p 2222
```

### Viewing logs

```bash
sudo podman ps  # Find container ID
sudo podman logs <container_id>
```

### Stopping the container

```bash
sudo podman stop <container_id>
```

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Acknowledgments

- [OpenFortiVPN](https://github.com/adrienverge/openfortivpn) - The open-source Fortinet VPN client that powers this container
