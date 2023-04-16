module protocol

import net
import io
import time

struct Listener {
mut:
	listener &net.TcpListener
}

pub fn listen(port int) ?Listener {
	listener := Listener{
		listener: net.listen_tcp(.ip, 'localhost:$port')?
	}
	return listener
}

pub fn (mut l Listener) close() ? {
	l.listener.close()?
}

pub enum ChatMode {
	enabled = 0
	commands_only = 1
	hidden = 2
}

struct Conn {
mut:
	conn &net.TcpConn
pub mut:
	version        int
	state          int
	username       string
	eid            int
	skin_parts     u8
	right_handed   bool
	view_distance  int
	locale         string
	chat_mode      ChatMode
	chat_colors    bool
	text_filtering bool
	brand          string
	x              f64
	y              f64
	z              f64
	yaw            f32
	pitch          f32
}

pub fn (mut l Listener) accept() ?&Conn {
	mut conn := &Conn{
		conn: l.listener.accept()?
	}

	conn.conn.set_read_timeout(0)
	return conn
}

pub fn (mut c Conn) close() ? {
	c.conn.close()?
}

fn (mut c Conn) read_any() ?[]u8 {
	return io.read_any(mut c.conn)
}

pub const (
	timeout_length = 1 * time.second
	err_timed_out  = net.err_timed_out
)

fn (mut c Conn) read_bytes(len int) ?[]u8 {
	mut res := []u8{len: len}
	mut remaining := len
	start := time.now()
	for {
		remaining -= c.conn.read(mut res[len - remaining..])?
		if remaining <= 0 {
			return res
		}
		if time.since(start) > protocol.timeout_length {
			return net.err_timed_out
		}
	}
	return res
}

pub fn (mut c Conn) write(data []u8) ? {
	mut remaining := data.len
	start := time.now()
	for {
		remaining -= c.conn.write(data[data.len - remaining..])?
		if remaining <= 0 {
			return
		}
		if time.since(start) > protocol.timeout_length {
			return net.err_timed_out
		}
	}
}
