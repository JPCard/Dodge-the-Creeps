signal hit

extends Area2D

const INITIAL_ROTATION = 0

export (int) var speed  # How fast the player will move (pixels/sec).
var screensize  # Size of the game window.
var canMove = false

func _ready():
	screensize = get_viewport_rect().size
	set_process(true)

func start(position:Vector2):
	rotation = INITIAL_ROTATION
	self.position = position
	show()
	$CollisionShape2D.disabled = false  # para que no detecte mas choques
	canMove = true

func _process(delta):
	if !canMove:
		return
	
	var velocity = Vector2() # The player's movement vector.
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		rotation = PI/2
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		rotation = -PI/2
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		rotation = 2*PI
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		rotation = 0
	
	if (velocity.length() > 0):
		velocity = velocity.normalized() * speed #tengo que normalizar para los casos en diagonal
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	#cambia posicion restringiendola al tamaño de la pantalla
	position += velocity * delta
	position = Vector2(clamp(position.x, 0, screensize.x), clamp(position.y, 0, screensize.y))
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0



func _on_Player_body_entered(body):
	$CollisionShape2D.disabled = true  # para que no detecte mas choques
	hide() # Player disappears after being hit.
	canMove = false
	position = Vector2(-1000, -1000)
	emit_signal("hit")
