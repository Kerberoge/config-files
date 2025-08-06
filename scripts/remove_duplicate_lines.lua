#!/bin/lua

-- Lua script to remove duplicate lines from a file without
-- affecting the original line order.

file = arg[1]
lines, lines_idx = {}, {}
f = io.open(file, "r")

for l in f:lines() do
	table.insert(lines, l)
end
f:close()

-- make a copy that preserves original indices
for i,v in pairs(lines) do
	table.insert(lines_idx, {["idx"] = i, ["line"] = v})
end
lines = nil

-- sort lines
table.sort(lines_idx, function (a, b)
	if a["line"] ~= b["line"] then
		return b["line"] > a["line"]
	else
		return b["idx"] > a["idx"]
	end
end)

-- remove duplicates
for i,t in pairs(lines_idx) do
	while lines_idx[i+1] and lines_idx[i+1]["line"] == t["line"] do
		table.remove(lines_idx, i+1)
	end
end

-- unsort lines
table.sort(lines_idx, function (a, b) return b["idx"] > a["idx"] end)

for i,v in pairs(lines_idx) do
	print(v["line"])
end
