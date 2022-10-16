#!/usr/bin/env bash
set -eo pipefail

## WRITE TOKEN TO /opt/teleport/token.txt first!
## CA_PIN must be set!

[[ -z "$CA_PIN" ]] && echo "CA_PIN must be set!" && exit 1
[[ -z "$TOKEN" ]] && echo "TOKEN must be set!" && exit 1

set -u

curl -O https://get.gravitational.com/teleport-v10.3.2-linux-amd64-bin.tar.gz
curl -O https://get.gravitational.com/teleport-v10.3.2-linux-amd64-bin.tar.gz.sha256
sha256sum --check teleport-v10.3.2-linux-amd64-bin.tar.gz.sha256
tar -xzf teleport-v10.3.2-linux-amd64-bin.tar.gz
cd teleport
BINDIR=/usr/local/bin
VARDIR=/var/lib/teleport
mkdir -p $VARDIR $BINDIR
cp -f teleport tctl tsh tbot $BINDIR/

mkdir -p /etc/systemd/system/teleport.service.d
mkdir -p /opt/teleport

tee /opt/teleport/token.txt > /dev/null <<EOF
$TOKEN
EOF

tee /etc/systemd/system/teleport.service > /dev/null <<'EOF'
[Unit]
Description=Teleport SSH Service
After=network.target

[Service]
Type=simple
Restart=on-failure
EnvironmentFile=-/etc/default/teleport
ExecStart=/usr/local/bin/teleport start --pid-file=/run/teleport.pid --roles=node --auth-server=port.alexeldeib.xyz:443 --token=/opt/teleport/token.txt
ExecReload=/bin/kill -HUP $MAINPID
PIDFile=/run/teleport.pid
LimitNOFILE=8192

[Install]
WantedBy=multi-user.target
EOF

tee /etc/systemd/system/teleport.service.d/ca_pin.conf > /dev/null <<EOF
[Service]
ExecStart=
ExecStart=/usr/local/bin/teleport start --pid-file=/run/teleport.pid --roles=node --auth-server=port.alexeldeib.xyz:443 --token=/opt/teleport/token.txt --ca-pin=$CA_PIN
EOF

systemctl enable teleport
systemctl restart teleport
