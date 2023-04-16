module util

pub fn bubyte(i []u8) u8 {
	return i[0]
}

pub fn bbyte(i []u8) i8 {
	data := Byte{}
	unsafe {
		data.bytes[0] = i[0]
	}
	unsafe {
		return data.byte
	}
}

pub fn bushort(i []u8) u16 {
	data := Short{}
	unsafe {
		data.bytes[0] = i[0]
		data.bytes[1] = i[1]
	}
	unsafe {
		return data.ushort
	}
}

pub fn bshort(i []u8) i16 {
	data := Short{}
	unsafe {
		data.bytes[0] = i[0]
		data.bytes[1] = i[1]
	}
	unsafe {
		return data.short
	}
}

pub fn buint(i []u8) u32 {
	data := Int{}
	unsafe {
		data.bytes[0] = i[0]
		data.bytes[1] = i[1]
		data.bytes[2] = i[2]
		data.bytes[3] = i[3]
	}
	unsafe {
		return data.uint
	}
}

pub fn bint(i []u8) int {
	data := Int{}
	unsafe {
		data.bytes[0] = i[0]
		data.bytes[1] = i[1]
		data.bytes[2] = i[2]
		data.bytes[3] = i[3]
	}
	unsafe {
		return data.int
	}
}

pub fn bulong(i []u8) u64 {
	data := Long{}
	unsafe {
		data.bytes[0] = i[0]
		data.bytes[1] = i[1]
		data.bytes[2] = i[2]
		data.bytes[3] = i[3]
		data.bytes[4] = i[4]
		data.bytes[5] = i[5]
		data.bytes[6] = i[6]
		data.bytes[7] = i[7]
	}
	unsafe {
		return data.ulong
	}
}

pub fn blong(i []u8) i64 {
	data := Long{}
	unsafe {
		data.bytes[0] = i[0]
		data.bytes[1] = i[1]
		data.bytes[2] = i[2]
		data.bytes[3] = i[3]
		data.bytes[4] = i[4]
		data.bytes[5] = i[5]
		data.bytes[6] = i[6]
		data.bytes[7] = i[7]
	}
	unsafe {
		return data.long
	}
}

pub fn bfloat(i []u8) f32 {
	data := Int{}
	unsafe {
		data.bytes[0] = i[0]
		data.bytes[1] = i[1]
		data.bytes[2] = i[2]
		data.bytes[3] = i[3]
	}
	unsafe {
		return data.float
	}
}

pub fn bdouble(i []u8) f64 {
	data := Long{}
	unsafe {
		data.bytes[0] = i[0]
		data.bytes[1] = i[1]
		data.bytes[2] = i[2]
		data.bytes[3] = i[3]
		data.bytes[4] = i[4]
		data.bytes[5] = i[5]
		data.bytes[6] = i[6]
		data.bytes[7] = i[7]
	}
	unsafe {
		return data.double
	}
}
