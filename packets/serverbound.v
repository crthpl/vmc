module packets

pub enum State {
	handshake = 0
	status = 1
	login = 2
	play = 3
}

const (
	handshake = 0
	request   = 0
	ping      = 1
)

pub struct Handshake {
pub:
	version int
	address string
	port    u16
	state   State
}

pub struct Request {}

pub struct Ping {
pub:
	payload i64
}
