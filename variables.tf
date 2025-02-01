variable "repository_config" {
  description = "Configuration object for defining repository settings. This groups all repository-related configurations in a structured object for better maintainability."

  type = object({
    name                   = string
    description            = optional(string, null)      # A description of the repository.
    visibility             = optional(string, "private") # Can be "public" or "private".
    allow_auto_merge       = optional(bool, false)       # Set to true to allow auto-merging pull requests.
    allow_merge_commit     = optional(bool, true)        # Set to false to disable merge commits.
    allow_rebase_merge     = optional(bool, true)        # Set to false to disable rebase merges.
    allow_squash_merge     = optional(bool, true)        # Set to false to disable squash merges.
    archived               = optional(bool, false)       # Set to true to archive the repository.
    delete_branch_on_merge = optional(bool, false)       # Automatically delete branch after PR merge.
    has_issues             = optional(bool, false)       # Enables GitHub Issues.
    has_projects           = optional(bool, false)       # Enables GitHub Projects.
    has_wiki               = optional(bool, false)       # Enables GitHub Wiki.
    vulnerability_alerts   = optional(bool, false)       # Enables security vulnerability alerts.
    homepage_url           = optional(string, null)      # URL of the project’s homepage.
    gitignore_template     = optional(string, null)      # Template for `.gitignore` (e.g., "Haskell").
    topics                 = optional(list(string), [])  # List of repository topics.
    is_template            = optional(bool, false)       # Defines if this repository should be a template.
  })
}

variable "create_develop_branch" {
  type        = bool
  description = "Whether to create a develop branch in the repo or not."
  default     = false
}

variable "pages" {
  type        = map(any)
  description = "The repository's GitHub Pages configuration."
  default     = {}
}

variable "access_list" {
  type        = list(any)
  description = "Access map for teams, format: [{ team_id = 'DevOps',  permission = 'admin' }]."
  default     = []
}

variable "required_status_checks_context" {
  type        = list(string)
  description = "Required status checks. Used if branch_protections is not defined."
  default     = []
}

variable "branch_protections" {
  type = list(object({
    branch              = string
    allows_force_pushes = bool
    required_status_checks = object({
      strict   = bool
      contexts = list(string)
    })
    required_pull_request_reviews = optional(object({
      dismiss_stale_reviews  = optional(bool, true)
      restrict_dismissals    = optional(bool, false)
      dismissal_restrictions = optional(list(string), [])
      pull_request_bypassers = optional(list(string), [])
    }))
  }))
  description = "Branch protection configuration."
  default = [{
    branch              = "main"
    allows_force_pushes = false
    required_status_checks = {
      strict   = true
      contexts = []
    }
    required_pull_request_reviews = {
      dismiss_stale_reviews  = true
      restrict_dismissals    = false
      dismissal_restrictions = []
      pull_request_bypassers = []
    }
  }]
}
