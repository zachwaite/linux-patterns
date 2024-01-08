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
