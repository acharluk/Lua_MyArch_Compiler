local args = { ... }
local in_file_handle, out_file_handle

function main()

	if #args ~= 2 then
		io.stderr:write("Usage: lua compiler.lua <input file> <output file>\n")
		return 1
	end

	local infile  = args[1]
	local outfile = args[2]

	in_file_handle  = io.open(infile, 'r')
	out_file_handle = io.open(infile, 'wb')

	-- Check handles

	-- Process line


	-- Write bytes

	in_file_handle:close()
	out_file_handle:close()
end

function compileLine()
end

function writeByte()
end

local ok, err = pcall(main)
if not ok then
	io.stderr:write("Something went wrong :(\nError: " .. err .. "\n")
end