# variables.tf

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  default     = "East US"
  description = "Azure region"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
}

variable "public_key_path" {
  type        = string
  description = "Path to your SSH public key"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "my_public_ip" {
  type        = string
  description = "Mon IP publique actuelle"
}

variable "storage_account_name" {
  description = "Nom du compte de stockage Azure"
  type        = string
}

variable "storage_container_name" {
  description = "Nom du conteneur Blob"
  type        = string
}
