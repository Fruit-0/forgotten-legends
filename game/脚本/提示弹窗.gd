extends Control
class_name ToastPopup

# Toast 弹窗：显示临时提示，1秒后自动消失，不影响其他功能

@onready var label: Label = $Panel/Label

# 显示时间（秒）
const DISPLAY_DURATION: float = 1.0

# 淡入淡出动画时间
const FADE_DURATION: float = 0.2

func _ready() -> void:
	# 初始状态：完全透明
	modulate.a = 0.0
	# 设置鼠标过滤为忽略，不接收点击事件
	mouse_filter = Control.MOUSE_FILTER_IGNORE


# 显示提示信息
# text: 要显示的文本
# 调用后会自动淡入，停留1秒后淡出消失
func show_message(text: String) -> void:
	label.text = text
	visible = true
	_play_show_animation()


# 播放显示动画：淡入 -> 停留 -> 淡出
func _play_show_animation() -> void:
	var tween: Tween = create_tween()
	# 淡入
	tween.tween_property(self, "modulate:a", 1.0, FADE_DURATION)
	# 停留 DISPLAY_DURATION 秒
	tween.tween_interval(DISPLAY_DURATION)
	# 淡出
	tween.tween_property(self, "modulate:a", 0.0, FADE_DURATION)
	# 动画结束后隐藏
	tween.tween_callback(_on_hide_complete)


# 动画结束回调：隐藏节点
func _on_hide_complete() -> void:
	visible = false
