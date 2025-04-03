local Common = require("../common")

local MMU = {
	MEMORY_SIZE = 0x10000,
}

function MMU.read8(state: Common.GBState, addr: number): number
	return buffer.readu8(state[MEMORY_WRAM], addr)
end

function MMU.read8_signed(state: Common.GBState, addr: number): number
	return buffer.readi8(state[MEMORY_WRAM], addr)
end

function MMU.read16(state: Common.GBState, addr: number): number
	return buffer.readu16(state[MEMORY_WRAM], addr)
end

function MMU.write8(state: Common.GBState, addr: number, value: number): ()
	buffer.writeu8(state[MEMORY_WRAM], addr, value)
end

function MMU.write8_signed(state: Common.GBState, addr: number, value: number): ()
	buffer.writeu8(state[MEMORY_WRAM], addr, value)
end

function MMU.write16(state: Common.GBState, addr: number, value: number): ()
	buffer.writeu16(state[MEMORY_WRAM], addr, value)
end

function MMU.init(state: Common.GBState): ()
	state[MEMORY_WRAM] = buffer.create(MMU.MEMORY_SIZE)
end

function MMU.writeROM(state: Common.GBState, rom: buffer): ()
	buffer.copy(state[MEMORY_WRAM], 0, rom, 0, 0x8000)
end

return MMU
