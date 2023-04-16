module dimcodec

import nbt { Any }

const (
	overworld = {
		'name':    Any('vmc:overworld')
		'id':      Any(0)
		'element': Any({
			'ambient_light':        Any(f32(0.0))
			'bed_works':            Any(true)
			'coordinate_scale':     Any(f64(1.0))
			'effects':              Any('minecraft:overworld')
			'has_ceiling':          Any(false)
			'has_raids':            Any(true)
			'has_skylight':         Any(true)
			'height':               Any(256)
			'infiniburn':           Any('minecraft:infiniburn_overworld')
			'logical_height':       Any(256)
			'min_y':                Any(0)
			'natural':              Any(true)
			'piglin_safe':          Any(false)
			'respawn_anchor_works': Any(false)
			'ultrawarm':            Any(false)
		})
	}
	plains = {
		'name':    Any('minecraft:plains')
		'id':      Any(0)
		'element': Any({
			'precipitation': Any('rain')
			'depth':         Any(f32(0.125))
			'temperature':   Any(f32(0.8))
			'scale':         Any(f32(0.05))
			'downfall':      Any(f32(0.4))
			'category':      Any('plains')
			'effects':       Any({
				'sky_color':       Any(7907327)
				'water_fog_color': Any(329011)
				'fog_color':       Any(12638463)
				'water_color':     Any(329011)
			})
		})
	}
)

pub const (
	dims   = [Any(overworld)]
	biomes = [Any(plains)]
	codec  = {
		'minecraft:dimension_type': Any({
			'type':  Any('minecraft:dimension_type')
			'value': Any(dims)
		})
		'minecraft:worldgen/biome': Any({
			'type':  Any('minecraft:worldgen/biome')
			'value': Any(biomes)
		})
	}
)
