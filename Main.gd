extends Node

@export var mob_scene: PackedScene
var score
var high_score = 0
const HIGH_SCORE_FILE = "user://high_score.save"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_high_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# function to update high score
func update_high_score():
	if score > high_score:
		high_score = score
		$HUD.update_high_score(high_score)
		save_high_score()
		
func save_high_score():
	var file = FileAccess.open(HIGH_SCORE_FILE, FileAccess.WRITE)
	if file != null:
		file.store_32(high_score)
		file.close()

func load_high_score():
	if FileAccess.file_exists(HIGH_SCORE_FILE):
		var file = FileAccess.open(HIGH_SCORE_FILE, FileAccess.READ)
		if file != null:
			high_score = file.get_32()
			file.close()
		
	# Update HUD with the loaded high score
	$HUD.update_high_score(high_score)
	  


func game_over():
	update_high_score()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
	


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
