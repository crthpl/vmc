module main

import protocol
import nbt
import packets
import dimcodec
import time

fn main() {
	mut listener := protocol.listen(25565) ?
	defer {
		listener.close() or { println('Failed to close listener') }
	}
	conns := chan &protocol.Conn{cap: 1}
	go loop(conns)
	for {
		conns <- listener.accept() ?
	}
}

struct Server {
mut:
	last_eid int
	packeter packets.Packeter
	conn     &protocol.Conn
}

fn loop(global_conns chan &protocol.Conn) {
	mut conns := []&protocol.Conn{}
	mut s := Server{
		packeter: packets.Packeter{
			server: true
		}
		conn: 0
	}
	for {
		tick_start := time.now()
		for {
			if global_conns.len == 0 {
				break
			}
			conns << <-global_conns
		}
		for i, conn in conns {
			s.packeter.version = s.conn.version
			unsafe {
				s.conn = conn
			}
			for {
				packet := s.conn.read_packet() or {
					if err == protocol.err_timed_out {
						break
					}
					s.conn.close() or { panic(err) }
					conns.delete(i)
					eprintln('client kicked by server, reason: $err [R]')
					break
				}
				s.handle_packet(packet) or {
					s.conn.close() or { panic(err) }
					conns.delete(i)
					eprintln('client kicked by server, reason: $err [H]')
					break
				}
				time.sleep(1 * time.millisecond)
			}
		}
		if time.since(tick_start) < tick_length {
			time.sleep(tick_length - time.since(tick_start))
		} else {
			eprintln('tick took ${time.since(tick_start).milliseconds() - 50} too long')
		}
	}
}

const (
	tick_length = 50 * time.millisecond
	status      = '{"version": {"name": "1.17.1", "protocol": 756}, "players": {"max": -1, "online": 2147483647, "sample": [{"name": "someone", "id": "00000000-0000-0000-0000-000000000000"}]}, "description": {"text": "The Minecraft Server"}}'
)

fn (mut s Server) handle_packet(_p protocol.Packet) ? {
	println('$s.conn.state, $_p.id')
	p := s.packeter.decode(_p, packets.State(s.conn.state)) ?
	match p {
		packets.Handshake {
			s.conn.version = p.version
			s.packeter.version = p.version
			s.conn.state = int(p.state)
		}
		packets.Request {
			s.write(packets.Response{status}) ?
		}
		packets.Ping {
			println('pong $p.payload')
		}
	}
}

fn (mut s Server) join_game() ? {
	mut res := protocol.new_res_packet(0x26)
	res.int(s.new_eid()) // eid
	res.bool(false) // is hardcore
	res.ubyte(1) // gamemode: 0: Survival, 1: Creative, 2: Adventure, 3: Spectator
	res.byte(1) // previous gamemode: 0: Survival, 1: Creative, 2: Adventure, 3: Spectator, -1: No previous gamemode
	res.varint(1) // amount of worlds, length of following array
	res.identifier('vmc', 'overworld') ? // list of worlds
	res.data << nbt.encode('', dimcodec.codec) // dimension codec
	res.data << nbt.encode('', dimcodec.dims[0] as map[string]nbt.Any['element'] or {
		panic('invalid dimension codec')
	} as map[string]nbt.Any) // dimension
	res.identifier('vmc', 'overworld') ? // world spawned into
	res.long(0) // hashed seed
	res.varint(100) // max players, now ignored
	res.varint(16) // render distance
	res.bool(false) // reduced debug info
	res.bool(true) // oppisite of doImmediateRespawn gamerule
	res.bool(false) // is debug world
	res.bool(true) // is flat world
	s.conn.write(res.encode()) ?
}

fn (mut s Server) write(p packets.Packet) ? {
	s.conn.write(s.packeter.encode(p)) ?
}

fn (mut s Server) new_eid() int {
	s.last_eid++
	return s.last_eid
}
