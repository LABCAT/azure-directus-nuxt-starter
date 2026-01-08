output "container_registry_login_server" {
  value = module.acr.login_server
}

output "container_app_url" {
  value = module.container_apps.url
}

output "postgresql_connection_string" {
  value     = "postgres://${module.postgres.administrator_login}:${random_password.db_password.result}@${module.postgres.fqdn}:5432/${module.postgres.database_name}"
  sensitive = true
}

output "redis_connection_string" {
  value     = "${module.redis.hostname}:${module.redis.ssl_port},password=${module.redis.primary_access_key},ssl=True,abortConnect=False"
  sensitive = true
}

output "storage_account_name" {
  value = module.storage.name
}

output "storage_account_key" {
  value     = module.storage.primary_access_key
  sensitive = true
}

output "static_web_app_url" {
  value = "https://${module.swa.default_host_name}"
}

output "static_web_app_api_key" {
  value     = module.swa.api_key
  sensitive = true
}
