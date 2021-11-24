extends Camera
 
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
 
var windowsize;
var viewport;
var moveCameraOnX=0;
var moveCameraOnY=0;
 
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED); #hide cursor
	viewport=get_viewport();
	windowsize=viewport.get_visible_rect().size;
	pass
 
func _input(event):
	if event is InputEventMouseMotion:
		_moveCameraWithMouse(event);
	pass
 
#
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
 
func _moveCameraWithMouse(event):
 
	var mousePositionChangeSinceLastFrame = event.relative;
	var sensitivity = 0.01;
	moveCameraOnX = mousePositionChangeSinceLastFrame.x * sensitivity;
	moveCameraOnY = mousePositionChangeSinceLastFrame.y * sensitivity;
 
	var potentialCameraXAngleOnNextFrame = rad2deg(rotation.x+moveCameraOnY);
	if (_isBetween(potentialCameraXAngleOnNextFrame, -90, 90)):
		rotation += Vector3(-moveCameraOnY, -moveCameraOnX,0); #rotate camera. moveCameraOnY actually rotates on X axis
															 #"OnY" stands for "uses mouse Y position". Same for moveCameraOnX
															 #so thats why moveCameraOnY is on the "X" position in the Vector3
 
	#print(rad2deg(rotation.x),' ', rad2deg(rotation.y),' ', rad2deg(rotation.z));
 
 
	#triggerMouseMotionEventsEnabled=false;
	#viewport.warp_mouse(Vector2(windowsize.x/2, windowsize.y/2));
	#triggerMouseMotionEventsEnabled=true;
	#TODO: explain the moveCameraOnX/Y swap better (moveCameraOnX actually rotates on Y axis so thats confusing)
	pass
 
func _isBetween(x, bound1,bound2):
	if (bound1 > bound2): 
		_swap(bound1, bound2); #bound1 always smaller than bound2
 
	#print(x, '>=', bound1, x>=bound1);
	#print(x, '<=', bound2, x<=bound2);
 
	if(x >= bound1 and x<=bound2):
		return true;
	else: return false;
	pass
 
func _swap(a, b):
	var temp = a;
	a = b;
	b = temp;
	pass
