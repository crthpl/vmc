module nbt

fn test_nbt() ? {
	print(encode('AA', {
		'a': Any(42)
		'b': Any('hello world')
	}).bytestr())
}
