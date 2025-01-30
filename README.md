# GitHub Repository module

Terraform module which creates GitHub repository with organization baseline.

* Create repository.
* Set access teams to repository
* Configure branch protections for repository

## Usage

### Repository example

```hcl
module "repo_test" {
  source  = "app.terraform.io/EveryonePrint/repository/github"
  version = "0.1.0"

  delete_branch_on_merge = "false"
  has_downloads          = "true"
  has_issues             = "true"
  has_projects           = "true"
  has_wiki               = "true"
  name                   = "test"

  access_list = {
    "DevOps"   = "push"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_branch.develop](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch) | resource |
| [github_branch.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch) | resource |
| [github_branch_default.default](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default) | resource |
| [github_branch_protection.protection](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection) | resource |
| [github_repository.repo](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_team_repository.repo_access](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_list"></a> [access\_list](#input\_access\_list) | Access map for teams, format: { team\_id = permission }. | `map(any)` | `{}` | no |
| <a name="input_branch_protections"></a> [branch\_protections](#input\_branch\_protections) | Branch protection configuration. | <pre>list(object({<br/>    branch              = string<br/>    allows_force_pushes = bool<br/>    required_status_checks = object({<br/>      strict   = bool<br/>      contexts = list(string)<br/>    })<br/>    required_pull_request_reviews = optional(object({<br/>      dismiss_stale_reviews  = optional(bool, true)<br/>      restrict_dismissals    = optional(bool, false)<br/>      dismissal_restrictions = optional(list(string), [])<br/>      pull_request_bypassers = optional(list(string), [])<br/>    }))<br/>  }))</pre> | <pre>[<br/>  {<br/>    "allows_force_pushes": false,<br/>    "branch": "main",<br/>    "required_pull_request_reviews": {<br/>      "dismiss_stale_reviews": true,<br/>      "dismissal_restrictions": [],<br/>      "pull_request_bypassers": [],<br/>      "restrict_dismissals": false<br/>    },<br/>    "required_status_checks": {<br/>      "contexts": [],<br/>      "strict": true<br/>    }<br/>  }<br/>]</pre> | no |
| <a name="input_create_develop_branch"></a> [create\_develop\_branch](#input\_create\_develop\_branch) | Whether to create a develop branch in the repo or not. | `bool` | `false` | no |
| <a name="input_pages"></a> [pages](#input\_pages) | The repository's GitHub Pages configuration. | `map(any)` | `{}` | no |
| <a name="input_repository_config"></a> [repository\_config](#input\_repository\_config) | Configuration object for defining repository settings. This groups all repository-related configurations in a structured object for better maintainability. | <pre>object({<br/>    name                   = string<br/>    description            = optional(string, null)      # A description of the repository.<br/>    visibility             = optional(string, "private") # Can be "public" or "private".<br/>    allow_auto_merge       = optional(bool, false)       # Set to true to allow auto-merging pull requests.<br/>    allow_merge_commit     = optional(bool, true)        # Set to false to disable merge commits.<br/>    allow_rebase_merge     = optional(bool, true)        # Set to false to disable rebase merges.<br/>    allow_squash_merge     = optional(bool, true)        # Set to false to disable squash merges.<br/>    archived               = optional(bool, false)       # Set to true to archive the repository.<br/>    delete_branch_on_merge = optional(bool, false)       # Automatically delete branch after PR merge.<br/>    has_issues             = optional(bool, false)       # Enables GitHub Issues.<br/>    has_projects           = optional(bool, false)       # Enables GitHub Projects.<br/>    has_wiki               = optional(bool, false)       # Enables GitHub Wiki.<br/>    vulnerability_alerts   = optional(bool, false)       # Enables security vulnerability alerts.<br/>    homepage_url           = optional(string, null)      # URL of the project’s homepage.<br/>    gitignore_template     = optional(string, null)      # Template for `.gitignore` (e.g., "Haskell").<br/>    topics                 = optional(list(string), [])  # List of repository topics.<br/>    is_template            = optional(bool, false)       # Defines if this repository should be a template.<br/>  })</pre> | n/a | yes |
| <a name="input_required_status_checks_context"></a> [required\_status\_checks\_context](#input\_required\_status\_checks\_context) | Required status checks. Used if branch\_protections is not defined. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repo_id"></a> [repo\_id](#output\_repo\_id) | GitHub ID for the repository |
| <a name="output_repo_name"></a> [repo\_name](#output\_repo\_name) | The name of the repository. |
| <a name="output_repo_node_id"></a> [repo\_node\_id](#output\_repo\_node\_id) | GraphQL global node id for use with v4 API |
<!-- END_TF_DOCS -->


## Authors

Module managed by [Santiago Zurletti](https://github.com/KiddoATOM).
