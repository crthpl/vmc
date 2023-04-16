module protocol

import util

pub fn (mut c Conn) read_packet() ?Packet {
	mut data := []u8{}
	for {
		data << c.read_bytes(1)?
		if data.last() < 0x80 {
			break
		}
	}

	len := read_varint(mut data)?
	data = c.read_bytes(len)?
	id := read_varint(mut data)?
	datalen := len - encode_varint(id).len
	if data.len < datalen {
		data << c.read_bytes(datalen - data.len)?
	}
	return Packet{
		id: id
		data: data
	}
}

pub struct Packet {
pub:
	id int
pub mut:
	data []u8
}

pub fn (mut p Packet) varint() ?int {
	return read_varint(mut p.data)
}

pub fn (mut p Packet) string() ?string {
	len := p.varint()?
	str := p.data[..len].bytestr()
	p.data = p.data[len..]
	return str
}

pub fn (mut p Packet) bool() bool {
	return p.ubyte() != 0
}

pub fn (mut p Packet) ubyte() u8 {
	ret := util.bubyte(p.data)
	p.data = p.data[1..]
	return ret
}

pub fn (mut p Packet) byte() i8 {
	ret := util.bbyte(p.data)
	p.data = p.data[1..]
	return ret
}

pub fn (mut p Packet) ushort() u16 {
	ret := util.bushort(p.data)
	p.data = p.data[2..]
	return ret
}

pub fn (mut p Packet) short() i16 {
	ret := util.bshort(p.data)
	p.data = p.data[2..]
	return ret
}

pub fn (mut p Packet) uint() u32 {
	ret := util.buint(p.data)
	p.data = p.data[4..]
	return ret
}

pub fn (mut p Packet) int() int {
	ret := util.bint(p.data)
	p.data = p.data[4..]
	return ret
}

pub fn (mut p Packet) ulong() u64 {
	ret := util.bulong(p.data)
	p.data = p.data[8..]
	return ret
}

pub fn (mut p Packet) long() i64 {
	ret := util.blong(p.data)
	p.data = p.data[8..]
	return ret
}

pub fn (mut p Packet) float() f32 {
	ret := util.bfloat(p.data)
	p.data = p.data[4..]
	return ret
}

pub fn (mut p Packet) double() f64 {
	ret := util.bdouble(p.data)
	p.data = p.data[8..]
	return ret
}
