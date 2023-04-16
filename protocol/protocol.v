module protocol

union Byte {
	ubyte u8
	byte  i8
mut:
	bytes [1]u8
}

union Short {
	ushort u16
	short  i16
mut:
	bytes [2]u8
}

union Int {
	uint u32
	int  int
mut:
	bytes [4]u8
}

union Long {
	ulong u64
	long  i64
mut:
	bytes [8]u8
}

fn read_varint(mut bytes []u8) ?int {
	mut value := 0
	mut bit_offset := 0
	for {
		if bit_offset == 35 {
			return error('VarInt is too big')
		}
		current_byte := (*bytes)[0] or {
			print_backtrace()
			return error('unended varint')
		}
		bytes = bytes[1..]
		value |= (current_byte & 0b01111111) << bit_offset
		bit_offset += 7
		if (current_byte & 0b10000000) == 0 {
			break
		}
	}
	return value
}

pub fn encode_varint(_value int) []u8 {
	mut value := _value
	mut res := []u8{}
	for {
		if (value & 0xffffff80) == 0 {
			res << u8(value)
			return res
		}

		res << u8(value & 0b01111111 | 0b10000000)
		value >>= 7
	}
	return res
}
