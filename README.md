# Auto redir for v2ray

Script and unit files for automatically configuring routing for v2ray with
`iptables`. Determining which packets to proxy and which to send directly
depends solemnly on `v2ray`, so make sure you configure routing properly in
your `v2ray` configuration.

## Dependencies

 - V2Ray
 - `jq` (for parsing the json configuration file)
 - `iptables` (with "owner" matching module support)

## Installation / Uninstallation

See `install.sh` usage.

## License

This repository is licensed under the MIT license.
