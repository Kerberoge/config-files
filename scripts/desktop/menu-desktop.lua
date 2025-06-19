#!/bin/lua

-- tiny lua script for launching programs from .desktop files, comparable to j4-dmenu-desktop

function split(str, delim)
	local t = {}
	local i = 1

	for s in str:gmatch('([^' .. delim .. ']+)') do
		t[i] = s
		i = i + 1
	end
	
	return t
end

function path_exists(path)
	local f = io.open(path, "r")
	
	if f == nil then return false end
	io.close(f)

	return true
end

function desktop_file_exists(filename)
	for i,t in pairs(desktop_files) do
		if t["filename"] == filename then
			return true
		end
	end

	return false
end

function get_value(path, key)
	local f = assert(io.open(path, "r"))
	local i, j, match

	for line in f:lines() do
		i, j, match = line:find(key .. "=(.*)")
		if match ~= nil then
			io.close(f)
			return match
		end
	end

	io.close(f)
	return nil
end

function sort_by_key(t, key)
	local sorted_keys, old_indices, sorted_table = {}, {}, {}

	for i,t in pairs(t) do
		table.insert(sorted_keys, t[key])
	end
	for i,k in pairs(sorted_keys) do
		old_indices[k] = i
	end
	table.sort(sorted_keys)
	for i,k in ipairs(sorted_keys) do
		table.insert(sorted_table, t[old_indices[k]])
	end

	return sorted_table
end



desktop_files = {}
programs = {}
menu_program = "mew"
tmpfile = "/tmp/menu_desktop_entries"

if os.getenv("XDG_DATA_DIRS") ~= nil then
	data_dirs = os.getenv("XDG_DATA_DIRS")
else
	data_dirs = os.getenv("HOME") .. "/.local/share:/usr/share"
end

-- find all desktop files
for i,dir in pairs(split(data_dirs, ":")) do
	dir = dir .. "/applications"
	if not path_exists(dir) then goto continue end

	local output = assert(io.popen("cd " .. dir .. "; ls *.desktop"))
	for line in output:lines() do
		if not desktop_file_exists(line) then
			table.insert(desktop_files, {dir = dir, filename = line})
		end
	end
	io.close(output)

	::continue::
end

-- remove files that are to be hidden
for i,t in pairs(desktop_files) do
	local path = t["dir"] .. "/" .. t["filename"]

	if get_value(path, "NoDisplay") == "true" then
		desktop_files[i] = nil
	end
end

-- create list of program names and associated commands
for i,t in pairs(desktop_files) do
	local path = t["dir"] .. "/" .. t["filename"]
	local name = get_value(path, "Name")
	local cmd = get_value(path, "Exec")

	-- strip unnecessary tokens like %u and %F
	cmd = cmd:gsub("%%%a", "")

	table.insert(programs, {name = name, cmd = cmd})
end
programs = sort_by_key(programs, "name")

-- since it is not possible to both read from and write to a spawned command in lua,
-- write the list of programs to a temporary file
do
	local f = assert(io.open(tmpfile, "w"))

	for i,t in ipairs(programs) do
		f:write(t["name"] .. "\n")
	end
	io.close(f)
end

-- launch menu program
do
	local f = assert(io.popen(menu_program .. " < " .. tmpfile, "r"))
	choice = f:read()

	io.close(f)
	os.remove(tmpfile)
end

-- launch chosen program
for i,t in pairs(programs) do
	if t["name"] == choice then
		os.execute(t["cmd"] .. " &")
		break
	end
end
