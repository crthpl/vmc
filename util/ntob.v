module util

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
	uint  u32
	int   int
	float f32
mut:
	bytes [4]u8
}

union Long {
	ulong  u64
	long   i64
	double f64
mut:
	bytes [8]u8
}

pub fn ubyteb(i u8) []u8 {
	return [i]
}

pub fn byteb(i i8) []u8 {
	data := Byte{
		byte: i
	}
	unsafe {
		return [data.ubyte]
	}
}

pub fn ushortb(i u16) []u8 {
	data := Short{
		ushort: i
	}
	unsafe {
		return data.bytes[..].reverse() // big endian
	}
}

pub fn shortb(i i16) []u8 {
	data := Short{
		short: i
	}
	unsafe {
		return data.bytes[..].reverse()
	}
}

pub fn uintb(i u32) []u8 {
	data := Int{
		uint: i
	}
	unsafe {
		return data.bytes[..].reverse()
	}
}

pub fn intb(i int) []u8 {
	data := Int{
		int: i
	}
	unsafe {
		return data.bytes[..].reverse()
	}
}

pub fn ulongb(i u64) []u8 {
	data := Long{
		ulong: i
	}
	unsafe {
		return data.bytes[..].reverse()
	}
}

pub fn longb(i i64) []u8 {
	data := Long{
		long: i
	}
	unsafe {
		return data.bytes[..].reverse()
	}
}

pub fn floatb(i f32) []u8 {
	data := Int{
		float: i
	}
	unsafe {
		return data.bytes[..].reverse()
	}
}

pub fn doubleb(i f64) []u8 {
	data := Long{
		double: i
	}
	unsafe {
		return data.bytes[..].reverse()
	}
}
