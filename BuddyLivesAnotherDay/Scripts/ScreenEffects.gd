extends Container

export var cameraActive := false
export var useEnterExit := false
export var enterExitFade := 0.001
export var noiseScale := 0.2
export var saturation := 1.0
export var contrast := 1.0
export var vignetteRadius := 0.608
export var vignetteBlur := 0.293

onready var viewport := get_viewport()
onready var player := get_node("/root/Overworld/Player")

func UpdateFocus(visibleRect: Rect2) -> void:
	if player == null:
		$EnterExitEffect.get_material().set_shader_param("focusPoint", Vector3(0.5, 0.5, 1))
		return
	var viewportWidth = visibleRect.size.x
	var viewportHeight = visibleRect.size.y
	var viewportPos
	if cameraActive: viewportPos = Vector2(player.position.x - visibleRect.size.x/2, player.position.y - visibleRect.size.y/2)
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
	$EffectAnimator.set_speed_scale(-1)
	$EffectAnimator.play("Transition")

func _ready() -> void:
	$StaticEffect.get_material().set_shader_param("noiseScale", noiseScale)
	$NoireEffect.get_material().set_shader_param("contrast", contrast)
	$NoireEffect.get_material().set_shader_param("saturation", saturation)
	$VignetteEffect.get_material().set_shader_param("blurRadius", vignetteBlur)
	$VignetteEffect.get_material().set_shader_param("radius", vignetteRadius)
	if useEnterExit == true:
		$EnterExitEffect.get_material().set_shader_param("blurRadius", enterExitFade)
		PlayEnter()

func _process(delta: float) -> void:
	var visibleRect = get_viewport().get_visible_rect()
	var screenRatio = visibleRect.size.x / visibleRect.size.y
	$VignetteEffect.get_material().set_shader_param("screenRatio", screenRatio)
	if cameraActive:
		rect_position = Vector2(player.position.x - visibleRect.size.x/2, player.position.y - visibleRect.size.y/2)
	if useEnterExit: 
		UpdateFocus(visibleRect)
		$EnterExitEffect.get_material().set_shader_param("screenRatio", screenRatio)
