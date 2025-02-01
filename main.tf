# Define the GitHub repository
resource "github_repository" "repo" {
  name                   = var.repository_config.name
  description            = var.repository_config.description
  visibility             = var.repository_config.visibility
  allow_auto_merge       = var.repository_config.allow_auto_merge
  allow_merge_commit     = var.repository_config.allow_merge_commit
  allow_rebase_merge     = var.repository_config.allow_rebase_merge
  allow_squash_merge     = var.repository_config.allow_squash_merge
  archived               = var.repository_config.archived
  delete_branch_on_merge = var.repository_config.delete_branch_on_merge
  has_issues             = var.repository_config.has_issues
  has_projects           = var.repository_config.has_projects
  has_wiki               = var.repository_config.has_wiki
  vulnerability_alerts   = var.repository_config.vulnerability_alerts
  homepage_url           = var.repository_config.homepage_url
  gitignore_template     = var.repository_config.gitignore_template
  topics                 = var.repository_config.topics
  is_template            = var.repository_config.is_template

  dynamic "pages" {
    for_each = var.pages
    content {
      source {
        branch = pages.key
        path   = pages.value
      }
    }
  }
}

# Assign repository access to teams
resource "github_team_repository" "repo_access" {
  for_each   = { for idx, team in var.access_list : idx => team }
  team_id    = each.value.team_id
  repository = github_repository.repo.name
  permission = each.value.permission

  lifecycle {
    ignore_changes = [team_id, permission]
  }
}

# Define main branch only if gitignore_template is not set
resource "github_branch" "main" {
  count      = var.repository_config.gitignore_template == null ? 1 : 0
  repository = github_repository.repo.name
  branch     = "main"
}

# Create develop branch if requested
resource "github_branch" "develop" {
  count      = var.create_develop_branch ? 1 : 0
  repository = github_repository.repo.name
  branch     = "develop"
}

# Set default branch (either main or develop)
resource "github_branch_default" "default" {
  repository = github_repository.repo.name
  branch     = var.create_develop_branch ? github_branch.develop[0].branch : "main"
}

# Use a local variable to create a map for branch protections
locals {
  branch_protections_map = { for obj in var.branch_protections : obj.branch => obj if obj.branch != null }
}

# Apply branch protection rules
resource "github_branch_protection" "protection" {
  for_each            = local.branch_protections_map
  repository_id       = github_repository.repo.node_id
  pattern             = each.value.branch
  allows_force_pushes = each.value.allows_force_pushes
  allows_deletions    = false

  dynamic "required_status_checks" {
    for_each = lookup(each.value, "required_status_checks", null) != null ? [1] : []
    content {
      strict   = each.value.required_status_checks.strict
      contexts = length(var.required_status_checks_context) > 0 ? var.required_status_checks_context : each.value.required_status_checks.contexts
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = lookup(each.value, "required_pull_request_reviews", null) != null ? [1] : []
    content {
      pull_request_bypassers = try(each.value.required_pull_request_reviews.pull_request_bypassers, [])
      dismiss_stale_reviews  = try(each.value.required_pull_request_reviews.dismiss_stale_reviews, false)
      restrict_dismissals    = try(each.value.required_pull_request_reviews.restrict_dismissals, false)
      dismissal_restrictions = try(each.value.required_pull_request_reviews.dismissal_restrictions, [])
    }
  }

  lifecycle {
    ignore_changes = [required_status_checks, required_pull_request_reviews]
  }
}
