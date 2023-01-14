local _M = {} 
local gears = require 'gears'
local awful = require 'awful'
local lunajson = require 'lunajson'
local lgi = require 'lgi'
local misc = require 'helpers.misc'
local Gio = lgi.require("Gio", "2.0")
function FileExists(file)
    return gears.filesystem.file_readable(file)
end
_M.FileExists = FileExists
function table.union(a, b) 
    local c = a 
    for k, v in pairs(b) do
        c[k] = v
    end
    return c
end 


-- This function was found to be not working, as due to how rude SirAideall Is, i am too deppressed to ask anyone about it, thus it will remain unworked till i am ready to work on it again.
-- @param filename string
-- @returns nil
local function WriteAsync(filename, contents)
   local file = Gio.File.new_for_path(filename) 
   print(helpers.misc.TableToString(file), contents)
   local stream = assert(file:async_create('NONE'))
   local pos = 1
   while pos <= #contents do
      local wrote, err = stream:async_write_bytes(GLib.Bytes(contents:sub(pos)))
      assert(wrote >= 0, err)
      pos = pos + wrote
   end
   
end

function ReadAsync(filename) 
   local file = Gio.File.new_for_path(filename)
   
   local info = assert(file:async_query_info('standard::size', 'NONE'))
   local stream = assert(file:async_read())
   local read_buffers = {}
   local remaining = info:get_size()
   while remaining > 0 do
      local buffer = assert(stream:async_read_bytes(remaining))
      table.insert(read_buffers, buffer.data)
      remaining = remaining - #buffer
   end
   stream:async_close() 
   
   return table.concat(read_buffers)
end

function _M.ReadFile(file)
    if not FileExists(file) then
        error('File Provided Does not exist')
    end 

    local file_content = Gio.Async.call(ReadAsync)(file)
    
    local decoded_content = lunajson.decode(file_content) 
    
    return decoded_content



    
end
-- I dont feel much of a performance difference yet, however i would hope i end up working on the async version of this, even though i was told, Gio.Async is not much better than io.open 
-- @param filename string 
-- @param content string
-- @returns nil 
function WriteSync(file, content)
    local file,err = io.open(file,'w')
    if file then
        file:write(content)
        file:close()
    else
        error("error:", err)
        --  raising an error to avoid me wondering what the fuck went wrong
    end

end
function _M.DumpFile(file, content)
    if not FileExists(file) then
        error("File does not exist:" .. tostring(file)) 
    end
    local currentcontent = _M.ReadFile(file)
    local content = lunajson.decode(lunajson.encode(content)) 
    local res = table.union(currentcontent, content) 
    WriteSync(file, lunajson.encode(res))
   
end
function _M.ReplaceFileContent(file, input) 
    if not FileExists(file) then
        error("File does not exist" .. tostring(file)) 
    end
    local content = lunajson.decode(lunajson.encode(input)) 
    WriteSync(file, lunajson.encode(content))
    
end

return _M
