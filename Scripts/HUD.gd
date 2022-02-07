extends CanvasLayer

signal start_game

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func show_message(text):
	get_node("MessageLabel").text = text
	get_node("MessageLabel").show()
	get_node("MessageTimer").start()

func show_game_over():
	show_message("Game Over")
	yield(get_node("MessageTimer"), "timeout")
	get_node("StartButton").show()
	get_node("MessageLabel").text = "Dodge the\nCreeps!"
	get_node("MessageLabel").show()

func update_score(score):
	get_node("ScoreLabel").text = str(score)

func _on_MessageTimer_timeout():
	get_node("MessageLabel").hide()


func _on_StartButton_pressed():
	get_node("StartButton").hide()
	emit_signal("start_game")

