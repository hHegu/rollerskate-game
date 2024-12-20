extends Line2D
@export var trailLength = 5

func _ready():
	top_level = true
	clear_points()


func _physics_process(_delta):
	var point = get_parent().global_position
	add_point(point)

	if points.size() > trailLength:
		remove_point(0)

func set_color(color):
	var gradient_color_amount = gradient.colors.size()
	for i in gradient_color_amount:
		var new_color = color
		new_color.a = (i + 1.0) / gradient_color_amount
		gradient.colors[i] = new_color
