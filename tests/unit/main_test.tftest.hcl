# Unit Tests for tf-atom-route-table-association-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose
# Run specific:     terraform test -test-directory=tests/unit -run "creates_when_enabled"
#
# NOTE: assertions target plan-KNOWN values (the tf-label id string, resource
# count, enabled flag, input pass-throughs). Computed attributes such as the
# association's real .id are UNKNOWN under a mock provider, so they are not
# asserted on directly.

mock_provider "aws" {}

variables {
  # tf-label identity inputs
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module's own required inputs (valid sample values)
  subnet_id      = "subnet-0123456789abcdef0"
  route_table_id = "rtb-0123456789abcdef0"
}

# ---------------------------------------------------------------------------
# Test: module creates the association when enabled (default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "output.enabled must be true when the module is enabled"
  }

  assert {
    condition     = length(aws_route_table_association.this) == 1
    error_message = "exactly one route table association must be planned when enabled"
  }

  assert {
    condition     = aws_route_table_association.this[0].subnet_id == "subnet-0123456789abcdef0"
    error_message = "subnet_id must be passed through to the route table association"
  }

  assert {
    condition     = aws_route_table_association.this[0].route_table_id == "rtb-0123456789abcdef0"
    error_message = "route_table_id must be passed through to the route table association"
  }
}

# ---------------------------------------------------------------------------
# Test: module creates nothing when disabled
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "output.enabled must be false when the module is disabled"
  }

  assert {
    condition     = length(aws_route_table_association.this) == 0
    error_message = "no route table association must be planned when disabled"
  }

  assert {
    condition     = output.id == null
    error_message = "output.id must be null when the module is disabled"
  }
}
