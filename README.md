# Unifix
This repository contains all the files for all the [Unifix servers](https://steamcommunity.com/groups/UnifixServers).

### Configs
- ZoneMod 1.9.5
- NextMod 1.0.4
- SkeetMod 0.0.2
- Promod Elite 1.1
- Equilibrium 3.0c
- OpenMod 2
- SavageMod 0.0.3
- Scavhunt
- Scavogl
- HardCoop


## Install Steps

### Installing Prerequisites
- A clean installation of **Ubuntu 18.04**
- A user with **sudo** privileges

### 1) Install steam, L4D2 server and clone this repository
- Login as any user with sudo privileges
- Put the script below in a file named `server_install`
- You can use `nano server_install` to do that
- Run it with `sudo bash server_install`

```bash
# Libs and apps
dpkg --add-architecture i386
apt-get update -y && apt-get upgrade -y
apt-get install -y libc6:i386
apt-get install -y lib32gcc1
apt-get install -y lib32z1
apt-get install -y git

# Install steam and L4D2
chmod -R 777 .
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
cp Unifix/cfg/server.cfg serverconfigs/cfg
mkdir -p server/addons/sourcemod/configs/sourcebans/
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
'rm ../server/left4dead2/cfg/generalfixes.cfg' \
'rm ../server/left4dead2/cfg/sharedplugins.cfg' \
'rm ../server/left4dead2/host.txt' \
'rm ../server/left4dead2/motd.txt' \
'cp -r * ../server/left4dead2/' \
'git reset HEAD --hard' \
'cd ..' \
'cd serverconfigs' \
'cp -r * ../server/left4dead2/' \
'cd ..' \
'chmod -R 777 server' \
> server_update
chmod u+x server_update
chmod -R 777 server
```

### 2) Edit Configuration Files
- Edit `serverconfigs/cfg/server.cfg` and set a proper hostname, rcon password, steam groups id and "sn_main_name" in line 76 (set the same as hostame)
- Edit `serverconfigs/addons/sourcemod/configs/databeses.cfg` and set the mysql password
- Edit `serverconfigs/addons/sourcemod/configs/sourcebans/sourcebans.cfg` and set the sourcebans ServerID

### 3) Start the Server
- Run the server with `bash server_start`

### 4) Update
- Update server files when necessary using `sudo bash server_update`
