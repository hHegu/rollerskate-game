@tool
extends TextureRect
class_name Medal

enum Rank {
	BRONZE,
	SILVER,
	GOLD
}

var rank_colors = [
	Color.BROWN,
	Color.SILVER,
	Color.GOLD
]

@export var medal_rank: Rank = Rank.GOLD : 
	set(new_val):
		medal_rank = new_val
		self.modulate = rank_colors[medal_rank]


func _ready() -> void:
	update_color()


func update_color():
	self.modulate = rank_colors[medal_rank]