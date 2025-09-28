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

