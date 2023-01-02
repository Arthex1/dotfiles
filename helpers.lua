local lunajson = require 'lunajson'

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


local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end
local function ReadJsonFile(file) 
    if not file_exists(file ) then
        error(file .. "Does not exist")
        return 
    end
    local lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    local t = {}
    for k, v in pairs(lines) do
        table.insert(t, v) 
        
        
    end
    return lunajson.decode(table.concat(t))
       
end
function table.union(a, b) 
    local c = a 
    for k, v in pairs(b) do
        c[k] = v
    end
    return c
end 

local function DumpJsonFile(file, input)  
    if not file_exists(file) then
        error(file .. "Does not exist") 
        return 
    end 
    local current_annotate = ReadJsonFile(file)
    local test = lunajson.decode(lunajson.encode(input)) 
    local res = table.union(test, current_annotate )
    
    
    local file,err = io.open(file,'w')
    if file then
        file:write(lunajson.encode(res))
        file:close()
    else
        print("error:", err) -- not so hard?
    end
    
end

local function RemoveObjectJsonFile(file, input)  
    if not file_exists(file) then
        error(file .. "Does not exist") 
        return 
    end 
    local test = lunajson.decode(lunajson.encode(input)) 
    
    
    local file,err = io.open(file,'w')
    if file then
        file:write(lunajson.encode(test))
        file:close()
    else
        print("error:", err) -- not so hard?
    end
    
end
return {
    len = len,
    split = split,
    instring = inString,
    dump = dump,
    ReadJsonFile = ReadJsonFile,
    DumpJsonFile = DumpJsonFile,
    ROJF = RemoveObjectJsonFile,
}
