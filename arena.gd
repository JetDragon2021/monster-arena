extends Node2D

@onready var arena_walls = $ArenaWalls
@onready var top_wall = $ArenaWalls/TopArenaWall
@onready var bottom_wall = $ArenaWalls/BottomArenaWall
@onready var left_wall = $ArenaWalls/LeftArenaWall
@onready var right_wall = $ArenaWalls/RightArenaWall

@onready var top_wall_rect = $ArenaWalls/TopWallRect
@onready var bottom_wall_rect = $ArenaWalls/BottomWallRect
@onready var left_wall_rect = $ArenaWalls/LeftWallRect
@onready var right_wall_rect = $ArenaWalls/RightWallRect

func _ready():
	# No additional setup needed
	pass
