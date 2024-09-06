extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	# Wait unitl the message countout
	show_message("Game Over")
	
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the creeps!"
	$Message.show()
	
	#One shot timer and wait for it to finish
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
func update_high_score(high_score):
	$HighScore.text = str(high_score)
	
	

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()
