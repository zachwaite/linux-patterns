# qsv luau - 2024-01-06

## tldr;

`qsv` is a swiss army knife for working with delimited data. The `qsv luau` subcommand
allows us to use the embedded lua interpreter to execute arbitrary code during csv
processing. This is particularly useful for adding new columns based on the data in
the input file or even perform lookups in an external file.

## Example

Let's take this dataset based on some Odoo demo data:

```
head odoo_sales.csv | qsv table

Order Date  Order Reference  Salesperson  Status       Total
2024-01-06  S00024           Marc Demo    Sales Order  1990.0
2024-01-05  S00023           Marc Demo    Sales Order  4350.0
2024-01-05  S00022           Marc Demo    Sales Order  1475.0
2024-01-04  S00021           Marc Demo    Sales Order  2175.0
2024-01-04  S00016           Marc Demo    Sales Order  1186.5
2024-01-04  S00014           Marc Demo    Sales Order  1582.0
2024-01-04  S00013           Marc Demo    Sales Order  415.5
2024-01-03  S00012           Marc Demo    Sales Order  556.0
2024-01-03  S00010           Marc Demo    Sales Order  751.0
```

Double the Total field into a new field. (Notice that you don't need to cast to a
numeric type)

```sh
< odoo_sales qsv luau map Total2 "col.Total * 2" | qsv table

Order Date  Order Reference  Salesperson     Status       Total   Total2
2024-01-06  S00024           Marc Demo       Sales Order  1990.0  3980
2024-01-05  S00023           Marc Demo       Sales Order  4350.0  8700
2024-01-05  S00022           Marc Demo       Sales Order  1475.0  2950
2024-01-04  S00021           Marc Demo       Sales Order  2175.0  4350
2024-01-04  S00016           Marc Demo       Sales Order  1186.5  2373
2024-01-04  S00014           Marc Demo       Sales Order  1582.0  3164
2024-01-04  S00013           Marc Demo       Sales Order  415.5   831
2024-01-03  S00012           Marc Demo       Sales Order  556.0   1112
2024-01-03  S00010           Marc Demo       Sales Order  751.0   1502
```

Split the Salesperson field into a first and last name field.

It's easier to write a separate lua script for this:
```lua
# splitname.lua
BEGIN {
  -- define the split function only once at the beginning of execution
  -- global function
  function splitname(s: string, n): table
    local t: table = {}
    for word in string.gmatch(s, '%a+') do
      table.insert(t, word)
    end
    return t
  end
}!

-- each row
return splitname(col.Salesperson)
```

Then call it from the pipeline.

```sh
< odoo_sales.csv qsv luau map First,Last file:scripts/splitname.lua | head | qsv table

Order Date  Order Reference  Salesperson  Status       Total   First  Last
2024-01-06  S00024           Marc Demo    Sales Order  1990.0  Marc   Demo
2024-01-05  S00023           Marc Demo    Sales Order  4350.0  Marc   Demo
2024-01-05  S00022           Marc Demo    Sales Order  1475.0  Marc   Demo
2024-01-04  S00021           Marc Demo    Sales Order  2175.0  Marc   Demo
2024-01-04  S00016           Marc Demo    Sales Order  1186.5  Marc   Demo
2024-01-04  S00014           Marc Demo    Sales Order  1582.0  Marc   Demo
2024-01-04  S00013           Marc Demo    Sales Order  415.5   Marc   Demo
2024-01-03  S00012           Marc Demo    Sales Order  556.0   Marc   Demo
2024-01-03  S00010           Marc Demo    Sales Order  751.0   Marc   Demo
```

Now let's do a running total from oldest to newest order.

Again, use a separate lua script for this:
```lua
# running_total.lua
BEGIN {
  -- global state
  running_total = 0
}!

-- each row
running_total += col.Total
return running_total
```

```sh
< odoo_sales.csv qsv sort -s "Order Date" \
    | qsv luau map 'Running Total' file:scripts/running_total.lua \
    | head  \
    | qsv table

Order Date  Order Reference  Salesperson     Status          Total   Running Total
2023-12-02  S00018           Marc Demo       Sales Order     831.0   831
2023-12-06  S00020           Mitchell Admin  Sales Order     2947.5  3778.5
2023-12-06  S00019           Mitchell Admin  Quotation Sent  1740.0  5518.5
2023-12-06  S00005           Marc Demo       Quotation       405.0   5923.5
2023-12-06  S00002           Mitchell Admin  Quotation       2947.5  8871
2023-12-06  S00001           Marc Demo       Quotation       1740.0  10611
2023-12-09  S00017           Marc Demo       Sales Order     951.0   11562
2023-12-16  S00011           Marc Demo       Sales Order     1096.5  12658.5
2023-12-23  S00015           Marc Demo       Sales Order     1541.5  14200
```


Building on that, we can do a 10 day moving average total sales report

Use a separate lua file for this too:

```lua
# moving_average.lua
BEGIN {
  -- global functions
  function avg(buf)
    local total = 0
    for _, v in pairs(buf) do
      total = total + v
    end
    return total / #buf
  end

  function main(buf, idx, total)
    if idx <= 10 then
      table.insert(buf, total)
      return 0
    else
      table.remove(buf, 1)
      table.insert(buf, total)
      return avg(buf)
    end
  end

  -- global state
  buf10 = {}
}!

-- each row
return main(buf10, _IDX, col.Total)
```

```sh
< odoo_sales.csv qsv sort -s 'Order Date' \
    | qsv luau map 'Moving Average' file:scripts/moving_average.lua
```



That's just the tip of the iceberg. Lua is a full programming language and well suited
for more complicated parsing / computation tasks within a processing pipeline.

## Links

- [qsv](https://github.com/jqnatividad/qsv)
- [luau](https://luau-lang.org/)
