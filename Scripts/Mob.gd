extends RigidBody2D

export (int) var min_speed # Minimum speed range.
export (int) var max_speed # Maximum speed range.
var mob_types = ["walk", "swim", "fly"]

func _ready():
	get_node("AnimatedSprite").animation = mob_types[randi() % mob_types.size()]
	get_node("AnimatedSprite").play()


func _on_Visibility_exit_screen():
	queue_free()
