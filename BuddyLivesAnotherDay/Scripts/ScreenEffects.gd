extends Control

export var useEnterExit := false
export var noiseScale := 0.2

var player
var viewport

func UpdateFocus():
	var viewportWidth = viewport.get_visible_rect().size.x
	var viewportHeight = viewport.get_visible_rect().size.y
	var viewportPos = viewport.get_visible_rect().position
	var point2d = Vector2((player.position.x - viewportPos.x)/viewportWidth, (player.position.y - viewportPos.y)/viewportHeight)
	var focus = Vector3(point2d.x, point2d.y, 1)
	$EnterExitEffect.get_material().set_shader_param("focusPoint", focus)

func PlayEnter():
	UpdateFocus()
	$EffectAnimator.set_speed_scale(1)
	$EffectAnimator.play("Transition")

func PlayExit():
	UpdateFocus()
	$EffectAnimator.set_speed_scale(-1)
	$EffectAnimator.play("Transition")

func _ready():
	$StaticEffect.get_material().set_shader_param("noiseScale", noiseScale)
	player = get_node("/root/Overworld/Player")
	viewport = get_viewport()
	if useEnterExit == true:
		PlayEnter()
		
func _process(delta: float) -> void:
	var visibleRect = get_viewport().get_visible_rect()
	if useEnterExit: UpdateFocus()
	if useEnterExit: $EnterExitEffect.get_material().set_shader_param("screenRatio", visibleRect.size.x / visibleRect.size.y)