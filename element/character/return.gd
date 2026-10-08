extends StatePlayer

func _play_if_not(anim: StringName) -> void:
	print(anim)
	if player.animation.animation != anim:
		player.animation.play(anim)
# Called when the node enters the scene tree for the first time.
func enter(_msg: Dictionary = {}) -> void:
	
	$"../../debugdata/VBox/Label3".text = name


# Called every frame. 'delta' is the elapsed time since the previous frame.
