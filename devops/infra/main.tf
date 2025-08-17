terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

# ------------------------
# 1. Resource Group
# ------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# ------------------------
# 2. Storage Account (Blob)
# ------------------------
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "docs" {
  name                  = "documents"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# ------------------------
# 3. Azure SQL Database
# ------------------------
resource "azurerm_sql_server" "sql" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_user
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_sql_database" "db" {
  name                             = var.sql_db_name
  resource_group_name              = azurerm_resource_group.rg.name
  location                         = azurerm_resource_group.rg.location
  server_name                      = azurerm_sql_server.sql.name
  requested_service_objective_name  = "S0"
}

# ------------------------
# 4. Azure Key Vault
# ------------------------
resource "azurerm_key_vault" "kv" {
  name                        = var.key_vault_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7
}

# ------------------------
# 4b. Key Vault Access Policy
# ------------------------

resource "azurerm_key_vault_access_policy" "kv_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.tenant_id
  object_id    = var.kv_admin_object_id 

  # Permissions for secrets
  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]

  # Optional: Permissions for keys and certificates
  key_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List"
  ]
}


# ------------------------
# 5. Application Insights
# ------------------------
resource "azurerm_application_insights" "appinsights" {
  name                = "${var.project_name}-ai"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

# ------------------------
# 6. Azure Cognitive Services (Document Intelligence, Language Studio, OpenAI)
# ------------------------

# Document Intelligence
resource "azurerm_cognitive_account" "doc_intel" {
  name                = "${var.project_name}-docintel"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FormRecognizer"
  sku_name            = "F0" # Free tier
}

# Language Studio (NER)
resource "azurerm_cognitive_account" "language" {
  name                = "${var.project_name}-language"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "TextAnalytics"
  sku_name            = "F0" # Free tier
}

# Azure OpenAI (⚠️ Free tier doesn't exist — provision basic, keep disabled if not needed daily)
resource "azurerm_cognitive_account" "openai" {
  name                = "${var.project_name}-openai"
  location            = "East US" # Required for OpenAI
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "OpenAI"
  sku_name            = "S0" # Cheapest available
}

# ------------------------
# 7. Outputs
# ------------------------
output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "sql_connection_string" {
  value     = "Server=tcp:${azurerm_sql_server.sql.name}.database.windows.net;Database=${azurerm_sql_database.db.name};User ID=${var.sql_admin_user};Password=${var.sql_admin_password};Encrypt=true"
  sensitive = true
}

output "key_vault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}

output "doc_intel_endpoint" {
  value = azurerm_cognitive_account.doc_intel.endpoint
}

output "language_endpoint" {
  value = azurerm_cognitive_account.language.endpoint
}

output "openai_endpoint" {
  value = azurerm_cognitive_account.openai.endpoint
}