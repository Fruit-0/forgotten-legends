extends Control
class_name MainMenu

@onready var 继续游戏按钮: Button = $"垂直容器/继续游戏按钮"
@onready var 提示弹窗 = $"提示弹窗"

func _ready() -> void:
	# 继续游戏按钮默认隐藏，后续根据存档存在性显示
	继续游戏按钮.visible = false

func _on_开始游戏按钮_pressed() -> void:
	print("开始游戏，进入开场剧情")
	get_tree().change_scene_to_file("res://场景/开场剧情.tscn")

func _on_继续游戏按钮_pressed() -> void:
	提示弹窗.show_message("继续游戏按钮被点击了")

func _on_读取存档按钮_pressed() -> void:
	提示弹窗.show_message("读取存档按钮被点击了")

func _on_设置按钮_pressed() -> void:
	print("跳转到设置菜单")
	get_tree().change_scene_to_file("res://场景/设置菜单.tscn")

func _on_退出游戏按钮_pressed() -> void:
	提示弹窗.show_message("退出游戏按钮被点击了")
	get_tree().quit()
