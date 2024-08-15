variable "name_prefix" {
  description = "Prefix"
  type        = string
  default     = "prod-ci"
}

#true or false depending on if you want suffixes or not
variable "suffix_toggle" {
  description = "Toggle suffixes for resources"
  type        = bool
  default     = true
}

# Resource names with toggleable suffixes
locals {
  role_name   = var.suffix_toggle ? "${var.name_prefix}-role" : var.name_prefix
  policy_name = var.suffix_toggle ? "${var.name_prefix}-policy" : var.name_prefix
  group_name  = var.suffix_toggle ? "${var.name_prefix}-group" : var.name_prefix
  user_name   = var.suffix_toggle ? "${var.name_prefix}-user" : var.name_prefix
}

# IAM Role
resource "aws_iam_role" "this" {
  name               = local.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

# IAM Policy
resource "aws_iam_policy" "this" {
  name   = local.policy_name
  policy = data.aws_iam_policy_document.allow_assume_role.json
}

data "aws_iam_policy_document" "allow_assume_role" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.this.arn]
    effect    = "Allow"
  }
}

# IAM Group
resource "aws_iam_group" "this" {
  name = local.group_name
}

resource "aws_iam_group_policy_attachment" "this" {
  group      = aws_iam_group.this.name
  policy_arn = aws_iam_policy.this.arn
}

# IAM User
resource "aws_iam_user" "this" {
  name = local.user_name
}

resource "aws_iam_group_membership" "this" {
  name = local.group_name
  users = [
    aws_iam_user.this.name
  ]
  group = aws_iam_group.this.name
}

# Get current account ID
data "aws_caller_identity" "current" {}

