extends Control
class_name MainMenu

@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var toast_popup = $ToastPopup

func _ready() -> void:
	# 继续游戏按钮默认隐藏，后续根据存档存在性显示
	continue_button.visible = false

func _on_start_button_pressed() -> void:
	toast_popup.show_message("开始游戏按钮被点击了")

func _on_continue_button_pressed() -> void:
	toast_popup.show_message("继续游戏按钮被点击了")

func _on_load_button_pressed() -> void:
	toast_popup.show_message("读取存档按钮被点击了")

func _on_settings_button_pressed() -> void:
	toast_popup.show_message("设置按钮被点击了")

func _on_quit_button_pressed() -> void:
	toast_popup.show_message("退出游戏按钮被点击了")
	get_tree().quit()
