variable "location" {
  default     = "Australia East"
  description = "Azure location"
}

variable "project_name" {
  default     = "iacs"
  description = "Project short name"
}

variable "resource_group_name" {
  default     = "rg-iacs"
  description = "Resource Group name"
}

variable "storage_account_name" {
  default     = "iacsstorageacct"
  description = "Globally unique storage account name"
}

variable "sql_server_name" {
  default     = "iacssqlserver"
  description = "SQL Server name"
}

variable "sql_db_name" {
  default     = "iacsdb"
  description = "SQL DB name"
}

variable "sql_admin_user" {
  default     = "sqladminuser"
  description = "SQL admin username"
}

variable "sql_admin_password" {
  description = "SQL admin password"
  sensitive   = true
}

variable "key_vault_name" {
  default     = "iacsvault"
  description = "Key Vault name"
}

variable "tenant_id" {
  description = "Azure Tenant ID"
}

variable "kv_admin_object_id" {
  description = "Object ID of the user or service principal to grant access to Key Vault"
}

