This will set a static IP using on machine (vs. from the network controller via
leasing or mac binding). This assumes you know:

1. your desired IP
2. your desired subnet mask
3. your desired nameservers
4. your desired network gateway

This assumes your network services are managed using `networkd` and `netplan` on
an ubuntu 22 server. This will probably not work on a Raspberry Pi which uses
`dchpd` on Bullseye and `NetworkManager` on Bookworm

Create a file at: `/etc/netplan/01-netcfg.yaml`

With these contents:

```yaml
# created: 10/10/23 Zach Waite
#
network:
  version: 2
  renderer: networkd
  ethernets:
    ens3:
      dhcp4: no
      addresses:
        # this is the static ip you want to set, and the CIDR thing you need
        # e.g. /24 would indicate a subnet mask of 255.255.255.0
        # e.g. /21 would indicate a subnet mask of 255.255.248.0
        # see: https://techlibrary.hpe.com/docs/otlink-wo/CIDR-Conversion-Table.html
        - 192.168.0.xxx/24
      routes:
        - to: default
          via: 192.168.0.xxx # this is the gateway ip
      nameservers:
        addresses:
          - 192.168.0.xxx # local dns server ip
          - 8.8.8.8 # google dns server ip
          - 8.8.4.4
```
