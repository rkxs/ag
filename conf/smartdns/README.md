# agconf

```shell
docker run -itd --name xag --network host --privileged=true --restart=always -v ~/:/etc/xray/:rw teddysun/xray:1.2.4

export http_proxy=http://127.0.0.1:10801 https_proxy=http://127.0.0.1:10801 all_proxy=socks5://127.0.0.1:10800
```
```json
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": 10800,
            "listen": "127.0.0.1",
            "protocol": "socks",
            "settings": {
                "udp": true
            }
        },
	{
            "tag": "http-in",
            "protocol": "http",
            "listen": "127.0.0.1",
            "port": 10801
        }
    ],
    "outbounds": [
        {
            "protocol": "trojan",
            "settings": {
                "servers": [
                    {
                        "address": "thk.jobuse.xyz",
                        "port": 443,
                        "password": "B7EA16E7-4519-4D4F-985F-AC6CCEC3B345",
                        "level": 0
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "tls",
                "tlsSettings": {
                    "serverName": "thk.jobuse.xyz"
                }
            }
        }
    ]
}
```
