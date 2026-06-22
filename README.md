# ghclone

A Bash script to clone Git repositories into a structured hierarchical directory tree based on the repository URL.

## Features
- **Structured Layout**: Clones repositories into `~/git/<host>/<owner>/<repo>`.
- **Fast Start**: Performs an initial shallow clone (`--depth 1`) for immediate access.
- **Background Recovery**: Automatically triggers a background process to fetch full history (unshallow) without blocking the user.
- **Idempotency**: Skips cloning if the destination directory already exists.

## Installation
```bash
cp git-structured-clone.sh ~/.local/bin/git-structured-clone
chmod +x ~/.local/bin/git-structured-clone
```

## Usage
```bash
git-structured-clone <repository-url>
```
