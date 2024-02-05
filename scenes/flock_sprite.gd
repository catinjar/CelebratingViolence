extends Sprite2D

@export var resolution : Vector2

var flock

func _ready():
	hide()
	
	flock = FlockCpp.new()
	flock.set_owner(self)
	
	var image = texture.get_image()
	var size : Vector2 = image.get_size()
	flock.set_size(image.get_size())
		
	assert(resolution.x > 0)
	assert(resolution.y > 0)
	
	var width = image.get_width() / resolution.x
	var height = image.get_height() / resolution.y
	
	for y in height:
		for x in width:
			var pixel_x = x * resolution.x
			var pixel_y = y * resolution.y
			
			var color = image.get_pixel(pixel_x, pixel_y)
			color *= modulate * self_modulate
			
			if color.a == 0:
				continue
			
			var random_offset = Vector2(-0.5 + randf() * 30, -0.5 + randf() * 30)
			
			var target_position = Vector2(randf() * image.get_width(), randf() * image.get_height()) + random_offset
			target_position *= global_scale
			
			if flip_h:
				target_position.x = size.x * global_scale.x - target_position.x
			if flip_v:
				target_position.y = size.y * global_scale.y - target_position.y
			if centered:
				target_position -= size * global_scale / 2
			
			target_position += offset * global_scale            
			
			if global_rotation != 0:
				target_position = target_position.rotated(global_rotation)
			
			target_position += global_position
			
			var dot = FlockDotCpp.new()
			dot.set_current_position(target_position)
			dot.set_target_position(Vector2(pixel_x, pixel_y) + Vector2(-0.5 + randf(), -0.5 + randf()) * 5)
			dot.set_color(color)
			
			flock.add_dot(dot)
	
	FlockMeshCpp.add_flock(flock)
	
func _exit_tree():
	FlockMeshCpp.remove_flock(flock)
