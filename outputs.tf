output "repo_id" {
  description = "GitHub ID for the repository"
  value       = github_repository.repo.repo_id
}

output "repo_node_id" {
  description = "GraphQL global node id for use with v4 API"
  value       = github_repository.repo.node_id
}

output "repo_name" {
  description = "The name of the repository."
  value       = github_repository.repo.name
}

