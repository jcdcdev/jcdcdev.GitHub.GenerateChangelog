# jcdcdev.GitHub.GenerateChangelog

This action generates a changelog based on the commit messages in the repository.

## Inputs

| Input              | Description                                                                   | Required |
| ------------------ | ----------------------------------------------------------------------------- | -------- |
| `github-token`     | The GitHub token to use for authentication (use `{{ secrets.GITHUB_TOKEN }}`) | `true`   |
| `target-version`   | The version to generate the changelog for                                     | `true`   |
| `previous-version` | Previous version - defaults to previous tag if not provided                   | `false`  |

## Outputs

| Output      | Description                         |
| ----------- | ----------------------------------- |
| `changelog` | The generated changelog in markdown |