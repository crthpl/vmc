module packets

import protocol

pub fn (pker Packeter) decode(_p protocol.Packet, state State) ?Packet {
	mut p := _p
	unknown := error('unknown serverbound packet id $p.id in state $state for version $pker.version')
	if !pker.server {
		return error('only serverside supported')
	} else {
		match state {
			.handshake {
				match p.id {
					handshake {
						version := p.varint() ?
						address := p.string() ?
						port := p.ushort()
						next_state := State(p.varint() ?)
						return Handshake{
							version: version
							address: address
							port: port
							state: next_state
						}
					}
					else {
						return unknown
					}
				}
			}
			.status {
				match p.id {
					request {
						return Request{}
					}
					ping {
						return Ping{
							payload: p.long()
						}
					}
					else {
						return unknown
					}
				}
			}
			else {
				return unknown
			}
		}
	}
}
