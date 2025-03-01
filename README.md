# udemy_led_demo

LED Demo Using BLoC

## Set a static IP address for your Pi
All of this will be done in terminal at command line

- Update and upgrade your Linux
```
sudo apt update
sudo apt upgrade -y
```
- Get your current Pi IP address
```
hostname -I
```
- Get your router's IP address
```
ip r
```
- Get the IP address of your DNS server
```
grep "namesever" /etc/resolv.conf
```
- Open /etc/dhcpcd.conf for editing in nano
Replace the comments in brackets in the box below with the correct information. Interface will be either wlan0 for Wi-Fi or eth0 for Ethernet.
```
nano /etc/dhcpcd.conf
```
Replace the comments in brackets in the box below with the correct information. Interface will be either wlan0 for Wi-Fi or eth0 for Ethernet.

``
interface [INTERFACE]
static_routers=[ROUTER IP]
static domain_name_servers=[DNS IP]
static ip_address=[STATIC IP ADDRESS YOU WANT]/24
``
Here is a typical layout - change to your info!

``
interface wlan0
static_routers=192.168.7.1
static domain_name_servers=192.168.1.1
static ip_address=192.168.7.121/24
``

You may wish to substitute "inform" for "static" on the last line. Using inform means that the Raspberry Pi will attempt to get the IP address you requested, but if it's not available, it will choose another. If you use static, it will have no IP v4 address at all if the requested one is in use.
- Reboot
```
sudo reboot
```

## Install Mosquitto MqTT Broker
- Update and upgrade your Linux
```
sudo apt update
sudo apt upgrade
```
- Install Mosquitto on the Pi

```
sudo apt install mosquitto mosquitto-clients -y
```
- Enable Mosquitto
```
sudo systemctl enable mosquitto
```
- Start Mosquitto
```
sudo systemctl start mosquitto
```
- Verify that Mosquito is running
```
sudo systemctl status mosquitto
```
- The response will include: 
``
Active: active (running)
``
- Ensure Mosquitto starts on boot:
- Reboot the Pi
```
sudo reboot
```
- After the reboot, verify Mosquitto is running:
```
sudo systemctl status mosquitto
```
- The response will include: 
``
Active: active (running)
``

- Check open ports - run this command:
```
sudo netstat -tulnp | grep mosquitto

```
The response should include:
``
tcp        0      0 0.0.0.0:1883            0.0.0.0:*               LISTEN      884/mosquitto  
``
- Find your Pi's local  IP adress
```
hostname -I
```
- Create a custom Mosquitto config file
```
sudo nano /etc/mosquitto/conf.d/local.conf
```
- Add these lines:
```
listener 1883
allow_anonymous true
```
- You will need to restart Mosquitto:
```
sudo systemctl restart mosquitto
```
- Verify Mosquitto is listening on all interfaces:
```
sudo netstat -tulnp | grep mosquitto
```
The response should include:
``
tcp        0      0 0.0.0.0:1883            0.0.0.0:*               LISTEN      884/mosquitto  
``

## Local Pi test using two terminal windows:
- Terminal 1 (start an MQTT subscriber)
```
mosquitto_sub -h localhost -t "test/topic"
```
- Terminal 2 (publish a test message)
```
mosquitto_pub -h localhost -t "test/topic" -m "Hello from Pi MQTT!"
```
- If "Hello from Pi MQTT!" appears in Terminal 1, Mosquitto is working locally.

## Test MQTT from Another Device
- On the other device:
```
mosquitto_sub -h 192.168.1.202 -t "test/topic"
```
- On the Raspberry Pi:
```
mosquitto_pub -h localhost -t "test/topic" -m "Hello from Raspberry Pi!"
```
- If the message appears on the other device, Mosquitto is fully network-accessible! 