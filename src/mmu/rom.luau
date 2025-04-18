local GlobalCommon = require("../common")
local Common = require("./common")

local ROM_READ = Common.MMU_READ
local ROM_WRITE = Common.MMU_WRITE

local MBC_READ: { [MBC_IDX]: Common.MemoryReadHandler } = {}
local MBC_WRITE: { [MBC_IDX]: Common.MemoryWriteHandler } = {}

local function rom_read_16kb(state, addr)
	return buffer.readu8(state[MEMORY_ROM], addr)
end

MBC_READ[MBC_NONE] = rom_read_16kb
MBC_WRITE[MBC_NONE] = Common.noop

MBC_READ[MBC1] = function(state, addr)
	return rom_read_16kb(state, bit32.bor(bit32.lshift(state[MBC_BANK], 14), bit32.band(addr, 0x1FFF)))
end

MBC_WRITE[MBC1] = function(state, addr)
	state[MBC_BANK] = math.max(1, bit32.band(addr, state[MBC_MASK]))
end

local function rom_read_mbc(state, addr)
	return MBC_READ[state[MBC_MODE]](state, addr)
end

local function rom_write_mbc(state, addr, value)
	MBC_WRITE[state[MBC_MODE]](state, addr, value)
end

for addr = 0x0000, 0x3FFF do
	ROM_READ[addr] = rom_read_16kb
end

for addr = 0x4000, 0x7FFF do
	ROM_READ[addr] = rom_read_mbc
end

local function ram_enable()
	-- TODO: implement MBC RAM
end

for addr = 0x0000, 0x1FFF do
	ROM_WRITE[addr] = ram_enable
end

for addr = 0x2000, 0x3FFF do
	ROM_WRITE[addr] = rom_write_mbc
end

local MBC_MAPPINGS: { [number]: MBC_IDX } = {
	[0x00] = MBC_NONE,
	[0x01] = MBC1,
	[0x02] = MBC1,
	[0x03] = MBC1,
	[0x05] = MBC2,
	[0x06] = MBC2,
	[0x0F] = MBC3,
	[0x10] = MBC3,
	[0x12] = MBC3,
	[0x11] = MBC3,
	[0x13] = MBC3,
	[0x19] = MBC5,
	[0x1A] = MBC5,
	[0x1B] = MBC5,
	[0x1C] = MBC5,
	[0x1D] = MBC5,
	[0x1E] = MBC5,
}

local function load_rom(state: GlobalCommon.GBState, rom: buffer)
	local rom_size = buffer.len(rom)
	local size_bits = math.log(rom_size, 2)

	if size_bits ~= math.floor(size_bits) or size_bits < 15 or size_bits > 19 then
		error(`Invalid ROM size: {rom_size}`)
	end

	local mbc_mode = buffer.readu8(rom, 0x0147)
	state[MBC_MODE] = MBC_MAPPINGS[mbc_mode] or MBC_MAPPINGS[0x00]

	local mask_bits = size_bits - 13
	state[MBC_MASK] = 2 ^ mask_bits - 1

	state[MEMORY_ROM] = rom
	state[MBC_BANK] = 1
end

return {
	load_rom = load_rom,
}
