# Shai-Hulud Branch Report Tool

This tool helps identify potential indicators of compromise (IoCs) within a GitHub organization or individual account by scanning repositories for suspicious patterns related to the term "shai-hulud".

## Features

- **Scans all repositories** in a specified GitHub organization or user account.
- **Detects repositories** with names containing `shai-hulud` (case-insensitive).
- **Finds repositories** containing a workflow file named `shai-hulud-workflow.yml`.
- **Checks for the existence** of a branch named `shai-hulud` in each repository.
- **Summarizes results** with counts and lists of affected repositories.

## Usage

You must have the [GitHub CLI (`gh`)](https://cli.github.com/) and [`jq`](https://stedolan.github.io/jq/) installed and authenticated.

Run the script with the organization or user name as an argument:

```bash
./crysknife.sh <organization-or-username>
```

**Example:**

```bash
./crysknife.sh bene-gesserit
```

The script will output a report showing:

- Repositories named 'Shai-Hulud'
- Repositories with a `shai-hulud-workflow.yml` workflow file
- Repositories with a `shai-hulud` branch
- Summary statistics

## Indicators of Compromise (IoCs)

This tool is designed to help security teams quickly identify repositories that may have been compromised or are exhibiting suspicious behavior, such as:

- Unexpected branches named `shai-hulud`
- Workflow files with suspicious names
- Repositories created or renamed with suspicious keywords

## Requirements

- Bash shell
- [GitHub CLI (`gh`)](https://cli.github.com/) (authenticated)
- [`jq`](https://stedolan.github.io/jq/)

## License

MIT License
