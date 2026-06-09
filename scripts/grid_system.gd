class_name GridSystem
extends Node3D


@export var selection_menu: SelectionMenu
@export var placing_area: CollisionShape3D
@export var helper_ghost: Node3D
@export var camera: Camera3D

var intersect_pos: Vector3 = Vector3.ZERO
var grid_pos: Vector3 = Vector3.ZERO

var can_place: bool = true
var on_menu: bool = false

## structure: grid_pos(Vector2) = [ instance, key_string: String ]
var grid_data: Dictionary


func _ready() -> void:
	init_grid_data()


func _process(_delta: float) -> void:
	shoot_ray()
	grid_position_process()

	helper_ghost.position = grid_pos

	if Input.is_action_just_pressed("place") and can_place and !on_menu and check_empty():
		place()
	elif Input.is_action_just_pressed("delete"):
		delete()


func shoot_ray() -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_length: int = 20
	var from: Vector3 = camera.project_ray_origin(mouse_pos)
	var to: Vector3 = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var ray_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray_query.collision_mask = 2
	ray_query.from = from
	ray_query.to = to
	var ray_result: Dictionary = space.intersect_ray(ray_query)

	if !ray_result.is_empty():
		can_place = true
		helper_ghost_replace()
		intersect_pos = ray_result["position"]
		intersect_pos = Vector3i(intersect_pos)
	else:
		can_place = false
		helper_ghost_delete()


func grid_position_process() -> void:
	var data: Array = get_current_key_data()
	grid_pos = intersect_pos + Vector3(0.5 * data[1], 0, -0.5 * data[2])


func place():
	var data: Array = get_current_key_data()
	var instance = data[0].instantiate()
	instance.position = grid_pos

	for x in range(0, data[1], 1):
		for y in range(0, data[2], 1):
			grid_data[Vector2(intersect_pos.x +x, intersect_pos.z -y)]=[instance, selection_menu.current_key]

	get_parent().add_child(instance)


func delete():
	var exist: bool = grid_data.has(Vector2(intersect_pos.x, intersect_pos.z))

	if !exist:
		return

	var data: Array = grid_data[Vector2(intersect_pos.x, intersect_pos.z)]
	if data[0] != null:
		data[0].queue_free()


func helper_ghost_delete() -> void:
	for child in helper_ghost.get_children():
		child.queue_free()


func helper_ghost_replace() -> void:
	helper_ghost_delete()
	var data: Array = get_current_key_data()
	var instance = data[0].instantiate()
	helper_ghost.add_child(instance)



func get_current_key_data() -> Array:
	return MeshArray.current[selection_menu.current_key]


func init_grid_data() -> void:
	for y in range(1, placing_area.shape.size.x + 1, 1):
		y = -y
		for x in range(0, placing_area.shape.size.z, 1):

			grid_data[Vector2(x, y)] = [ null, null ]

	print(grid_data)


func check_empty() -> bool:
	var data: Array = MeshArray.current[selection_menu.current_key]
	for x in range(0, data[1], 1):
		for y in range(0, data[2], 1):
			if grid_data[Vector2(intersect_pos.x +x, intersect_pos.z -y)][0] != null:
				return false
	return true


func _on_selection_menu_focus_entered() -> void:
	on_menu = false


func _on_selection_menu_focus_exited() -> void:
	on_menu = true


func _on_selection_menu_current_key_changed() -> void:
	helper_ghost_replace()
