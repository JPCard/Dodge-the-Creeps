extends Node

export (PackedScene) var Mob
var score:int = 0

func _ready():
	randomize() #para hacer que los nros random sean distintos en cada vez que se ejecuta el juego
	score = 0

func game_over():
	get_node("ScoreTimer").stop()
	get_node("MobTimer").stop()
	get_node("HUD").show_game_over()
	get_node("Music").stop()
	get_node("DeathSFX").play()

func new_game():
	get_tree().call_group("Mobs","queue_free")
	score = 0
	get_node("Player").start(get_node("PlayerSpawnPosition").position)
	get_node("StartTimer").start()
	get_node("HUD").update_score(score)
	get_node("HUD").show_message("Get Ready")
	get_node("Music").play(2)

func _on_StartTimer_timeout():
	get_node("MobTimer").start()
	get_node("ScoreTimer").start()

func _on_ScoreTimer_timeout():
	score += 1
	get_node("HUD").update_score(score)

func _on_MobTimer_timeout():
	# Choose a random location on Path2D.

	var randOffset = randi() % 4
	if randOffset == 0:
		randOffset = 400 + randi() % 421
	elif randOffset == 1:
		randOffset = 1220 + randi() % 201
	elif randOffset == 2:
		randOffset = 2020 + randi() % 421
	elif randOffset == 3:
		randOffset = 2840 + randi() % 201
	
	$MobPath/MobSpawnLocation.set_offset(randOffset)
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.

	direction += rand_range(-PI* 0.60, -PI * 0.40)
	direction += PI
	mob.rotation = direction
	# Choose the velocity.
	mob.set_linear_velocity(Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(direction))


func _on_HUD_start_game():
	new_game()


func _on_Player_hit():
	game_over()
