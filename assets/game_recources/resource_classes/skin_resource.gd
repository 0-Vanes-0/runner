class_name SkinResource
extends Resource

const COLORS := {
	Rarity.NORMAL: Color.WHITE,
	Rarity.RARE: Color.DARK_VIOLET,
	Rarity.EPIC: Color.YELLOW,
	Rarity.LEGENDARY: Color.RED,
}
@export var sprite_frames: SpriteFrames


func apply_to_sprite(sprite: AnimatedSprite2D) -> AnimatedSprite2D:
	sprite.sprite_frames = self.sprite_frames
	var texture_size: Vector2 = sprite.sprite_frames.get_frame_texture("default", 0).get_size()
	sprite.offset.y = - texture_size.y / 2
	return sprite
