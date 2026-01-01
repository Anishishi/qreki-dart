# auto-commit

Create exactly one clean Git commit from all current local changes
using a Git-first workflow.

## Steps

### 1) Stage all changes

```sh
git add -A
````

If there is nothing to commit, stop.

### 2) Ensure a non-main branch

```sh
git branch --show-current
```

If the current branch is `main`, create and switch to:

```sh
git switch -c <type>/<topic>
```

- `<type>`: `feat`, `fix`, `chore`
- `<topic>`: derived from the actual changes, kebab-case

### 3) Generate commit message

Generate a short present-tense English commit message
that describes the staged changes.

### 4) Commit (single commit)

```sh
git commit -m "<message>"
```

## Constraints

- Exactly one commit.
- Do not push.
- Do not ask for confirmation (except when terminal permission is required).
