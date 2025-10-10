# Wifi

Connecting with wifi through cli

1. Find the available wifi networks

```bash
nmcli d wifi list
```

2. Connect to a wifi SSID

Replace the env variables with the correct SSID and password or set the env variables

> Don't forget the space in front if you don't want to add the password to bash history

```bash
 export PASSWORD=superlongpassword
 export SSID=superlongSSID
```


```bash
sudo nmcli wifi connect $SSID password "$PASSWORD"
```

3. Extra options / usefull commands

- Show all known networks

```bash
sudo nmcli c show
```

- Scan and list all wifi networks

```bash
sudo nmcli d wifi
```

or with rescanning

```bash
sudo nmcli d wifi list --rescan yes
```

- Generate QR for currently connected wifi network

```bash
sudo nmcli d  wifi show-password
```

- Change dns

```bash
sudo nmcli c modify $SSID ipv4.dns "1.1.1.1,9.9.9.9"
```
