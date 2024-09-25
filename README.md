# jcdcdev.GitHub.GenerateChangelog

This action generates a changelog based on the commit messages in the repository.

## Inputs

| Input                        | Description                                                                                                  | Required |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------ | -------- |
| `github-token`               | The GitHub token to use for authentication (use `{{ secrets.GITHUB_TOKEN }}`)                                | `true`   |
| `version`                    | The version to generate the changelog for                                                                    | `true`   |
| `previous-version`           | Previous version - defaults to previous tag if not provided                                                  | `false`  |
| `head-ref`                   | The head ref to use for the comparison - defaults to any tag that matches input version e.g (v1.0.0)         | `false`  |
| `include-version-as-heading` | Include the version as a heading in the changelog - defaults to `false`                                      | `false`  |
| `include-links`              | Include links to the commits & issues in the changelog - defaults to `true`                                  | `false`  |
| `include-compare-link`       | Include a link to the compare view between the previous version and the current version - defaults to `true` | `false`  |
| `custom-emoji`               | Custom emoji mappings to use in the changelog - defaults to `feature🌟,nuget📦,chore🧹`                         | `false`  |

## Outputs

| Output      | Description                         |
| ----------- | ----------------------------------- |
| `changelog` | The generated changelog in markdown |