extends Container

export var camera_active := false
export var use_enter_exit := false
export var enter_exit_fade := 0.001
export var noise_scale := 0.2
export var saturation := 1.0
export var contrast := 1.0
export var vignette_radius := 0.608
export var vignette_blur := 0.293

onready var viewport := get_viewport()
onready var player := get_parent().get_node("PlayContainer/Player")
onready var camera := player.get_node("Camera2D")

func UpdateFocus(visibleRect: Rect2) -> void:
	if camera == null:
		$EnterExitEffect.get_material().set_shader_param("focusPoint", Vector3(0.5, 0.5, 1))
		return
	var viewportWidth = visibleRect.size.x
	var viewportHeight = visibleRect.size.y
	var viewportPos
	if camera_active: viewportPos = Vector2(camera.get_camera_screen_center().x - visibleRect.size.x/2, camera.get_camera_screen_center().y - visibleRect.size.y/2)
	else: viewportPos = visibleRect.position
	var focus = Vector3((player.position.x - viewportPos.x)/viewportWidth, (player.position.y - viewportPos.y)/viewportHeight, 1)
	$EnterExitEffect.get_material().set_shader_param("focusPoint", focus)

func PlayEnter() -> void:
	var visibleRect = get_viewport().get_visible_rect()
	UpdateFocus(visibleRect)
	$EnterExitEffect.visible = true
	$EffectAnimator.set_speed_scale(1)
	$EffectAnimator.play("Transition")
	yield(get_tree().create_timer(1.7), "timeout")
	$EnterExitEffect.visible = false

func PlayExit() -> void:
	var visibleRect = get_viewport().get_visible_rect()
	UpdateFocus(visibleRect)
	$EnterExitEffect.visible = true
	$EffectAnimator.play_backwards("Transition")

func _ready() -> void:
	$StaticEffect.get_material().set_shader_param("noiseScale", noise_scale)
	$NoireEffect.get_material().set_shader_param("contrast", contrast)
	$NoireEffect.get_material().set_shader_param("saturation", saturation)
	$VignetteEffect.get_material().set_shader_param("blurRadius", vignette_blur)
	$VignetteEffect.get_material().set_shader_param("radius", vignette_radius)
	if use_enter_exit == true:
		$EnterExitEffect.get_material().set_shader_param("blurRadius", enter_exit_fade)

func _process(delta: float) -> void:
	var visibleRect = get_viewport().get_visible_rect()
	var screenRatio = visibleRect.size.x / visibleRect.size.y
	$VignetteEffect.get_material().set_shader_param("screenRatio", screenRatio)
	if camera_active && camera != null:
		rect_position = Vector2(camera.get_camera_screen_center().x - visibleRect.size.x/2, camera.get_camera_screen_center().y - visibleRect.size.y/2)
	if use_enter_exit: 
		UpdateFocus(visibleRect)
		$EnterExitEffect.get_material().set_shader_param("screenRatio", screenRatio)
