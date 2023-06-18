class_name SegmentTileMap
extends Node2D

@export var biome1_tilemap: TileMap
@export var biome2_tilemap: TileMap
@export var biome3_tilemap: TileMap
@export var biome4_tilemap: TileMap
@export var biome5_tilemap: TileMap


func _ready() -> void:
	assert(biome1_tilemap and biome2_tilemap and biome3_tilemap and biome4_tilemap and biome5_tilemap)
