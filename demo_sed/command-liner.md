# sed - 2023-02-24

## tldr;

`sed` is a linux program that is used to filter streams of text. It is most
useful as a find and replace tools when combined with simple regular
expressions. Don't use `sed` to:

- extract capture groups from a line (use `grep -oE`)
- handle lines delimited by a single character (use `qsv`)
- handle complex parsing or multiple capture groups (use parser combinators)

## Example

Prepare line-oriented text with multi-character delimiter for consumption by
`qsv`, which requires a single character delimiter.

```sh
echo "zach||1985||10||G" | sed 's/|\{2\}/;/g' # output: zach;1985;10;G
```

Prepare line-oriented text with a delimiter pattern (number list)

```sh
echo "1. zach 2. 1985 3. 10 4. G" | sed 's/[0-9]\./;/g' # output: ;zach;1985;10;G
```

## Links

- [sed regex](https://www.gnu.org/software/sed/manual/html_node/Regular-Expressions.html)
