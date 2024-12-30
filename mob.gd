extends RigidBody2D

func _ready():
	$AnimatedSprite2D.play()
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	
	# Pick a random scale mob
	var random_mob_scale = randf_range(0.5, 1) 
	$AnimatedSprite2D.scale.x = random_mob_scale
	$AnimatedSprite2D.scale.y = random_mob_scale


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
