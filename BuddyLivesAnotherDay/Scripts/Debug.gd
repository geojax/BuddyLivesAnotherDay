tool
extends Node2D

var lines = []

func EraseLines():
	lines = []

func DrawLine(start: Vector2, stop: Vector2, color: Color):
	lines.push_back([start, stop, color])

func _draw():
	for line in lines:
		draw_line(line[0], line[1], line[2])
