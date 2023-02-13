# Demo git hooks

Because this is in a git repo, this work can't actually be committed here. This
document will have to do.

## Example

This example adds a pre-commit hook to prevent pushing python code with a `pdb`
debugger line. The basic technique can be used for all other hooks.

First rename `pre-commit.sample` to `pre-commit`. This will be an executable
shell script.

```bash
cd $REPO
mv .git/hooks/pre-commit.sample .git/hooks/pre-commit
```

Add a test exits with a non-zero value if any python files have a "pdb" line in
them.

```bash
cat << EOF > .git/hooks/pre-commit
#! /usr/bin/env bash

# NOTE: do not `set -o errexit` here because the implicit piping into git commit will break

set -o nounset;

FOUND_PDB="$(grep -r pdb . --include=*.py)";

if [ -n "$FOUND_PDB" ]; then
  echo "ERROR!: Found python debugger line!";
  echo "$FOUND_PDB";
  exit 1;
else
  echo "OK";
  exit 0;
fi;
EOF
```
