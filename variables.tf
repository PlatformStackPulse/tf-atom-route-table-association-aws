variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
  validation {
    condition     = length(var.subnet_id) > 0
    error_message = "subnet_id must not be empty."
  }
}

variable "route_table_id" {
  description = "ID of the route table"
  type        = string
  validation {
    condition     = length(var.route_table_id) > 0
    error_message = "route_table_id must not be empty."
  }
}
