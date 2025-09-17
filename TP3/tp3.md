# TP3 : Cloud privé
## I. Présentation du lab
### 1. Architecture
**🌞 Allumez les VMs et effectuez la conf élémentaire :**

- Ping frontend.one vers kvm1.one
```
[adm-avaitanaki@frontend ~]$ ping kvm1
PING kvm1.one (10.3.1.11) 56(84) bytes of data.
64 bytes from kvm1.one (10.3.1.11): icmp_seq=1 ttl=64 time=0.665 ms
64 bytes from kvm1.one (10.3.1.11): icmp_seq=2 ttl=64 time=1.55 ms
^C
--- kvm1.one ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.665/1.109/1.553/0.444 ms

```


- Ping frontend.one vers kvm2.one
```
[adm-avaitanaki@frontend ~]$ ping kvm2
PING kvm2.one (10.3.1.12) 56(84) bytes of data.
64 bytes from kvm2.one (10.3.1.12): icmp_seq=1 ttl=64 time=0.750 ms
64 bytes from kvm2.one (10.3.1.12): icmp_seq=2 ttl=64 time=1.66 ms
64 bytes from kvm2.one (10.3.1.12): icmp_seq=3 ttl=64 time=0.446 ms
^C
--- kvm2.one ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2061ms
rtt min/avg/max/mdev = 0.446/0.952/1.661/0.516 ms
[adm-avaitanaki@frontend ~]$
```


## II. Setup

### II.1. Setup Frontend

### A. Database

**🌞 Installer un serveur MySQL**

**ajouter un dépôt :**
```
- adm-avaitanaki@frontend:~$ wget https://dev.mysql.com/get/mysql80-community-release-el9-5.noarch.rpm
```
```
- adm-avaitanaki@frontend:~$ sudo rpm -Uvh mysql80-community-release-el9-5.noarch.rpm

[sudo] Mot de passe de adm-avaitanaki :
attention : mysql80-community-release-el9-5.noarch.rpm: Header V4 RSA/SHA256 Signature, clé ID 3a79bd29: NOKEY
Vérification...                      ################################# [100%]
Préparation...                       ################################# [100%]
Mise à jour / installation...
```

**installer le paquet qui contient le serveur MySQL depuis ce nouveau dépôt :**
```
- adm-avaitanaki@frontend:~$ dnf repolist enabled | grep mysql

mysql-connectors-community              MySQL Connectors Community
mysql-tools-community                   MySQL Tools Community
mysql80-community                       MySQL 8.0 Community Server
adm-avaitanaki@frontend:~$ dnf search mysql
```
```
- adm-avaitanaki@frontend:~$ sudo dnf install mysql-community-server -y

Installé:
  mysql-community-client-8.0.43-1.el9.x86_64             mysql-community-client-plugins-8.0.43-1.el9.x86_64
  mysql-community-common-8.0.43-1.el9.x86_64             mysql-community-icu-data-files-8.0.43-1.el9.x86_64
  mysql-community-libs-8.0.43-1.el9.x86_64               mysql-community-server-8.0.43-1.el9.x86_64

Terminé !
```

**🌞 Démarrer le serveur MySQL**

```

adm-avaitanaki@frontend:~$ sudo systemctl start mysqld

adm-avaitanaki@frontend:~$ sudo systemctl enable mysqld

adm-avaitanaki@frontend:~$ sudo systemctl status mysqld

● mysqld.service - MySQL Server
     Loaded: loaded (/usr/lib/systemd/system/mysqld.service; enabled; preset: disabled)
     Active: active (running) since Mon 2025-09-15 13:53:27 CEST; 24s ago
 Invocation: c3906bc4f11b4365a3406376b250a498
```

 **🌞 Setup MySQL**

```
 adm-avaitanaki@frontend:~$ sudo grep 'temporary password' /var/log/mysqld.log
2025-09-15T11:53:13.727970Z 6 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: wo)xzAs?:3gi
adm-avaitanaki@frontend:~$ mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.43

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'bonjourmonchat';
Query OK, 0 rows affected (0,03 sec)

mysql> CREATE USER 'oneadmin' IDENTIFIED BY 'bonjourmonchat';
Query OK, 0 rows affected (0,04 sec)

mysql> CREATE DATABASE opennebula;
Query OK, 1 row affected (0,02 sec)

mysql> GRANT ALL PRIVILEGES ON opennebula.* TO 'oneadmin';
Query OK, 0 rows affected (0,02 sec)

mysql> SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
Query OK, 0 rows affected (0,00 sec)

mysql> exit
Bye
```

### B. OpenNebula

**🌞 Ajouter les dépôts Open Nebula**

```

- [adm-avaitanaki@frontend ~]$ sudo nano /etc/yum.repos.d/opennebula.repo
- [adm-avaitanaki@frontend ~]$ sudo dnf makecache -y

Extra Packages for Enterprise Linux 9 - x86  63 kB/s |  39 kB     00:00
Extra Packages for Enterprise Linux 9 openh 2.2 kB/s | 993  B     00:00
MySQL 8.0 Community Server                   32 kB/s | 3.0 kB     00:00
MySQL Connectors Community                   44 kB/s | 3.0 kB     00:00
MySQL Tools Community                        44 kB/s | 3.0 kB     00:00
OpenNebula Community Edition                2.2 kB/s | 833  B     00:00
OpenNebula Community Edition                 22 kB/s | 3.1 kB     00:00
```

**🌞 Installer OpenNebula**

```
- [adm-avaitanaki@frontend ~]$ sudo dnf install opennebula opennebula-sunstone opennebula-fireedge -y

Last metadata expiration check: 0:00:12 ago on Mon 15 Sep 2025 09:18:58 AM EDT.
Dependencies resolved.
============================================================================
 Package                   Arch   Version                  Repository  Size
============================================================================
Installing:
 opennebula                x86_64 6.10.0.1-1.el9           opennebula  10 M
 opennebula-fireedge       x86_64 6.10.0.1-1.el9           opennebula  46 M
 opennebula-sunstone       noarch 6.10.0.1-1.el9           opennebula  29 M
```

**🌞 Configuration OpenNebula**

```
- [adm-avaitanaki@frontend ~]$ sudo nano /etc/one/oned.conf
- [adm-avaitanaki@frontend ~]$ sudo su - oneadmin
```

# Sample configuration for MySQL

```
DB = [ BACKEND = "mysql",
       SERVER  = "localhost",
       PORT    = 0,
       USER    = "oneadmin",
       PASSWD  = "bonjourmonchat",
       DB_NAME = "opennebula",
       CONNECTIONS = 25,
       COMPARE_BINARY = "no" ]
       
```

**🌞 Créer un user pour se log sur la WebUI OpenNebula**
```

- [oneadmin@frontend ~]$ echo "toto:super_password" > /var/lib/one/.one/one_auth

- [oneadmin@frontend ~]$ chmod 600 /var/lib/one/.one/one_auth

- [oneadmin@frontend ~]$ sudo systemctl start opennebula
```

**🌞 Démarrer les services OpenNebula**

*démarrez les services opennebula, opennebula-sunstone*

```

- [adm-avaitanaki@frontend ~]$ sudo systemctl start opennebula

- [adm-avaitanaki@frontend ~]$ sudo systemctl start opennebula-sunstone

- [adm-avaitanaki@frontend ~]$ sudo systemctl start opennebula-fireedge
```
*activez-les aussi au démarrage de la machine*

```
- [adm-avaitanaki@frontend ~]$ sudo systemctl enable opennebula

Created symlink /etc/systemd/system/multi-user.target.wants/opennebula.service → /usr/lib/systemd/system/opennebula.service.

- [adm-avaitanaki@frontend ~]$ sudo systemctl enable opennebula-sunstone

Created symlink /etc/systemd/system/multi-user.target.wants/opennebula-sunstone.service → /usr/lib/systemd/system/opennebula-sunstone.service.

- [adm-avaitanaki@frontend ~]$ sudo systemctl enable opennebula-fireedge

Created symlink /etc/systemd/system/multi-user.target.wants/opennebula-fireedge.service → /usr/lib/systemd/system/opennebula-fireedge.service.
```

## C. Conf système

### 🌞 Ouverture firewall

```
- [adm-avaitanaki@frontend ~]$ sudo firewall-cmd --permanent --add-port=9869/tcp
success

- [adm-avaitanaki@frontend ~]$ sudo firewall-cmd --permanent --add-port=22/tcp
success

- [adm-avaitanaki@frontend ~]$ sudo firewall-cmd --permanent --add-port=2633/tcp
success

- [adm-avaitanaki@frontend ~]$ sudo firewall-cmd --permanent --add-port=4124/tcp
success

- [adm-avaitanaki@frontend ~]$ sudo firewall-cmd --permanent --add-port=4124/udp
success

- [adm-avaitanaki@frontend ~]$ sudo firewall-cmd --permanent --add-port=29876/tcp
success

- [adm-avaitanaki@frontend ~]$ sudo firewall-cmd --reload
success

- [adm-avaitanaki@frontend ~]$ sudo firewall-cmd --list-ports
22/tcp 2633/tcp 4124/tcp 9869/tcp 29876/tcp 4124/udp
```
## D. Test

**CONNEXION OK sur WebUi**

## II.2. Noeuds KVM

### A. KVM

### 🌞 Ajouter des dépôts supplémentaires
```
[adm-avaitanaki@kvm1 ~]$ sudo nano /etc/yum.repos.d/opennebula.repo

[opennebula]

name=OpenNebula Community Edition
https://downloads.opennebula.io/repo/6.10/RedHat/9/x86_64
enabled=1

gpgkey=https://downloads.opennebula.io/repo/repo2.key
gpgcheck=1

repo_gpgcheck=1
```



**ajoutez aussi les dépôts du serveur MySQL communautaire**
```
[adm-avaitanaki@kvm1 ~]$ sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-5.noarch.rpm
```

**le RPM de la partie précédente (comme sur le frontend)**

```
[adm-avaitanaki@kvm1 ~]$ sudo rpm -Uvh mysql80-community-release-el9-5.noarch.rpm
warning: mysql80-community-release-el9-5.noarch.rpm: Header V4 RSA/SHA256 Signature, key ID 3a79bd29: NOKEY
Verifying...                                                            (100################################# [100%]
Preparing...                                                            (100################################# [100%]
Updating / installing...
   1:mysql80-community-release-el9-5                                    ( 25################################# [100%]
```

**ajoutez aussi les dépôts EPEL en exécutant :**

```
[adm-avaitanaki@kvm1 ~]$sudo dnf install -y epel-release
OpenNebula Community Edition                1.9 kB/s | 833  B     00:00
OpenNebula Community Edition                 24 kB/s | 3.1 kB     00:00
Importing GPG key 0x906DC27C:
 Userid     : "OpenNebula Repository <contact@opennebula.io>"
 Fingerprint: 0B2D 385C 7C93 04B1 1A03 67B9 05A0 5927 906D C27C
 From       : https://downloads.opennebula.io/repo/repo2.key
OpenNebula Community Edition                1.1 MB/s | 690 kB     00:00
```

### 🌞 Installer les libs MySQL

```
[adm-avaitanaki@kvm1 ~]$ sudo dnf install -y mysql-community-server
MySQL 8.0 Community Server                  2.7 MB/s | 2.7 MB     00:00
MySQL Connectors Community                  342 kB/s |  90 kB     00:00
MySQL Tools Community                       1.4 MB/s | 1.2 MB     00:00
Dependencies resolved.
============================================================================
 Package                        Arch   Version      Repository         Size
============================================================================
Installing:
 mysql-community-server         x86_64 8.0.43-1.el9 mysql80-community  50 M
```

### 🌞 Installer KVM

```
Complete!
[adm-avaitanaki@kvm1 ~]$ sudo dnf install -y opennebula-node-kvm
Last metadata expiration check: 0:00:43 ago on Mon 15 Sep 2025 10:10:06 AM EDT.
Dependencies resolved.
============================================================================
 Package                        Arch   Version             Repository  Size
============================================================================
Installing:
 opennebula-node-kvm            noarch 6.10.0.1-1.el9      opennebula  13 k
```
### 🌞 Dépendances additionnelles
```
[adm-avaitanaki@kvm1 ~]$ sudo dnf install -y genisoimage
[sudo] password for adm-avaitanaki:
Last metadata expiration check: 0:14:29 ago on Mon 15 Sep 2025 10:10:06 AM EDT.
Dependencies resolved.
============================================================================
 Package            Architecture  Version                 Repository   Size
============================================================================
Installing:
 genisoimage        x86_64        1.1.11-48.el9           epel        324 k
Installing dependencies:
 libusal            x86_64        1.1.11-48.el9           epel        137 k

Transaction Summary
============================================================================

```
### 🌞 Démarrer le service libvirtd
```
[adm-avaitanaki@kvm1 ~]$ sudo systemctl start libvirtd
[adm-avaitanaki@kvm1 ~]$ sudo systemctl enable libvirtd
Created symlink /etc/systemd/system/multi-user.target.wants/libvirtd.service → /usr/lib/systemd/system/libvirtd.service.
Created symlink /etc/systemd/system/sockets.target.wants/libvirtd.socket → /usr/lib/systemd/system/libvirtd.socket.
Created symlink /etc/systemd/system/sockets.target.wants/libvirtd-ro.socket → /usr/lib/systemd/system/libvirtd-ro.socket.
Created symlink /etc/systemd/system/sockets.target.wants/libvirtd-admin.socket → /usr/lib/systemd/system/libvirtd-admin.socket.
[adm-avaitanaki@kvm1 ~]$ sudo systemctl status libvirtd
● libvirtd.service - libvirt legacy monolithic daemon
     Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; enabled; pre>
     Active: active (running) since Mon 2025-09-15 10:25:32 EDT; 13s ago
```
# B. Système

### 🌞 Ouverture firewall
```
[adm-avaitanaki@kvm1 ~]$ sudo firewall-cmd --permanent --add-port=22/tcp
success

[adm-avaitanaki@kvm1 ~]$ sudo firewall-cmd --permanent --add-port=8472/udp
success

[adm-avaitanaki@kvm1 ~]$ sudo firewall-cmd --reload
success

[adm-avaitanaki@kvm1 ~]$ sudo firewall-cmd --list-ports
22/tcp 8472/udp
```
### 🌞 Handle SSH


**il faudra déposer la clé publique sur les noeuds KVM**
```
[oneadmin@frontend ~]$ ssh-copy-id oneadmin@10.3.1.11
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/var/lib/one/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
```

**il faudra aussi trust les empreintes des autres serveurs**
```
[oneadmin@frontend ~]$ ssh-keyscan -H 10.3.1.11 >> ~/.ssh/known_hosts
10.3.1.11:22 SSH-2.0-OpenSSH_8.7
10.3.1.11:22 SSH-2.0-OpenSSH_8.7
```
```
[oneadmin@frontend ~]$ ssh oneadmin@kvm1.one
Warning: Permanently added 'kvm1.one' (ED25519) to the list of known hosts.
Last failed login: Mon Sep 15 10:39:02 EDT 2025 from 10.3.1.1 on ssh:notty
There were 3 failed login attempts since the last successful login.
```
# C. Ajout des noeuds au cluster

Ajout OK au cluster 

# 3. Réseau

# II.3. Setup réseau

## B. Création du Virtual Network

NOM : VXLAN-KVM
IPINTERFACE : enp0s8
NETWORK ADDRESS : 192.168.100.0/24
SIZE : 20

## C. Préparer le bridge réseau

### 🌞 Créer et configurer le bridge Linux
```
[adm-avaitanaki@kvm1 ~]$ sudo tee /opt/vxlan.sh > /dev/null <<'EOF'
> ip link delete vxlan_bridge type bridge 2>/dev/null || true
> ip link add name vxlan_bridge type bridge
> ip link set dev vxlan_bridge up
> ip addr add 192.168.100.101/24 dev vxlan_bridge
> firewall-cmd --add-interface=vxlan_bridge --zone=public --permanent
> firewall-cmd --add-masquerade --permanent
> firewall-cmd --reload
> EOF
[adm-avaitanaki@kvm1 ~]$ sudo chmod +x /opt/vxlan.sh
[adm-avaitanaki@kvm1 ~]$ sudo /opt/vxlan.sh
```
```
[adm-avaitanaki@kvm1 ~]$ ip a show vxlan_bridge

6: vxlan_bridge: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 6a:9c:28:a3:6c:18 brd ff:ff:ff:ff:ff:ff
    inet 192.168.100.101/24 scope global vxlan_bridge
       valid_lft forever preferred_lft forever
    inet6 fe80::689c:28ff:fea3:6c18/64 scope link
       valid_lft forever preferred_lft forever
```
```
[adm-avaitanaki@kvm1 ~]$ sudo firewall-cmd --list-interfaces --zone=public

vxlan_bridge enp0s8 enp0s3
```

**un ptit service systemd**
```
[adm-avaitanaki@kvm1 ~]$ sudo tee /etc/systemd/system/vxlan.service > /dev/null <<'EOF'
> [Unit]
Description=Setup VXLAN interface for OpenNebula
After=network.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/bash /opt/vxlan.sh

[Install]
WantedBy=multi-user.target
> EOF
```
```
- [adm-avaitanaki@kvm1 ~]$ sudo systemctl daemon-reload
- [adm-avaitanaki@kvm1 ~]$ sudo systemctl start vxlan
- [adm-avaitanaki@kvm1 ~]$ sudo systemctl enable vxlan

Created symlink /etc/systemd/system/multi-user.target.wants/vxlan.service → /etc/systemd/system/vxlan.service.
[adm-avaitanaki@kvm1 ~]$ systemctl status vxlan
● vxlan.service - Setup VXLAN interface for OpenNebula
     Loaded: loaded (/etc/systemd/system/vxlan.service; enabled; preset: disabled)
     Active: active (exited) since Mon 2025-09-15 11:31:13 EDT; 13s ago

```

# III. Utiliser la plateforme

## ➜ Tester la connectivité à la VM

- *VM1 (Test) IP = 192.168.10.20*

- *interface vxlan_bridge sur **kvm1.one** = 192.168.10.10/24*
```
[adm-avaitanaki@kvm1 ~]$ ping 192.168.100.20
PING 192.168.100.20 (192.168.100.20) 56(84) bytes of data.
64 bytes from 192.168.100.20: icmp_seq=1 ttl=64 time=16.1 ms
64 bytes from 192.168.100.20: icmp_seq=2 ttl=64 time=0.527 ms
^C
--- 192.168.100.20 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1003ms
rtt min/avg/max/mdev = 0.527/8.294/16.061/7.767 ms
```


### IV. Ajouter d'un noeud et VXLAN

### 1. Ajout d'un noeud

#### 🌞 Setup de kvm2.one, à l'identique de kvm1.one excepté :
```
[oneadmin@frontend ~]$ onehost list
  ID NAME                                                                                          CLUSTER    TVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
   1 10.3.1.12                                                                                     default      1    100 / 200 (50%)  768M / 3.6G (21%) on
   0 10.3.1.11                                                                                     default      1    100 / 200 (50%)  768M / 3.6G (21%) on
```

### 2. VM sur le deuxième noeud

#### 🌞 Lancer une deuxième VM

- VM1: 192.168.10.20/24
- VM2: 192.168.10.21/24

```
[oneadmin@frontend ~]$ ssh -J kvm1 root@192.168.100.21
Warning: Permanently added '192.168.100.21' (ED25519) to the list of known hosts.
Activate the web console with: systemctl enable --now cockpit.socket

[root@localhost ~]#
```

### 3. Connectivité entre les VMs

#### 🌞 Les deux VMs doivent pouvoir se ping

- VM2 >>> VM1
```
[root@vm2 ~]# ping vm1
PING vm1.bis (192.168.100.20) 56(84) bytes of data.
64 bytes from vm1.bis (192.168.100.20): icmp_seq=1 ttl=64 time=1.73 ms
64 bytes from vm1.bis (192.168.100.20): icmp_seq=2 ttl=64 time=2.46 ms
64 bytes from vm1.bis (192.168.100.20): icmp_seq=3 ttl=64 time=2.04 ms
64 bytes from vm1.bis (192.168.100.20): icmp_seq=4 ttl=64 time=1.87 ms
^C
--- vm1.bis ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3008ms
rtt min/avg/max/mdev = 1.734/2.027/2.464/0.274 ms
[root@vm2 ~]#
```
- VM1 >>> VM2

```
[root@vm1 ~]# ping vm2
PING vm2.bis (192.168.100.21) 56(84) bytes of data.
64 bytes from vm2.bis (192.168.100.21): icmp_seq=1 ttl=64 time=1.85 ms
64 bytes from vm2.bis (192.168.100.21): icmp_seq=2 ttl=64 time=3.78 ms
64 bytes from vm2.bis (192.168.100.21): icmp_seq=3 ttl=64 time=0.988 ms
64 bytes from vm2.bis (192.168.100.21): icmp_seq=4 ttl=64 time=5.27 ms
64 bytes from vm2.bis (192.168.100.21): icmp_seq=5 ttl=64 time=5.97 ms
^C
--- vm2.bis ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4237ms
rtt min/avg/max/mdev = 0.988/3.573/5.973/1.914 ms
[root@vm1 ~]#

```
### 4. Inspection du trafic

#### 🌞 Téléchargez tcpdump sur l'un des noeuds KVM

```
[adm-avaitanaki@kvm2 ~]$ sudo dnf install tcpdump
Rocky Linux 9 - BaseOS                      9.9 kB/s | 4.1 kB     00:00
Rocky Linux 9 - BaseOS                      2.7 MB/s | 2.5 MB     00:00
Rocky Linux 9 - AppStream                    12 kB/s | 4.5 kB     00:00
Rocky Linux 9 - Extras                      5.3 kB/s | 2.9 kB     00:00
Dependencies resolved.
============================================================================
 Package        Architecture  Version                Repository        Size
============================================================================
Installing:
 tcpdump        x86_64        14:4.99.0-9.el9        appstream        542 k
```
- une qui capture le trafic de l'interface réelle : enp0s8

```
[adm-avaitanaki@kvm2 ~]$ sudo tcpdump -i enp0s8 -w yo1.pcap
[sudo] password for adm-avaitanaki:
dropped privs to tcpdump
tcpdump: listening on enp0s8, link-type EN10MB (Ethernet), snapshot length 262144 bytes
^C30 packets captured
32 packets received by filter
0 packets dropped by kernel
```
- une autre qui capture le trafic de l'interface bridge VXLAN

```
[adm-avaitanaki@kvm2 ~]$ sudo tcpdump -i vxlan_bridge -w yo.pcap
dropped privs to tcpdump
tcpdump: listening on vxlan_bridge, link-type EN10MB (Ethernet), snapshot length 262144 bytes
^C28 packets captured
32 packets received by filter
0 packets dropped by kernel
```

#### ➜ Analysez les deux captures

```
05:42:14.965455 IP 192.168.100.101.43602 > 192.168.100.21.ssh: Flags [.], ack 420, win 594, options [nop,nop,TS val 916006320 ecr 3624990448], length 0
05:42:15.953797 IP 192.168.100.21 > 192.168.100.20: ICMP echo request, id 7, seq 51, length 64
05:42:15.956630 IP 192.168.100.20 > 192.168.100.21: ICMP echo reply, id 7, seq 51, length 64
05:42:15.958741 IP 192.168.100.21.ssh > 192.168.100.101.43602: Flags [P.], seq 420:536, ack 1, win 249, options [nop,nop,TS val 3624991445 ecr 916006320], length 116
```

```
IP 192.168.100.21.ssh > 192.168.100.101.43602: Flags [P.], seq 152:268, ack 1, win 249, options [nop,nop,TS val 3624969368 ecr 915984215], length 116
05:41:53.883097 IP kvm1.one.46181 > kvm2.one.otv: OTV, flags [I] (0x08), overlay 0, instance 5
IP 192.168.100.101.43602 > 192.168.100.21.ssh: Flags [.], ack 268, win 594, options [nop,nop,TS val 915985238 ecr 3624969368], length 0
05:41:53.885606 IP kvm2.one.37930 > kvm1.one.otv: OTV, flags [I] (0x08), overlay 0, instance 5

```
