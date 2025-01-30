output "repo_id" {
  description = "GitHub ID for the repository"
  value       = github_repository.main.repo_id
}

output "repo_node_id" {
  description = "GraphQL global node id for use with v4 API"
  value       = github_repository.main.node_id
}

output "repo_name" {
  description = "The name of the repository."
  value       = github_repository.main.name
}

