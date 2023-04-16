module nbt

import util

const (
	tag_end        = u8(0)
	tag_byte       = u8(1)
	tag_short      = u8(2)
	tag_int        = u8(3)
	tag_long       = u8(4)
	tag_float      = u8(5)
	tag_double     = u8(6)
	tag_byte_array = u8(7)
	tag_string     = u8(8)
	tag_list       = u8(9)
	tag_compound   = u8(10)
	tag_int_array  = u8(11)
	tag_long_array = u8(12)
)

struct Nbt {
mut:
	data []u8
}

pub type Any = []Any
	| []i64
	| []int
	| []u8
	| bool
	| f32
	| f64
	| i16
	| i64
	| i8
	| int
	| map[string]Any
	| string

fn (a Any) typ() u8 {
	return match a {
		f32 {
			nbt.tag_float
		}
		f64 {
			nbt.tag_double
		}
		i8 {
			nbt.tag_byte
		}
		bool {
			nbt.tag_byte
		}
		i16 {
			nbt.tag_short
		}
		int {
			nbt.tag_int
		}
		i64 {
			nbt.tag_long
		}
		string {
			nbt.tag_string
		}
		[]Any {
			nbt.tag_list
		}
		[]u8 {
			nbt.tag_byte_array
		}
		[]i64 {
			nbt.tag_long_array
		}
		[]int {
			nbt.tag_int_array
		}
		map[string]Any {
			nbt.tag_compound
		}
	}
}

pub fn encode(name string, a map[string]Any) []u8 {
	mut n := Nbt{}
	n.data << nbt.tag_compound
	n.string(name)
	n.compound(a)
	return n.data
}

fn (mut n Nbt) compound(c map[string]Any) {
	for tag, field in c {
		n.data << field.typ()
		n.string(tag)
		n.encode(field)
	}
	n.data << nbt.tag_end
}

fn (mut n Nbt) encode(a Any) {
	match a {
		f32 {
			n.float(a)
		}
		f64 {
			n.double(a)
		}
		i8 {
			n.byte(a)
		}
		bool {
			if a {
				n.byte(1)
			} else {
				n.byte(0)
			}
		}
		i16 {
			n.short(a)
		}
		int {
			n.int(a)
		}
		i64 {
			n.long(a)
		}
		string {
			n.string(a)
		}
		[]u8 {
			n.int(a.len)
			n.data << a
		}
		[]i64 {
			n.int(a.len)
			for b in a {
				n.long(b)
			}
		}
		[]int {
			n.int(a.len)
			for b in a {
				n.int(b)
			}
		}
		[]Any {
			n.data << a[0].typ()
			n.int(a.len)
			for b in a {
				n.encode(b)
			}
		}
		map[string]Any {
			n.compound(a)
		}
	}
}

fn (mut n Nbt) string(s string) {
	n.short(i16(s.len))
	n.data << s.bytes()
}

fn (mut n Nbt) byte(i i8) {
	n.data << util.byteb(i)
}

fn (mut n Nbt) short(i i16) {
	n.data << util.shortb(i)
}

fn (mut n Nbt) int(i int) {
	n.data << util.intb(i)
}

fn (mut n Nbt) long(i i64) {
	n.data << util.longb(i)
}

fn (mut n Nbt) float(i f32) {
	n.data << util.floatb(i)
}

fn (mut n Nbt) double(i f64) {
	n.data << util.doubleb(i)
}
