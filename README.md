# Unifix
This repository contains all the files for all the [Unifix servers](https://steamcommunity.com/groups/UnifixServers).

### Configs
- ZoneMod 1.9.9
- NextMod 1.0.5
- ProMod Elite 1.1
- Equilibrium 3.0c
- Apex 1.1.2


## Install Steps

### Installing Prerequisites
- A clean installation of **Ubuntu 18.04**
- A user with **sudo** privileges

### 1) Install libraries and git
- Login as root or any user with sudo privileges and put the script below in a file named `server_pre`
- You can use `nano server_pre` to do that
- Run it with `bash server_pre` **(`sudo bash server_pre` if you aren't logged in as root)**

```bash
# Libs and apps
dpkg --add-architecture i386
apt-get update -y && apt-get upgrade -y
apt-get install -y libc6:i386
apt-get install -y lib32gcc1
apt-get install -y lib32z1
apt-get install -y git
```

### 2) Install steam, L4D2 server and clone this repository
- Login as the user that will start the server
- Put the script below in a file named `server_install`
- Run it with `bash server_install`

```bash
# Install steam and L4D2
wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
tar -xvzf steamcmd_linux.tar.gz
./steamcmd.sh << STEAM
login anonymous
force_install_dir ./server
app_update 222860 validate
quit
STEAM

# Server download
git clone https://github.com/misdocumeno/Unifix
cp -r Unifix/* server/left4dead2/

# Screen script
printf 'screen -S Unifix ./server/srcds_run -tickrate 100 +map "c10m1_caves" +sv_clockcorrection_msecs 15 -timeout 10 +ip 0.0.0.0 -port 27015 +precache_all_survivors 1' > server_start
chmod u+x server_start

# Per server config backup
# Edit these files instead of the server ones
# This will be copied to the server directory when update
mkdir -p serverconfigs/cfg/
cp Unifix/cfg/server.cfg serverconfigs/cfg/
mkdir -p serverconfigs/cfg/sourcemod/
cp Unifix/cfg/sourcemod/vpn_ip.cfg serverconfigs/cfg/sourcemod/vpn_ip.cfg
mkdir -p serverconfigs/addons/sourcemod/configs/sourcebans/
cp Unifix/addons/sourcemod/configs/sourcebans/sourcebans.cfg serverconfigs/addons/sourcemod/configs/sourcebans/
cp Unifix/addons/sourcemod/configs/databases.cfg serverconfigs/addons/sourcemod/configs/

# Update script
printf '%s\n' \
'killall screen' \
'cd Unifix' \
'git pull' \
'rm -rf ../server/left4dead2/addons/sourcemod/' \
'rm -rf ../server/left4dead2/cfg/sourcemod/' \
'rm -rf ../server/left4dead2/cfg/cfgogl/' \
'rm -rf ../server/left4dead2/cfg/stripper/' \
'rm ../server/left4dead2/cfg/generalfixes.cfg' \
'rm ../server/left4dead2/cfg/sharedplugins.cfg' \
'rm ../server/left4dead2/cfg/server.cfg' \
'rm ../server/left4dead2/host.txt' \
'rm ../server/left4dead2/motd.txt' \
'cp -r * ../server/left4dead2/' \
'git reset HEAD --hard' \
'cd ..' \
'cd serverconfigs' \
'rm ../server/left4dead2/cfg/server.cfg' \
'rm ../server/left4dead2/cfg/sourcemod/vpn_ip.cfg' \
'rm ../server/left4dead2/cfg/sourcemod/configs/databases.cfg' \
'rm ../server/left4dead2/cfg/sourcemod/configs/sourcebans/sourcebans.cfg' \
'cp -r * ../server/left4dead2/' \
> server_update
chmod u+x server_update
```

### 3) Edit Configuration Files
- Edit `serverconfigs/cfg/server.cfg` and set a proper hostname, rcon password, steam groups id and "sn_main_name" in line 76 (set the same as hostame)
- Edit `serverconfigs/addons/sourcemod/configs/databeses.cfg` and set the mysql password
- Edit `serverconfigs/addons/sourcemod/configs/sourcebans/sourcebans.cfg` and set the sourcebans ServerID
- Run the update script to copy those files into the server path

### 4) Start the Server
- Run the server with `bash server_start`

### 5) Update
- Update server files when necessary using `bash server_update`
