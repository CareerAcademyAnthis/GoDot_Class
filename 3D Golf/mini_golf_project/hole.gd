extends Node3D

enum {AIM, SET_POWER, SHOOT, WIN}

@export var power_speed = 100
@export var angle_speed = 1.1

var angle_change = 1
var power = 0
var power_change = 1
var shots = 0
var state = AIM

func _ready() -> void:
	$Arrow.hide()
	$Ball.position = $Tee.position
	change_state(AIM)
	$UI.show_message("Get Ready!")
	
func change_state(new_state):
	state = new_state
	match state:
		AIM:
			$Arrow.position = $Ball.position
			$Arrow.show()
		SET_POWER:
			power = 0
		SHOOT:
			$Arrow.hide()
			$Ball.shoot($Arrow.rotation.y, power / 15)
			shots += 1
			$UI.update_shots(shots)
		WIN:
			$Ball.hide()
			$Arrow.hide()
			$UI.show_message("Winner!")
			
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		match state:
			AIM:
				change_state(SET_POWER)
			SET_POWER:
				change_state(SHOOT)
				
func animate_arrow(delta):
	power += power_speed * power_change * delta
	if power >= 100:
		power_change = -1
	if power <= 0:
		power_change = 1
	$UI.update_power_bar(power)
	
func _on_ball_stopped():
	if state == SHOOT:
		change_state(AIM)
	
