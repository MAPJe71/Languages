--
-- Compat-5.2
--

--[[

-- $HOME/lua-5.2.0-work1/test.lua
package.path = '/home/peter/lua-5.2.0-work1/modules/?.lua'
require 'test'
assert(test.fun() == 42)
assert(test.print == nil)

-- $HOME/lua-5.2.0-work1/modules/test.lua
local setmetatable, _G = setmetatable, _G
local mobtbl = module(...)
in setmetatable({}, {
	__index = function(_, k) return mobtbl[k] or _G[k] end,
	__newindex = function(_, k, v) mobtbl[k] = v end,
}) do
	function fun()
		print 'it works'
		return 42
	end
end

--]]

--[[
I think the new way to write modules will be:

in module(...) do
    <module content>
end

So you write instead one time:

local oldmodule = module
function module(...)
    local _M = oldmodule(...)
    return setmetatable({}, {
        __index = function(_, k) return _M[k] or _G[k] end,
        __newindex = function(_, k, v) _M[k] = v end,
    })
end

And write all your modules with the syntax using a lexical scope.
--]]


_COMPAT52 = "Compat-5.2"

if ( _VERSION == "Lua 5.2" ) then
    --
    -- To be able to run Lua 5.1 scripts with Lua 5.2 interpreter, 
    -- add the following to make Lua 5.2 backwards compatible.
    --
    -- the debug library is no longer loaded by default, therefore ...
    require 'debug';
    -- getfenv deprecated (Still exists, but calling it just results in 
    -- an error stating that it is deprecated.)
    getfenv = function( level )
        return debug.getfenv(debug.getinfo(level+1, 'f').func);
    end;
    -- setfenv deprecated (Still exists, but calling it just results in 
    -- an error stating that it is deprecated.)
    setfenv = function( level, env )
        if ( type(level) == 'number' ) then
            level = debug.getinfo(level+1, 'f').func;
        end;
        return debug.setfenv(level, env);
    end;
    -- unpack is renamed to table.unpack with new semi-inverse table.pack
    unpack = table.unpack;
    --
    math.log10 = function (x) return math.log(x, 10); end;
    
elseif ( _VERSION == "5.1" ) then
    --
    table.pack   = function (...) return {n = select('#', ...), ...} end;
    table.unpack = unpack;
    --
    -- Lua 5.2 introduces a new function called package.searchpath, 
    -- which scans a list of paths for a file in a similar manner to 
    -- the require function. This may be useful for packages which 
    -- contain non-Lua files which they need to find.
    local dir_separator = package.config:sub(1, 1);
    function package.searchpath( mod, path )
        mod = mod:gsub('%.', dir_separator);     -- replace any `.` in module name with `dir_separator`
        for m in path:gmatch('[^;]+') do         -- search each sub-path for module
            local nm = m:gsub('?', mod);         -- replace any `?` in path with specified module name
            local f = io.open(nm, 'r');          -- does module exist in given location?
            if f then f:close(); return nm; end; -- if so, close file and return full path
        end;
    end;
else
    assert(false);
end;
