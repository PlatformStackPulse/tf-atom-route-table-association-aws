output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "id" {
  description = "ID of the route table association"
  value       = try(aws_route_table_association.this[0].id, null)
}
