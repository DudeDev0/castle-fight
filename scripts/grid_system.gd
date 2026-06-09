class_name GridSystem
extends Node3D


@export var selection_menu: SelectionMenu
@export var camera: Camera3D

var intersect_pos: Vector3 = Vector3.ZERO

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("place"):
		shoot_ray()
		print(intersect_pos)
		place(intersect_pos)


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
		intersect_pos = ray_result["position"]
		intersect_pos = Vector3i(intersect_pos)

# func grid_pos() -> void:
# 	intersect_pos = round(intersect_pos)

func place(spawn_pos: Vector3):
	var data: Array = MeshArray.current[selection_menu.current_key]
	var instance = data[0].instantiate()
	instance.position = spawn_pos + Vector3(0.5 * data[1], 0, -0.5 * data[2])
	get_parent().add_child(instance)
