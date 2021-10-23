extends Control

export var useEnterExit := false
export var noiseScale := 0.2

func _ready():
	$StaticEffect.get_material().set_shader_param("noiseScale", noiseScale)
	if useEnterExit == true:
		var player = get_node("/root/Overworld/Player")
		var viewport = get_viewport()
		var viewportWidth = viewport.get_visible_rect().size.x
		var viewportHeight = viewport.get_visible_rect().size.y
		var viewportPos = viewport.get_visible_rect().position
		var point2d = Vector2((player.position.x - viewportPos.x)/viewportWidth, (player.position.y - viewportPos.y)/viewportHeight)
		var focus = Vector3(point2d.x, point2d.y, 1)
		$EnterExitEffect.get_material().set_shader_param("focusPoint", focus)
		$EffectAnimator.play("Enter")

func _process(delta: float) -> void:
	var visibleRect = get_viewport().get_visible_rect()
	#rect_position = visibleRect.position
	#rect_size = visibleRect.size
	if useEnterExit: $EnterExitEffect.get_material().set_shader_param("screenRatio", visibleRect.size.x / visibleRect.size.y)
