extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var shield_duration = 2 # How many seconds the shield will last
@export var shield_cooldown_duration = 10 # How many seconds until we can use shield for next time
@export var shield_available = true # If the shield is avaible to be activated
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	$Shield.visible = false
	shield_available = true
	hide()
	
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed(&"move_right"):
		velocity.x += 1
	if Input.is_action_pressed(&"move_left"):
		velocity.x -= 1
	if Input.is_action_pressed(&"move_down"):
		velocity.y += 1
	if Input.is_action_pressed(&"move_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed(&"ui_select"):
		# Start the shield timer to make the shield visible
		if $ShieldTimer.is_stopped() && shield_available:
			$Shield.visible = true
			$ShieldTimer.start(shield_duration)
		

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = &"right"
		$AnimatedSprite2D.flip_v = false
		$Trail.rotation = 0
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = &"up"
		rotation = PI if velocity.y > 0 else 0


func start(pos):
	position = pos
	rotation = 0
	show()
	$CollisionShape2D.disabled = false


func _on_body_entered(_body):
	
	# When the shield is active avoid collision with enemies
	if !$ShieldTimer.is_stopped():
		return
	
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred(&"disabled", true)


func _on_shield_cooldown_timer_timeout() -> void:
	shield_available = true

func _on_shield_timer_timeout() -> void:
	# Hide the shield
	$Shield.visible = false
	
	# Make the shield unavailable for X seconds
	shield_available = false
	
	$ShieldCooldownTimer.start(shield_cooldown_duration)
