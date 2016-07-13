local args = { ... }
local in_file_handle, out_file_handle
local bytes_written = 0
local last_str_byte = 0xFF

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

		-- Strings
		if line:find('"') then
			local str = line:sub(line:find('"') + 1, line:find('"',line:find('"') + 1) - 1)
			local str_len = #str

			local pos = out_file_handle:seek()
			out_file_handle:seek("set", last_str_byte - str_len + 1)

			for i = 1, str_len do
				out_file_handle:write( str:sub(i,i) )
			end

			out_file_handle:seek("set", pos)
			last_str_byte = last_str_byte - str_len

			writeBytes({
				compileArch["OUT"].op_code,
					last_str_byte + 1,
					str_len
				})
		else

			local bytes = compileLine(line)
			-- Write bytes
			writeBytes(bytes)
		end
	end

	
	for i = bytes_written, last_str_byte do
		writeBytes({0x00})
	end

	in_file_handle:close()
	out_file_handle:close()
end

function compileLine(line)
	-- Remove comments
	if line:find(';') then
		line = line:sub(1, line:find(';') - 1)
	end

	local bytes = {}
	local dec_line = str_split(line)
	local instruction = compileArch[dec_line[1]]
	local n_bytes = instruction.n_bytes

	bytes[1] = instruction.op_code
	for i = 2, n_bytes do
		print("BYTE:" .. tostring(dec_line[i]))
		bytes[i] = tonumber(dec_line[i], 16)
	end

	return bytes
end

function writeBytes(bytes)
	for i = 1, #bytes do
		out_file_handle:write(string.char( (bytes[i]) ))
		bytes_written = bytes_written + 1
	end
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
	["NOP"] = {
		n_bytes = 1,
		op_code = 0x00
	},


	["ADD"] = {
		n_bytes = 1,
		op_code = 0x01
	},
	["SUB"] = {
		n_bytes = 1,
		op_code = 0x02
	},
	["MUL"] = {
		n_bytes = 1,
		op_code = 0x03
	},
	["DIV"] = {
		n_bytes = 1,
		op_code = 0x04
	},
	["OR"] = {
		n_bytes = 1,
		op_code = 0x11
	},
	["AND"] = {
		n_bytes = 1,
		op_code = 0x12
	},
	["XOR"] = {
		n_bytes = 1,
		op_code = 0x13
	},

	["JMP"] = {
		n_bytes = 2,
		op_code = 0xEF
	},
	["LPC"] = {
		n_bytes = 2,
		op_code = 0xE0
	},
	["LDA"] = {
		n_bytes = 2,
		op_code = 0xE1
	},
	["LDB"] = {
		n_bytes = 2,
		op_code = 0xE2
	},

	["SPC"] = {
		n_bytes = 2,
		op_code = 0xF0
	},
	["STA"] = {
		n_bytes = 2,
		op_code = 0xF1
	},
	["STB"] = {
		n_bytes = 2,
		op_code = 0xF2
	},
	["STC"] = {
		n_bytes = 2,
		op_code = 0xF3
	},

	["MOV"] = {
		n_bytes = 3,
		op_code = 0xC0
	},

	["OUT"] = {
		n_bytes = 3,
		op_code = 0xA0
	},
	["IN"] = {
		n_bytes = 3,
		op_code = 0xA1
	},
	["OUT_RAW"] = {
		n_bytes = 3,
		op_code = 0xB0
	},
	["IN_RAW"] = {
		n_bytes = 3,
		op_code = 0xB1
	},

	["HALT"] = {
		n_bytes = 1,
		op_code = 0xFF
	},
}

local ok, err = pcall(main)
if not ok then
	io.stderr:write("Something went wrong :(\nError: " .. err .. "\n")
end