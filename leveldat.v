import nbt

fn main() {
	println(nbt.encode('', {
		'Data': {
			'allowCommands': nbt.Any(1)
		}
	}).bytestr())
}
