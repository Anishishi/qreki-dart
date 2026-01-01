# bump-version

Bump the Dart package version and create a corresponding changelog and commit.

## Steps

### 1) Ask for the next version

First, ask the user which version to bump to (e.g. `1.2.0`, `1.2.1`, `2.0.0`).
Do not proceed until the version is explicitly provided.

### 2) Update version

- Update the package version to the specified value
  (e.g. in `pubspec.yaml`).

### 3) Update CHANGELOG.md

- Identify the previous version entry in `CHANGELOG.md`.
- Determine the commit range since the last version bump by locating
  the most recent commit with a message like:

    ```
    bump up version: x.x.x
    ````

- Generate a new changelog section for the new version based on the diffs
since that commit.

If the previous version bump commit cannot be identified, ask the user
to provide the commit hash to use as the starting point.

### 4) Commit

- Stage all related changes:

    ```sh
    git add -A
    ````

- Create a commit with the message:

    ```
    bump up version: x.x.x
    ```

## Constraints

- Exactly one commit.
- Do not push.
- Do not proceed without an explicit version from the user.
- Do not guess the previous version bump commit if it cannot be found.
