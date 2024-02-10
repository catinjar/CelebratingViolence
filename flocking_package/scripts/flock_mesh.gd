extends MultiMeshInstance2D

@export var flock_texture : Texture2D
@export var noise_texture : Texture2D
@export var size : Vector2 = Vector2(10, 10)
@export var resolution : Vector2
@export var noise_texture2 : Texture2D

var flocks : Array[Flock]

var rd : RenderingDevice
var pipeline : RID
var uniform_set : RID
var is_submitted = false

var dots : PackedFloat32Array
var flocks_array : PackedFloat32Array

var dots_buffer : RID
var flocks_buffer : RID

var params_buffer : RID
var noise_rid : RID

var max_instances = 32768
var max_flocks = 2048

func _ready():
	process_priority = 100
	
	var st = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-0.5, -0.5, 0))
		
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-0.5, 0.5, 0))
	
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(0.5, 0.5, 0))
	
	st.set_uv(Vector2(1, 0))
	st.add_vertex(Vector3(0.5, -0.5, 0))
	
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-0.5, -0.5, 0))
	
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(0.5, 0.5, 0))
	
	st.index()
	
	var mesh = st.commit()
	
	multimesh = MultiMesh.new()
	multimesh.mesh = mesh
	multimesh.use_colors = true
	multimesh.transform_format = MultiMesh.TRANSFORM_2D
	multimesh.instance_count = max_instances	
	multimesh.visible_instance_count = max_instances
	
	rd = RenderingServer.create_local_rendering_device()
	
	var shader_file = load("res://shaders/flock_compute.glsl")
	var shader_spirv = shader_file.get_spirv()
	var shader = rd.shader_create_from_spirv(shader_spirv)
	
	for i in max_instances:
		dots.append(0.0)
		dots.append(0.0)
		
		dots.append(0.0)
		dots.append(0.0)
		
		dots.append(0.0)
		dots.append(0.0)
		
		dots.append(0.0)
		dots.append(0.0)		
		
	for i in max_flocks:
		flocks_array.append(0.0)
		flocks_array.append(0.0)
		
		flocks_array.append(0.0)
		flocks_array.append(0.0)
		
		flocks_array.append(0.0)
		flocks_array.append(0.0)
		
		flocks_array.append(0.0)
		flocks_array.append(0.0)
		
		flocks_array.append(0.0)
		flocks_array.append(0.0)
		
		flocks_array.append(0.0)
		flocks_array.append(0.0)
	
	var dots_bytes = dots.to_byte_array()
	var flocks_bytes = flocks_array.to_byte_array()
	var params_bytes : PackedByteArray = PackedFloat32Array([0.0]).to_byte_array()
	
	dots_buffer = rd.storage_buffer_create(dots_bytes.size(), dots_bytes)
	flocks_buffer = rd.storage_buffer_create(flocks_bytes.size(), flocks_bytes)
	params_buffer = rd.storage_buffer_create(params_bytes.size(), params_bytes)
	
	var sampler_state := RDSamplerState.new()
	var sampler = rd.sampler_create(sampler_state)
	
	var noise_format = RDTextureFormat.new()
	noise_format.format = RenderingDevice.DATA_FORMAT_R8_SNORM;
	noise_format.width = 512
	noise_format.height = 512
	noise_format.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT | RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT | RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT
	
	var image = noise_texture.get_image()
	image.convert(Image.FORMAT_R8)
	noise_rid = rd.texture_create(noise_format, RDTextureView.new(), [image.get_data()])
	
	var dots_uniform = RDUniform.new()
	dots_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	dots_uniform.binding = 0
	dots_uniform.add_id(dots_buffer)

	var flocks_uniform = RDUniform.new()
	flocks_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	flocks_uniform.binding = 1
	flocks_uniform.add_id(flocks_buffer)
	
	var params_uniform = RDUniform.new()
	params_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER;
	params_uniform.binding = 2
	params_uniform.add_id(params_buffer)
	
	var noise_uniform = RDUniform.new()
	noise_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_SAMPLER_WITH_TEXTURE
	noise_uniform.binding = 3
	noise_uniform.add_id(sampler)
	noise_uniform.add_id(noise_rid)
	
	var uniforms = [dots_uniform, flocks_uniform, params_uniform, noise_uniform]
	uniform_set = rd.uniform_set_create(uniforms, shader, 0)
	pipeline = rd.compute_pipeline_create(shader)

func _process(delta):
	update_flock_buffers()
	update_flock_array()
	update_buffers(delta)
	
	if is_submitted:
		sync()
	compute()
	
	retrieve_output()
	update_mesh()

func update_buffers(delta):
	var dots_bytes = dots.to_byte_array()
	var flocks_bytes = flocks_array.to_byte_array()
	var params_bytes : PackedByteArray = PackedFloat32Array([delta]).to_byte_array()
	
	rd.buffer_update(dots_buffer, 0, dots_bytes.size(), dots_bytes)
	rd.buffer_update(flocks_buffer, 0, flocks_bytes.size(), flocks_bytes)
	rd.buffer_update(params_buffer, 0, params_bytes.size(), params_bytes)
	
func compute():
	var compute_list = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, max_instances / 1024, 1, 1)
	rd.compute_list_end()
	
	rd.submit()
	is_submitted = true
	
func sync():
	rd.sync()
	is_submitted = false
	 
func process_retrieve_flock(flock_index):
	var flock = flocks[flock_index]
	
	for dot_index in flock.dots.size():
		var dot = flock.dots[dot_index]
		var index = flock.base_index + dot_index
		
		dot.current_position.x = dots[index * 8 + 2]
		dot.current_position.y = dots[index * 8 + 3]
		
		dot.velocity.x = dots[index * 8 + 4]
		dot.velocity.y = dots[index * 8 + 5]
	
func retrieve_output():
	var dots_output_bytes = rd.buffer_get_data(dots_buffer)
	dots = dots_output_bytes.to_float32_array()
	
	var task_id = WorkerThreadPool.add_group_task(process_retrieve_flock, flocks.size(), 4)
	WorkerThreadPool.wait_for_group_task_completion(task_id)
	
func process_mesh_instance(flock_index):
	var flock = flocks[flock_index]
	
	var dots = flock.dots	
	for dot_index in dots.size():
		var dot = dots[dot_index]
		var instance_index = flock.base_index + dot_index
	
		RenderingServer.multimesh_instance_set_transform_2d(multimesh.get_rid(), instance_index, Transform2D(0, size, 0, dot.current_position))
		RenderingServer.multimesh_instance_set_color(multimesh.get_rid(), instance_index, dot.color)
		
func update_mesh():
	var task_id = WorkerThreadPool.add_group_task(process_mesh_instance, flocks.size(), 4)
	WorkerThreadPool.wait_for_group_task_completion(task_id)
	
	var dots_count = 0
	for flock in flocks:
		dots_count += flock.dots.size()
	
	multimesh.visible_instance_count = dots_count
			
func add_flock(flock : Flock):
	flocks.insert(0, flock)
	
func remove_flock(flock : Flock):
	flocks.erase(flock)
	
func process_flocks_buffer(flock_index):
	var flock = flocks[flock_index]
	
	for dot_index in flock.dots.size():
		var dot = flock.dots[dot_index]
		var index = flock.base_index + dot_index
		
		dots[index * 8] = dot.target_position.x
		dots[index * 8 + 1] = dot.target_position.y
		
		dots[index * 8 + 2] = dot.current_position.x
		dots[index * 8 + 3] = dot.current_position.y
		
		dots[index * 8 + 4] = dot.velocity.x
		dots[index * 8 + 5] = dot.velocity.y
		
		dots[index * 8 + 6] = flock_index
		dots[index * 8 + 7] = 0.0
	
func update_flock_buffers():
	var base_index = 0
	for flock in flocks:
		flock.base_index = base_index
		base_index += flock.dots.size()
	
	var task_id = WorkerThreadPool.add_group_task(process_flocks_buffer, flocks.size(), 4)
	WorkerThreadPool.wait_for_group_task_completion(task_id)
	
func update_flock_array():
	var index = 0
	for flock in flocks:
		flocks_array[index * 12] = flock.owner.global_position.x
		flocks_array[index * 12 + 1] = flock.owner.global_position.y
			
		flocks_array[index * 12 + 2] = flock.owner.global_scale.x
		flocks_array[index * 12 + 3] = flock.owner.global_scale.y
		
		flocks_array[index * 12 + 4] = flock.size.x
		flocks_array[index * 12 + 5] = flock.size.y
		
		flocks_array[index * 12 + 6] = flock.owner.offset.x
		flocks_array[index * 12 + 7] = flock.owner.offset.y
		
		flocks_array[index * 12 + 8] = 1.0 if flock.owner.flip_h else 0.0
		flocks_array[index * 12 + 9] = 1.0 if flock.owner.flip_v else 0.0
		
		flocks_array[index * 12 + 10] = 1.0 if flock.owner.centered else 0.0
		flocks_array[index * 12 + 11] = flock.owner.global_rotation
		
		index += 1
