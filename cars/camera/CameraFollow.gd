extends Camera3D


@export var target_distance = 5
@export var target_height = 2
@export var speed:=20.0
var follow_this = null
var last_lookat
signal reculage(value)
signal gooo(value)

func _ready():
	follow_this = get_parent()
	last_lookat = follow_this.global_transform.origin

func _physics_process(delta):
	var delta_v = global_transform.origin - follow_this.global_transform.origin
	var target_pos = global_transform.origin
	#print("delta_v ", delta_v)
	#print("delta_v.x ", delta_v.x)
	# ignore y
	delta_v.y = 0.0
	
	if(delta_v.x > 0):
		#print("reeeeecc", speed)
		emit_signal("reculage", true)
	else:
		#print("goooo", speed)
		emit_signal("gooo", true)
	
	if (delta_v.length() > target_distance):
		delta_v = delta_v.normalized() * target_distance
		delta_v.y = target_height
		target_pos = follow_this.global_transform.origin + delta_v
	else:
		#print("wen")
		target_pos.y = follow_this.global_transform.origin.y + target_height
	#print( Vector3.UP)
	global_transform.origin = global_transform.origin.lerp(target_pos, delta * speed)
	
	last_lookat = last_lookat.lerp(follow_this.global_transform.origin, delta * speed)
	#print("last_lookat ",last_lookat)
	look_at(last_lookat, Vector3.UP)
