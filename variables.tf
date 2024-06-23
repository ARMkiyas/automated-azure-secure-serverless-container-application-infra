variable "resGroup" {
  type        = string
  default     = "cloudcareinfra"
  description = "resource group name"

}

variable "locaion" {
  type        = string
  default     = "eastus"
  description = "location of the resource group"
}


variable "env" {
  type        = string
  default     = "staging"
  description = "environment of the resource group"

}


variable "vnet_name" {
  type        = string
  default     = "vnet"
  description = "vnet name"

}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "vnet address space"

}


variable "private_dns_zone" {

  type        = string
  default     = "example.com"
  description = "private dns zone name"
}

variable "containerAPP_subnet" {
  type = object({
    name           = string
    address_prefix = list(string)
  })
  default = {
    name           = "containerAPP-subnet"
    address_prefix = ["10.0.1.0/24"]
  }
  description = " containerAPP subnet"
}


variable "db_subnet" {
  type = object({
    name           = string
    address_prefix = list(string)
  })
  default = {
    name           = "db-subnet"
    address_prefix = ["10.0.2.0/24"]
  }
  description = "database subnet"

}

variable "other_services_subnet" {
  type = object({
    name           = string
    address_prefix = list(string)
  })
  default = {
    name           = "other-service-subnet"
    address_prefix = ["10.0.3.0/24"]
  }

  description = "other services subnet"


}


variable "con-app-name" {
  type        = string
  default     = "cloudcareapp"
  description = "container app name"
}

variable "image" {
  type     = string
  default  = ""
  nullable = false
}


variable "db-server-name" {
  type     = string
  default  = "cloudcaredb-server"
  nullable = false
}
variable "db_admin" {
  type      = string
  nullable  = false
  sensitive = true

}

variable "db_admin_password" {
  type      = string
  nullable  = false
  sensitive = true

}


variable "db_sku" {
  type        = string
  default     = "B_Standard_B1ms"
  description = "value of the sku for the database server"
}

variable "db_version" {
  type        = string
  default     = "15"
  description = "version of the database server"

}


variable "storage_account_name" {
  type        = string
  default     = "cloudcarestorage"
  description = "storage account name"

}

variable "storage_account_tier" {
  type        = string
  default     = "Standard"
  description = "storage account tier"
}


variable "storage_replication_type" {
  type        = string
  default     = "LRS"
  description = "storage account replication type"

}

variable "storage_conatiner_name" {
  type        = string
  default     = "cloudcarecontainer"
  description = "storage container name"

}


variable "sms_queue_name" {
  type        = string
  default     = "sms-to-send"
  description = "sms queue name"

}

variable "email_queue_name" {
  type        = string
  default     = "email-to-send"
  description = "email queue name"

}


variable "kayvaultname" {
  type        = string
  default     = "keyvault"
  description = "key vault  "
}

variable "db_name" {
  type        = string
  default     = "cloudcaredb"
  description = "database name"

}


variable "keyvault_secrets" {
  type = list(object({
    name  = string
    value = string
  }))

  default     = []
  description = "keyvault secrets"

}
