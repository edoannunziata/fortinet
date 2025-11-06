# Configuration Directory

This directory contains placeholder configuration files needed for building the Docker image.

## Important Security Notice

**DO NOT commit real credentials or secrets to this repository!**

## Setup Instructions

Before building and running the Docker image:

1. Copy `vpn_config` to create your local version:
   ```bash
   cp config/vpn_config config/vpn_config.local
   ```

2. Edit `config/vpn_config.local` with your actual VPN credentials:
   - Replace `vpn.example.com` with your actual VPN gateway
   - Replace `your-username-here` and `your-password-here` with your credentials
   - Configure any additional settings as needed

3. Modify the Dockerfile to use your local config file if needed

4. Add `config/vpn_config.local` to `.gitignore` to prevent accidental commits

## Configuration File Format

The `vpn_config` file uses the OpenFortiVPN configuration format. See the [OpenFortiVPN documentation](https://github.com/adrienverge/openfortivpn) for more details on available options.
