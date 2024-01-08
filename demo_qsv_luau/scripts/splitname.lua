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
