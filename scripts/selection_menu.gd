class_name SelectionMenu
extends BoxContainer


@export var template: PackedScene
@export var vbox1: VBoxContainer
@export var vbox2: VBoxContainer

@onready var current_key = get_parent().get_node("Label").text

signal current_key_changed

func _ready() -> void:
	vbox1.get_child(0).queue_free()
	var i = 0
	for key in MeshArray.current:
		var item: Button = template.instantiate()
		if i % 2 == 0:
			vbox1.add_child(item)
		else:
			vbox2.add_child(item)

		item.pressed.connect(_on_item_pressed.bind(item))

		item.get_node("Label").text = key
		i += 1

func _on_item_pressed(item: Button):
	current_key = item.get_node("Label").text

	current_key_changed.emit()

	get_parent().get_node("Label").text = current_key
