# bump-version

Bump the Dart package version and create a corresponding changelog and commit.

## Steps

### 1) Ensure you are on `main`

- Verify the current branch is `main`:

  ```sh
  git rev-parse --abbrev-ref HEAD
  ```

- If the result is not `main`, stop and tell the user to switch to `main`.
  Do not proceed.

### 2) Ask for the next version

First, ask the user which version to bump to (e.g. `1.2.0`, `1.2.1`, `2.0.0`).
Do not proceed until the version is explicitly provided.

### 3) Create a bump branch from `main`

- Create and switch to a new branch named:

  ```
  bump-vx.x.x
  ```

  where `x.x.x` is the version provided by the user.

  ```sh
  git switch -c bump-vx.x.x
  ```

### 4) Update version

- Update the package version to the specified value
  (e.g. in `pubspec.yaml`).

### 5) Update CHANGELOG.md

- Identify the previous version entry in `CHANGELOG.md`.

- Determine the commit range since the last version bump by locating
  the most recent commit with a message like:

  ```txt
  bump up version: x.x.x
  ```

- Generate a new changelog section for the new version based on the diffs
  since that commit.

If the previous version bump commit cannot be identified, ask the user
to provide the commit hash to use as the starting point.

### 6) Commit

- Stage all related changes:

  ```sh
  git add -A
  ```

- Create a commit with the message:

  ```txt
  bump up version: x.x.x
  ```

## Constraints

- Exactly one commit.
- Do not push.
- Do not proceed without an explicit version from the user.
- Do not proceed unless the current branch is `main`.
- Do not guess the previous version bump commit if it cannot be found.
- Create and switch to `bump-vx.x.x` before committing.
