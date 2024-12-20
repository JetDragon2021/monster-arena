extends Node2D

@onready var boundaries = $Boundaries
@onready var top_wall = $Boundaries/TopWall
@onready var bottom_wall = $Boundaries/BottomWall
@onready var left_wall = $Boundaries/LeftWall
@onready var right_wall = $Boundaries/RightWall

@onready var top_wall_rect = $Boundaries/TopWallRect
@onready var bottom_wall_rect = $Boundaries/BottomWallRect
@onready var left_wall_rect = $Boundaries/LeftWallRect
@onready var right_wall_rect = $Boundaries/RightWallRect

func _ready():
	# No additional setup needed
	pass
