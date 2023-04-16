module protocol

import util

struct ResPacket {
	id int
pub mut:
	data []u8
}

pub fn new_res_packet(id int) ResPacket {
	return ResPacket{
		id: id
	}
}

pub fn (p ResPacket) encode() []u8 {
	iddata := encode_varint(p.id)
	mut res := encode_varint(p.data.len + iddata.len)
	res << iddata
	res << p.data
	return res
}

pub fn (mut p ResPacket) varint(i int) {
	p.data << encode_varint(i)
}

pub fn (mut p ResPacket) string(str string) ? {
	if str.len > 131071 {
		return error('string too large')
	}
	p.varint(str.len)
	p.data << str.bytes()
}

pub fn (mut p ResPacket) identifier(namespace string, thing string) ? {
	str := '$namespace:$thing'
	if str.len > 32767 {
		return error('identifier too large')
	}
	p.string(str)?
}

pub fn (mut p ResPacket) uuid(id [16]u8) {
	p.data << id[..]
}

pub fn (mut p ResPacket) bool(b bool) {
	if b {
		p.data << 0x01
	} else {
		p.data << 0x00
	}
}

pub fn (mut p ResPacket) ubyte(i u8) {
	p.data << i
}

pub fn (mut p ResPacket) byte(i i8) {
	p.data << util.byteb(i)
}

pub fn (mut p ResPacket) ushort(i u16) {
	p.data << util.ushortb(i)
}

pub fn (mut p ResPacket) short(i i16) {
	data := Short{
		short: i
	}
	unsafe {
		p.data << data.bytes[..]
	}
}

pub fn (mut p ResPacket) uint(i u32) {
	data := Int{
		uint: i
	}
	unsafe {
		p.data << data.bytes[..]
	}
}

pub fn (mut p ResPacket) int(i int) {
	data := Int{
		int: i
	}
	unsafe {
		p.data << data.bytes[..]
	}
}

pub fn (mut p ResPacket) ulong(i u64) {
	data := Long{
		ulong: i
	}
	unsafe {
		p.data << data.bytes[..]
	}
}

pub fn (mut p ResPacket) long(i i64) {
	data := Long{
		long: i
	}
	unsafe {
		p.data << data.bytes[..]
	}
}

pub fn (mut p ResPacket) float(i f32) {
	p.data << util.floatb(i)
}

pub fn (mut p ResPacket) double(i f64) {
	p.data << util.doubleb(i)
}
