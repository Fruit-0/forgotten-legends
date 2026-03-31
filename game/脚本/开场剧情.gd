extends Control
class_name OpeningCinematic

# 开场剧情场景：用于展示游戏故事背景
# 当前状态：静态图片占位，后续将替换为过场动画

@onready var 跳过按钮: Button = $"跳过按钮"

func _ready() -> void:
	print("开场剧情场景加载")
	跳过按钮.pressed.connect(_on_跳过按钮_pressed)

func _on_跳过按钮_pressed() -> void:
	print("跳过剧情，进入游戏")
	# TODO: 跳转到游戏主场景（第一个关卡/村庄场景）
	# get_tree().change_scene_to_file("res://场景/游戏主场景.tscn")

	# 暂时返回主菜单，等待实际游戏场景开发
	get_tree().change_scene_to_file("res://场景/主菜单.tscn")

func _input(event: InputEvent) -> void:
	# 支持ESC键跳过
	if event.is_action_pressed("ui_cancel"):
		_on_跳过按钮_pressed()
