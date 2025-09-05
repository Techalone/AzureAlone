# TP1 RENDU

Rendu du TP 1.

---

## I Prérequis

### 2 . Une paire de clé SSH 

**A. Choix de l'algorithme de chiffrement** 

Voici le lien de la raison de ne pas utiliser une paire de clé RSA :https://docs.callgoose.com/general/ed25519_vs_other_keys_for_ssh

**B. Génération de votre paire de clés**

*La commande pour générer la paire de clé sous le nom : cloud_tp1*

- ssh-keygen -t ed25519
Generating public/private ed25519 key pair.
Enter file in which to save the key (C:\Users\user/.ssh/id_ed25519): cloud_tp1


- Enter passphrase (empty for no passphrase):

- Enter same passphrase again:

- Your identification has been saved in cloud_tp1
Your public key has been saved in cloud_tp1.pub
The key fingerprint is:
SHA256:0tossQoe1d0JxW607SLZb6RtkRhYqY8rKca+JmzbpVw aloné vaitanaki@DESKTOP-0BAR317

**C. AGENT SSH**

*1 : Install agent SSH*

Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

*2 : Activer le service SSH-Agent*

Get-Service ssh-agent

*3 : Ajouter ta clé privée à l’agent*

ssh-add $env:USERPROFILE\.ssh\id_ed25519

Pour vérification : **ssh-add -l**

Résultat : *PS C:\WINDOWS\system32> ssh-add -l
256 SHA256:rgfNPLWNdTLN5/s1xCczQpE9mMHrPTiq7o8NqyUjGjo alon├® vaitanaki@DESKTOP-0BAR317 (ED25519)*

## II Spaw des VM's

### 1. Depuis la WebUI

Voici la preuve que je suis coonecté sur la VM via SSH :

*PS C:\Users\Aloné VAITANAKI> **ssh alonetp@51.103.97.245**
The authenticity of host '51.103.97.245 (51.103.97.245)' can't be established.
ED25519 key fingerprint is SHA256:NTFiJZE2I6irzC2K8eQzhBCtf+paTW8mb2AbwhuJEmo.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '51.103.97.245' (ED25519) to the list of known hosts.
Welcome to Ubuntu 24.04.3 LTS (GNU/Linux 6.11.0-1018-azure x86_64)*

### 2. az : a programmatic approach

 **Créez une VM depuis le Azure CLI**

*az vm create -g EFREITP -n Vm2 --image Ubuntu2204 --size Standard_B1s --admin-username alonetp --ssh-key-values ~/.ssh/id_ed25519.pub --location francecentral*

  - *"fqdns": "",
  "id": "/subscriptions/835f81dd-5303-44a4-addb-5743acc93b8e/resourceGroups/EFREITP/providers/Microsoft.Compute/virtualMachines/Vm2",
  "location": "francecentral",
  "macAddress": "60-45-BD-19-EA-A2",
  "powerState": "VM running",
  "privateIpAddress": "10.0.0.5",
  "publicIpAddress": "4.233.58.126",
  "resourceGroup": "EFREITP"*

**Assurez-vous que vous pouvez vous connecter à la VM en SSH sur son IP publique**

*PS C:\Users\Aloné VAITANAKI> **ssh alonetp@4.233.58.126**
The authenticity of host '4.233.58.126 (4.233.58.126)' can't be established.
ED25519 key fingerprint is SHA256:uzwtF/SOegwY7thMM5djeDcapSTkLYd1lpbgEozD86s.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? y
Please type 'yes', 'no' or the fingerprint: yes
Warning: Permanently added **'4.233.58.126'** (ED25519) to the list of known hosts.
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1031-azure x86_64)*

**Une fois connecté, prouvez la présence...**

Voici la preuve de la présence du service **walinuxagent.service**

*alonetp@Vm2:~$ **systemctl list-unit-files | grep walinuxagent***

*walinuxagent-network-setup.service     enabled         enabled*

*walinuxagent.service                   enabled         enabled*

Voici la preuve de la présence du service **cloud-init.service**

alonetp@Vm2:~$ **sudo systemctl status cloud-init.service**
● cloud-init.service - Cloud-init: Network Stage
     Loaded: loaded (/lib/systemd/system/cloud-init.service; enabled; vendor preset: enabled)
     **Active: active (exited)** since Fri 2025-09-05 11:47:48 UTC; 14min ago
   Main PID: 506 (code=exited, status=0/SUCCESS)
        CPU: 1.640s

### 3. Terraforming planets infrastructures

Utilisez Terraform pour créer une VM dans Azure




---



- *Italique*
- **Gras**
- ~~Barré~~

---

## 3. Listes

### Liste à puces :
- Élément 1
- Élément 2
  - Sous-élément

### Liste numérotée :
1. Premier
2. Deuxième
3. Troisième

---

