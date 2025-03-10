# Patterns for usage of linux and cli tools

## Configure all `ReadLine` based programs to use vi mode

Examples: bash shell, psql cli

1. Create a file `~/.inputrc`
2. Add `set editing-mode vi`

one-liner

```sh
echo 'set editing-mode vi' >> ~/.inputrc
```

## Edit a command in vim

Sometimes when you type a long command you make a mistake or simply want to
rerun a command which is very similar to a previous command. There are 2 ways:

1. **Use vi mode in bash**

This is the simplest. Simply use `ESC` to enter normal mode emulation and most
keybindings are available.

2. Edit the command in vim

This is when you want the full power of vim. Hit `ESC` to enter normal mode,
then `v` to open the command in the vim editor in a temporary file.

## Testing conditions

Use 2 opening brackets, space, value 1, comparison option, value 2, space 2
closing brackets.

Example:

```sh

if [[ $FOO -lt 10 ]] then
  echo "1 digit"
elif [[ $FOO -lt 100 ]] then
  echo "2 digits"
else
  echo "more than 2 digits"
fi

```

## Redirects are for files (or file-like things)

Examples:

```sh
# send stdout to a file
echo "foo" > file.txt

# send file to stdin
< file.txt grep "something"

# send the output of a command to a file-like, redirected to stdin
<(ls -l ./dir1) grep "somefile"

# send the output of commands directly to command positional args and redirect stdout to a file

diff <(ls -l ./dir1) <(ls -l ./dir2) > diff.txt

```

## Default script options

Certain settings improve bash script behaviors

```sh
set -o errexit        # exit the script if an error occurs
set -o xtrace         # print each command as it runs
set -o nounset        # prevent using variables that aren't unset
```

## Dry run a bash script

Use the `-n` option to perform a dry run. Useful for e.g. syntax checking

```sh
bash -n myscript.sh
```

## Shellcheck

Use `coc-sh` or some other bash-language-server client that leverages
shellcheck.

## Using arrays

Regular Example:

```sh
inputs=(1 2 4 8 16 32 64 128)
outputs=()
for i in ${inputs[@]}; do
  rs=$(./foocmd $i)
  output+=( $rs )
done
```

Associative Array Example:

## Everything is an array in bash

```sh
foo=(1 2 3 4 5)
echo $foo
# outputs 1
```

Basically a variable reference with no index is desugared to $variable[0].

To expand the whole array:

```sh
foo=(1 2 3 4 5)
echo ${foo[@]}
# outputs 1 2 3 4 5
```

## Grab a module from one git branch into another

See
(https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-15.0)[https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-15.0]

```sh
git format-patch --keep-subject --stdout origin/15.0..origin/14.0 -- $MODULE | git am -3 --keep
```

## Git push with personal access token

1. Create a github personal access token and copy it somewhere.

2. Create a git remote using the https protocol

```sh
git remote add https https://github.com/somerepo.git
```

3. Push

```sh
git push https <branch>
```

You will be prompted for an access token, serving as your password

## Git commit as specific author

```sh
git -c user.name="Zach Waite" -c user.email="zach@waiteperspectives.com" commit -m "Test commit"
```

## Git push as specific author

```sh
git push <remote> <branch> --author "Zach Waite <zach@waiteperspectives.com>"
```

## Git push when not on a branch

```sh
git push <remote> HEAD:<branch>
```
