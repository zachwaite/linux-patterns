# catecho - 2023-02-17

## tldr;

`catecho` is a bash function that can be used to funnel either the contents of a
file, OR a string argument into a bash function in a unix-y way. This is useful
to extract argument parsing logic out of your command pipeline.

## Example

```sh
functioncatecho () {
    if read -t 0; then
        cat
    else
        echo "$*"
    fi
}

function zsql() {
  # perform a sql query and output as csv
  catecho "$@" | isql -c -b -d';' "$DSN"
}
```

## Links

- [catecho on Stack Overflow](https://stackoverflow.com/questions/18761209/how-to-make-a-bash-function-which-can-read-from-standard-input)
