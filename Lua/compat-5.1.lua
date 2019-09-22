--
-- Compat-5.1 
-- Copyright Kepler Project 2004-2006 (http://www.keplerproject.org/compat)
-- According to Lua 5.1
-- $Id: compat-5.1.lua,v 1.22 2006/02/20 21:12:47 carregal Exp $
--
-- (To be able to use Lua 5.1 scripts with Lua 5.0 interpreter)
--
--[============================================================================[
The Package Compatibility (Compat-5.1) is a set of files which provides an 
implementation of the Lua 5.1 package model to be used with Lua 5.0.  It can 
be used by developers of Lua and Lua/C packages as much as by users that want 
to use those packages.

The compat-5.1.lua file reimplements the function require following the Lua 5.1 
behavior and adds the function module; it also defines the table package and 
its standard fields: path, cpath, loaded and preload.


Both Lua 5.0 and Compat-5.1 have to be properly configured in order to know 
where the modules should be loaded from. This configuration assumes two 
independent search paths on the system, one for binary modules and another 
for Lua modules.

The binary search path defines a sequence of directories and file name patterns 
that will be looked when trying to load a binary module. In the same way, 
the Lua module search path will be looked when trying to load a Lua module.

The file compat-5.1.lua should be installed in your LUA_PATH (package.path) 
and must be loaded by the application before any other library that follows 
the package model (libraries don't need to require Compat-5.1).

A simple way to do that for the standalone interpreter is to define 
the environment variable LUA_INIT as the absolute path to the file, 
preceeded by the character '@' (see the Lua 5.0 standalone interpreter 
documentation for more details).

Finally, the file compat-5.1.lua should be edited so that the default values 
for the variables package.path and package.cpath are correct for the target 
system. The variables values should follow the actual installation paths and 
library's name conventions for the target system (?.dll for Windows, [l]?.so 
for Unix etc). You can also define LUA_PATH and LUA_CPATH as environment 
variables so they are used instead of the defined default values.

Once Compat-5.1 is properly installed and configured, all that is needed to 
install any binary or Lua module is to place it on the corresponding 
package.cpath or package.path respectively.

--]============================================================================]

--[============================================================================[
It is probably time to move from Lua 5.0 to Lua 5.1, now that Lua 5.1 has had 
time to settle down.  This document is an attempt to alert scripters to things 
to watch out for to make their scripts more easily changed over to Lua 5.1.

The improvements in Lua 5.1 over 5.0 are:
- New module system making modular coding easier (see "require" and "module")
- Incremental garbage collection
- New "vararg" mechanism (ie. for functions that take a "..." argument)
- New syntax for long strings (multiline strings and comments with [[ ... ]] 
  around them)
- Mod operator (%) for arithmetic and length operator (#) for strings and tables.
- All data types can have metatables (in the C interface only however)
- New function "string.match", which returns the first matched capture 
  (like string.find but without the start and end position)
- New function "string.reverse" that reverses its argument.
- New function "load", which loads Lua code progressively by calling a function 
  to concatenate together data.
- New function "coroutine.running" which returns the currently-running 
  coroutine, if any.
- New function "math.modf" which returns the integral and fractional part of 
  a number.
- New maths functions sinh, cosh, and tanh for hyperbolic functions.

Generally speaking, most scripts should just continue to run without any 
problems.  There are some areas which may require attention.  I have found that 
the Lua chat module (itself pretty large) ran without changes under Lua 5.1.
--]============================================================================]


_COMPAT51 = "Compat-5.1 R5"

local LUA_DIRSEP    = '/'           -- directory separator
local LUA_OFSEP     = '_'           -- open-library function separator
local OLD_LUA_OFSEP = ''            -- old open-library function separator
local POF           = 'luaopen_'    -- prefix open-library function
local LUA_PATH_MARK = '?'           -- 
local LUA_IGMARK    = ':'           -- 

local assert, error, getfenv, ipairs, loadfile, loadlib, pairs, setfenv, setmetatable, type 
    = assert, error, getfenv, ipairs, loadfile, loadlib, pairs, setfenv, setmetatable, type
local        find,        format,        gfind,        gsub,        sub 
    = string.find, string.format, string.gfind, string.gsub, string.sub
--
-- The function string.gfind (Global Find) has been renamed string.gmatch under Lua 5.1.
local string.gmatch 
    = string.gfind


--
-- avoid overwriting the package table if it's already there
--
package = package or {}
local _PACKAGE = package

package.path  = LUA_PATH  or os.getenv("LUA_PATH" ) or
              ("./?.lua;"                           ..
               "/usr/local/share/lua/5.0/?.lua;"    ..
               "/usr/local/share/lua/5.0/?/?.lua;"  ..
               "/usr/local/share/lua/5.0/?/init.lua")
 
package.cpath = LUA_CPATH or os.getenv("LUA_CPATH") or
              ("./?.so;"                            ..
               "./l?.so;"                           ..
               "/usr/local/lib/lua/5.0/?.so;"       ..
               "/usr/local/lib/lua/5.0/l?.so"       )

--
-- make sure require works with standard libraries
--
package.loaded = package.loaded or {}
package.loaded.debug     = debug
package.loaded.string    = string
package.loaded.math      = math
package.loaded.io        = io
package.loaded.os        = os
package.loaded.table     = table 
package.loaded.base      = _G
package.loaded.coroutine = coroutine
local _LOADED = package.loaded

--
-- avoid overwriting the package.preload table if it's already there
--
package.preload = package.preload or {}
local _PRELOAD = package.preload


--
-- looks for a file `name' in given path
--
local function findfile (name, pname)
	name = gsub (name, "%.", LUA_DIRSEP)
	local path = _PACKAGE[pname]
	assert (type(path) == "string", format ("package.%s must be a string", pname))
	for c in gfind (path, "[^;]+") do
		c = gsub (c, "%"..LUA_PATH_MARK, name)
		local f = io.open (c)
		if f then
			f:close ()
			return c
		end
	end
	return nil -- not found
end


--
-- check whether library is already loaded
--
local function loader_preload (name)
	assert (type(name) == "string", format (
		"bad argument #1 to `require' (string expected, got %s)", type(name)))
	assert (type(_PRELOAD) == "table", "`package.preload' must be a table")
	return _PRELOAD[name]
end


--
-- Lua library loader
--
local function loader_Lua (name)
	assert (type(name) == "string", format (
		"bad argument #1 to `require' (string expected, got %s)", type(name)))
	local filename = findfile (name, "path")
	if not filename then
		return false
	end
	local f, err = loadfile (filename)
	if not f then
		error (format ("error loading module `%s' (%s)", name, err))
	end
	return f
end


local function mkfuncname (name)
	name = gsub (name, "^.*%"..LUA_IGMARK, "")
	name = gsub (name, "%.", LUA_OFSEP)
	return POF..name
end

local function old_mkfuncname (name)
	--name = gsub (name, "^.*%"..LUA_IGMARK, "")
	name = gsub (name, "%.", OLD_LUA_OFSEP)
	return POF..name
end

--
-- C library loader
--
local function loader_C (name)
	assert (type(name) == "string", format (
		"bad argument #1 to `require' (string expected, got %s)", type(name)))
	local filename = findfile (name, "cpath")
	if not filename then
		return false
	end
	local funcname = mkfuncname (name)
	local f, err = loadlib (filename, funcname)
	if not f then
		funcname = old_mkfuncname (name)
		f, err = loadlib (filename, funcname)
		if not f then
			error (format ("error loading module `%s' (%s)", name, err))
		end
	end
	return f
end


local function loader_Croot (name)
	local p = gsub (name, "^([^.]*).-$", "%1")
	if p == "" then
		return
	end
	local filename = findfile (p, "cpath")
	if not filename then
		return
	end
	local funcname = mkfuncname (name)
	local f, err, where = loadlib (filename, funcname)
	if f then
		return f
	elseif where ~= "init" then
		error (format ("error loading module `%s' (%s)", name, err))
	end
end

-- create `loaders' table
package.loaders = package.loaders or { loader_preload, loader_Lua, loader_C, loader_Croot, }
local _LOADERS = package.loaders


--
-- iterate over available loaders
--
local function load (name, loaders)
	-- iterate over available loaders
	assert (type (loaders) == "table", "`package.loaders' must be a table")
	for i, loader in ipairs (loaders) do
		local f = loader (name)
		if f then
			return f
		end
	end
	error (format ("module `%s' not found", name))
end

-- sentinel
local sentinel = function () end

--
-- new require
--
function _G.require (modname)
	assert (type(modname) == "string", format (
		"bad argument #1 to `require' (string expected, got %s)", type(name)))
	local p = _LOADED[modname]
	if p then -- is it there?
		if p == sentinel then
			error (format ("loop or previous error loading module '%s'", modname))
		end
		return p -- package is already loaded
	end
	local init = load (modname, _LOADERS)
	_LOADED[modname] = sentinel
	local actual_arg = _G.arg
	_G.arg = { modname }
	local res = init (modname)
	if res then
		_LOADED[modname] = res
	end
	_G.arg = actual_arg
	if _LOADED[modname] == sentinel then
		_LOADED[modname] = true
	end
	return _LOADED[modname]
end


-- findtable
local function findtable (t, f)
	assert (type(f)=="string", "not a valid field name ("..tostring(f)..")")
	local ff = f.."."
	local ok, e, w = find (ff, '(.-)%.', 1)
	while ok do
		local nt = rawget (t, w)
		if not nt then
			nt = {}
			t[w] = nt
		elseif type(t) ~= "table" then
			return sub (f, e+1)
		end
		t = nt
		ok, e, w = find (ff, '(.-)%.', e+1)
	end
	return t
end

--
-- new package.seeall function
--
function _PACKAGE.seeall (module)
	local t = type(module)
	assert (t == "table", "bad argument #1 to package.seeall (table expected, got "..t..")")
	local meta = getmetatable (module)
	if not meta then
		meta = {}
		setmetatable (module, meta)
	end
	meta.__index = _G
end


--
-- new module function
--
function _G.module (modname, ...)
	local ns = _LOADED[modname]
	if type(ns) ~= "table" then
		ns = findtable (_G, modname)
		if not ns then
			error (string.format ("name conflict for module '%s'", modname))
		end
		_LOADED[modname] = ns
	end
	if not ns._NAME then
		ns._NAME = modname
		ns._M = ns
		ns._PACKAGE = gsub (modname, "[^.]*$", "")
	end
	setfenv (2, ns)
	for i, f in ipairs (arg) do
		f (ns)
	end
end

