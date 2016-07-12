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
	out_file_handle = io.open(outfile, 'wb')

	-- Check handles
	if not in_file_handle then
		io.stderr:write("Error opening input file")
		return 2
	end

	if not out_file_handle then
		io.stderr:write("Error opening output file")
		return 2
	end

	-- Process line
	for line in io.lines(infile) do
		bytes = compileLine(line)
	end

	-- Write bytes

	in_file_handle:close()
	out_file_handle:close()
end

function compileLine(line)
	print("Line: " .. tostring(line))
	
	local bytes = {}
	local dec_line = str_split(line)
	local instruction = compileArch[dec_line[1]]
	local n_bytes = instruction.n_bytes

	bytes[1] = instruction.opcode
	for i = 2, n_bytes + 1 do
		bytes[i] = tonumber(dec_line[i])
	end

	return bytes
end

function writeByte()
end

function str_split(str, reg)
    reg = reg or "%S+"
    local spl = {}
    local count = 1

    for i in string.gmatch(str, reg) do
        spl[count] = i
        count = count + 1
    end

    return spl
end

compileArch = {
	["ADD"] = {
		n_bytes = 1,
		opcode = 0x01
	},
	["MOV"] = {
		n_bytes = 3,
		opcode = 0xC0
	},
}

local ok, err = pcall(main)
if not ok then
	io.stderr:write("Something went wrong :(\nError: " .. err .. "\n")
end