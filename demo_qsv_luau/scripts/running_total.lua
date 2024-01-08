BEGIN {
  -- global state
  running_total = 0
}!

-- each row
running_total += col.Total
return running_total
