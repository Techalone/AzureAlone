# TP2 RENDU : Aller plus loing aveceuh Azure

## I. Network Security Group

### 2. Ajouter un NSG au déploiement

Voici la configuration de la partie NSG :

- *resource "azurerm_network_security_group" "main-2" {
  name                = "network-security-group"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name*

 - *security_rule {
    name                       = "Allow-SSH-home"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = *"${var.my_public_ip}/32"* **elle est déclaré dans le fichier variables.tf** 

    *destination_address_prefix = "*"*
  }

 - *tags = {
    environment = "Production"
  }
}* 
### 3. Proofs !

#### Prouver que ça fonctionne, rendu attendu :

*PS C:\Users\Aloné VAITANAKI> ssh alonetp@4.178.182.39
The authenticity of host '4.178.182.39 (4.178.182.39)' can't be established.
ED25519 key fingerprint is SHA256:m9snuyOomkr72tS4d9nJExwDbnj18vcFa5O3azZifvs.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '4.178.182.39' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1089-azure x86_64)*






azurerm_linux_virtual_machine.main: Creation complete after 50s [id=/subscriptions/bonjourmonchat/resourceGroups/terraformalone/providers/Microsoft.Compute/virtualMachines/super-vm]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.


PS F:\CLOUD COMPUTING\Azure_AZ104\TP2> az vm show --resource-group terraformalone --name super-vm
{
  "additionalCapabilities": null,
  "applicationProfile": null,
  "availabilitySet": null,
  "billingProfile": null,
  "capacityReservation": null,
  "diagnosticsProfile": {
    "bootDiagnostics": {
      "enabled": false,
      "storageUri": null
    }
  },
  "etag": "\"1\"",
  "evictionPolicy": null,
  "extendedLocation": null,
  "extensionsTimeBudget": "PT1H30M",
  "hardwareProfile": {
    "vmSize": "Standard_B1s",
    "vmSizeProperties": null
  },
  "host": null,
  "hostGroup": null,
  "id": "/subscriptions/bonjourmonchat/resourceGroups/terraformalone/providers/Microsoft.Compute/virtualMachines/super-vm",
  "identity": null,
  "instanceView": null,
  "licenseType": null,
  "location": "francecentral",
  "managedBy": null,
  "name": "super-vm",
  "networkProfile": {
    "networkApiVersion": null,
    "networkInterfaceConfigurations": null,
    "networkInterfaces": [
      {
        "deleteOption": null,
        "id": "/subscriptions/bonjourmonchat/resourceGroups/terraformalone/providers/Microsoft.Network/networkInterfaces/vm-nic",
        "primary": true,
        "resourceGroup": "terraformalone"
      }
    ]
  },
  "osProfile": {
    "adminPassword": null,
    "adminUsername": "alonetp",
    "allowExtensionOperations": true,
    "computerName": "super-vm",
    "customData": null,
    "linuxConfiguration": {
      "disablePasswordAuthentication": true,
      "enableVmAgentPlatformUpdates": null,
      "patchSettings": {
        "assessmentMode": "ImageDefault",
        "automaticByPlatformSettings": null,
        "patchMode": "ImageDefault"
      },
      "provisionVmAgent": true,
      "ssh": {
        "publicKeys": [
          {
            "keyData": "ssh-ed25519 bonjourmonchat aloné vaitanaki@DESKTOP-0BAR317\r\n",
            "path": "/home/alonetp/.ssh/authorized_keys"
          }
        ]
      }
    },
    "requireGuestProvisionSignal": true,
    "secrets": [],
    "windowsConfiguration": null
  },
  "placement": null,
  "plan": null,
  "platformFaultDomain": null,
  "priority": "Regular",
  "provisioningState": "Succeeded",
  "proximityPlacementGroup": null,
  "resourceGroup": "terraformalone",
  "resources": null,
  "scheduledEventsPolicy": null,
  "scheduledEventsProfile": null,
  "securityProfile": null,
  "storageProfile": {
    "alignRegionalDisksToVmZone": null,
    "dataDisks": [],
    "diskControllerType": null,
    "imageReference": {
      "communityGalleryImageId": null,
      "exactVersion": "20.04.202505200",
      "id": null,
      "offer": "0001-com-ubuntu-server-focal",
      "publisher": "Canonical",
      "sharedGalleryImageId": null,
      "sku": "20_04-lts",
      "version": "latest"
    },
    "osDisk": {
      "caching": "ReadWrite",
      "createOption": "FromImage",
      "deleteOption": "Detach",
      "diffDiskSettings": null,
      "diskSizeGb": 30,
      "encryptionSettings": null,
      "image": null,
      "managedDisk": {
        "diskEncryptionSet": null,
        "id": "/subscriptions/bonjourmonchat/resourceGroups/terraformalone/providers/Microsoft.Compute/disks/vm-os-disk",
        "resourceGroup": "terraformalone",
        "securityProfile": null,
        "storageAccountType": "Standard_LRS"
      },
      "name": "vm-os-disk",
      "osType": "Linux",
      "vhd": null,
      "writeAcceleratorEnabled": false
    }
  },
  "tags": {},
  "timeCreated": "2025-09-09T17:05:53.864100+00:00",
  "type": "Microsoft.Compute/virtualMachines",
  "userData": null,
  "virtualMachineScaleSet": null,
  "vmId": "bonjourmonchat",
  "zones": null
}
PS F:\CLOUD COMPUTING\Azure_AZ104\TP2> 


#### changement de port :

Sep 14 15:36:21 super-vm systemd[1]: Starting OpenBSD Secure Shell server...
Sep 14 15:36:21 super-vm sshd[1770]: Server listening on 0.0.0.0 port 2222.
Sep 14 15:36:21 super-vm sshd[1770]: Server listening on :: port 2222.
Sep 14 15:36:21 super-vm systemd[1]: Started OpenBSD Secure Shell server.
alonetp@super-vm:/etc/ssh$ ss -tlnp
State         Recv-Q        Send-Q               Local Address:Port               Peer Address:Port       Process
LISTEN        0             4096                 127.0.0.53%lo:53                      0.0.0.0:*
LISTEN        0             128                        0.0.0.0:2222                    0.0.0.0:*
LISTEN        0             128                           [::]:2222                       [::]:*


PS C:\Users\Aloné VAITANAKI> ssh alonetp@4.211.202.79 -p 2222
ssh: connect to host 4.211.202.79 port 2222: Connection timed out

## II. Un ptit nom DNS

### 1. Adapter le plan Terraform

Ajout dans le main.tf :   domain_name_label = "chouchou"  # le sous-domaine

**🌞 Donner un nom DNS à votre VM**

PS F:\CLOUD COMPUTING\Azure_AZ104\TP2> terraform state show azurerm_public_ip.main
azurerm_public_ip.main:
resource "azurerm_public_ip" "main" {
    allocation_method       = "Static"
    ddos_protection_mode    = "VirtualNetworkInherited"
    domain_name_label       = "chouchou"
    domain_name_label_scope = null
    edge_zone               = null
    fqdn                    = "chouchou.francecentral.cloudapp.azure.com"


### 2. Ajouter un output custom à terraform apply


output "public_ip" {
  description = "Adresse IP publique de la VM"
  value       = azurerm_public_ip.main.ip_address
}

output "public_dns" {
  description = "Nom DNS complet de la VM"
  value       = azurerm_public_ip.main.fqdn
}

### 3. Proooofs !

#### la sortie du terraform apply (ce qu'affiche votre outputs.tf)

Outputs:

public_dns = "chouchou.francecentral.cloudapp.azure.com"

public_ip = "20.19.160.140"

#### une commande ssh fonctionnelle vers le nom de domaine (pas l'IP)

PS C:\Users\Aloné VAITANAKI> ssh alonetp@chouchou.francecentral.cloudapp.azure.com
The authenticity of host 'chouchou.francecentral.cloudapp.azure.com (20.19.160.140)' can't be established.
ED25519 key fingerprint is SHA256:stDvDhdSBPDtleyXUUeGhqEJ6R/s3k3jfW+BFA9u5wo.
This host key is known by the following other names/addresses:
    C:\Users\Aloné VAITANAKI/.ssh/known_hosts:14: 20.19.160.140
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'chouchou.francecentral.cloudapp.azure.com' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1089-azure x86_64)

## III. Blob storage




### 2. Let's go

**🌞 Compléter votre plan Terraform pour déployer du Blob Storage pour votre VM**


Jai eu Un blocage ici :(