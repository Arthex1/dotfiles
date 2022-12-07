local function len(table)
    local counts = 0
    for _, _ in ipairs(table) do
        counts = counts + 1
        
    end
    return counts 
    
end

local function split(s, sep)
    local fields = {}
    
    local sep = sep or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)
    
    return fields
end

local function inString(s, substring)
  return s:find(substring, 1, true)
end
return {
    len = len,
    split = split,
    instring = inString
}