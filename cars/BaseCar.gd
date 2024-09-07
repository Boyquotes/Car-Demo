extends VehicleBody3D
class_name BaseCar

@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value = 20

var fwd_mps : float
var speed: float
var accelerateStatus: bool
var accelerate2Status: bool
var accelerate3Status: bool
var decelerateStatus: bool
var reverseStatus: bool
var recul: bool
var turn: bool
var goo: bool

func _ready():
	%CarResetter.init()
	$StartEngine.play()
	accelerateStatus = false
	accelerate2Status = false
	accelerate3Status = false
	reverseStatus = false
	recul = false
	turn = false
	goo = false
	
func _physics_process(delta):
	speed = linear_velocity.length()*Engine.get_frames_per_second()*delta
	#print(linear_velocity.length())
	#print("recul ", recul)
	#print("goo ", goo)
	fwd_mps = transform.basis.x.x
	traction(speed)
	process_accel(delta)
	process_steer(delta)
	process_brake(delta)
	%Hud/speed.text=str(round(speed))+"  KMPH"
	if speed < 1 and Input.is_action_pressed("ui_down"):
		reverse()
	if speed > 1 and Input.is_action_pressed("ui_up"):
		goo = !goo
		$ReverseGear.stop()
		#$Honk.play()
		#print("ib ibverse", goo)
		#if goo == true and recul == false:
			#recul=true
			#$Honk.play()
		#else:
			#$Honk.stop()
			#recul=false

func reverse():
	reverseStatus = true
	decelerateStatus = false
	$Brake.stop()
	$ReverseGear.play()

func turnDrift():
	turn = true
	$Brake.stop()
	$Turn.play()

func accelerate():
	accelerateStatus = true
	decelerateStatus = false
	reverseStatus = false
	$Brake.stop()
	$Accelerating.play()

func accelerate2():
	accelerate2Status = true
	decelerateStatus = false
	reverseStatus = false
	$Brake.stop()
	$Accelerating.play()
	
func accelerate3():
	accelerate3Status = true
	decelerateStatus = false
	reverseStatus = false
	$Brake.stop()
	$Accelerating.play()

func decelerate():
	accelerateStatus = false
	accelerate2Status = false
	accelerate3Status = false
	decelerateStatus = true
	$Accelerating.stop()
	$Brake.play()

func process_accel(delta):	
	if Input.is_action_pressed("ui_up"):
		$Ralenti.stop()
		if(accelerateStatus == false and round(speed) < 10.9):
			#print("speed ",speed)
			accelerate()
		if( ( round(speed) > 11 and round(speed) < 11.1 ) or ( round(speed) > 18 and round(speed) < 18.1) ):
			$Accelerating.stop()
			accelerateStatus == false
			accelerate2Status == false
			accelerate3Status == false
		if(accelerate2Status == false and ( round(speed) > 11.1 and round(speed) < 18.1) ):
			#print("accelerateStatus : ", "speed : "+str(speed), " "+str(round(speed*3.8)), " "+str(accelerateStatus) )
			accelerate2()
		if(accelerate3Status == false and round(speed) > 18.2 ):
			#print("accelerateStatus : ", "speed : "+str(speed), " "+str(round(speed*3.8)), " "+str(accelerateStatus) )
			accelerate3()
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			if speed < 30 and speed != 0:
				engine_force = clamp(engine_force_value * 10 / speed, 0, 300)
			else:
				engine_force = engine_force_value
		return
		
	if Input.is_action_just_released("ui_up"):
		if(accelerateStatus == true):
			$Accelerating.stop()
			accelerateStatus = false
			accelerate2Status = false
			accelerate3Status = false


	if Input.is_action_pressed("ui_down"):
	# Increase engine force at low speeds to make the initial acceleration faster.
		#print(speed)
		#print(fwd_mps)
		#print(engine_force_value)
		if speed > 6 and not reverseStatus:
			if(decelerateStatus == false):
				decelerate()
		if speed < 20 and speed != 0:
			engine_force = -clamp(engine_force_value * 3 / speed, 0, 300)
		else:
			engine_force = -engine_force_value
		return

	if Input.is_action_just_released("ui_down"):
		if(decelerateStatus == true):
			$Brake.stop()
			decelerateStatus = false
			
	engine_force = 0
	brake = 0	

func process_steer(delta):
	steer_target = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	steer_target *= STEER_LIMIT
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)

	if Input.get_action_strength("ui_left"):
		if ( speed > 15 and turn == false): 
			turnDrift()
		if ( speed < 15 and turn == true): 
			$Turn.stop()
	if Input.is_action_just_released("ui_left"):
		$Turn.stop()
		turn = false

	if Input.get_action_strength("ui_right"):
		if ( speed > 15 and turn == false): 
			turnDrift()
		if ( speed < 15 and turn == true): 
			$Turn.stop()
	if Input.is_action_just_released("ui_right"):
		$Turn.stop()
		turn = false

func process_brake(delta):
	if ( Input.is_action_pressed("ui_select") and not Input.is_action_pressed("ui_up") ):
	#if ( Input.is_action_just_pressed("ui_select") ):
		$Accelerating.stop()
		brake=1.5
		$wheel_rear_left.wheel_friction_slip=2
		$wheel_rear_right.wheel_friction_slip=2
		if(decelerateStatus == false and speed > 6):
			decelerate()
		elif( speed < 4 ):
			$Brake.stop()
	else:
		$wheel_rear_left.wheel_friction_slip=2.9
		$wheel_rear_right.wheel_friction_slip=2.9
	if Input.is_action_just_released("ui_select"):
		if(decelerateStatus == true):
			if ( speed > 15 ):
				$Turn.stop()
				decelerateStatus = true
			$Brake.stop()
			decelerateStatus = false


func traction(speed):
	apply_central_force(Vector3.DOWN*speed)


func _on_start_engine_finished():
	$Ralenti.play()


func _on_camera_3d_reculage(value):
	#print("recul signal ",value)
	#goo = false
	#if speed > 1 and not recul:
	recul = true
	goo = false
	#else:
		#recul = false

func _on_camera_3d_gooo(value):
	#print("goo signal ",value)
	#print("speed signal ",speed)
	goo = true
	recul = false
	#if round(speed*3.8) > 1 and not recul:
		#goo = value
