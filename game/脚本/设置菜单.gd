extends Control
class_name SettingsMenu

# 设置菜单：游戏设置界面
# 功能：音频、鼠标灵敏度、伤害数字显示、屏幕震动

# ========== 信号 ==========
signal settings_applied
signal settings_canceled

# ========== 节点引用 ==========
@onready var 伤害数字开关: CheckButton = $"面板/内容区/滚动容器/设置列表/画面设置/伤害数字行/开关"

@onready var 主音量滑块: HSlider = $"面板/内容区/滚动容器/设置列表/音频设置/主音量行/滑块"
@onready var 音乐音量滑块: HSlider = $"面板/内容区/滚动容器/设置列表/音频设置/音乐音量行/滑块"
@onready var 音效音量滑块: HSlider = $"面板/内容区/滚动容器/设置列表/音频设置/音效音量行/滑块"
@onready var 主音量标签: Label = $"面板/内容区/滚动容器/设置列表/音频设置/主音量行/数值标签"
@onready var 音乐音量标签: Label = $"面板/内容区/滚动容器/设置列表/音频设置/音乐音量行/数值标签"
@onready var 音效音量标签: Label = $"面板/内容区/滚动容器/设置列表/音频设置/音效音量行/数值标签"

@onready var 鼠标灵敏度滑块: HSlider = $"面板/内容区/滚动容器/设置列表/操作设置/鼠标灵敏度行/滑块"
@onready var 鼠标灵敏度标签: Label = $"面板/内容区/滚动容器/设置列表/操作设置/鼠标灵敏度行/数值标签"
@onready var 屏幕震动开关: CheckButton = $"面板/内容区/滚动容器/设置列表/操作设置/屏幕震动行/开关"

@onready var 返回按钮: Button = $"面板/底部按钮区/返回按钮"
@onready var 应用按钮: Button = $"面板/底部按钮区/应用按钮"
@onready var 恢复默认按钮: Button = $"面板/底部按钮区/恢复默认按钮"

# ========== 运行时数据 ==========
var 当前设置: Dictionary = {}
var 原始设置: Dictionary = {}
var 设置已修改: bool = false

# ========== 生命周期 ==========
func _ready() -> void:
	print("设置菜单初始化")
	_加载当前设置()
	_连接信号()
	_更新UI显示()

func _连接信号() -> void:
	# 画面设置
	伤害数字开关.toggled.connect(_on_伤害数字_changed)

	# 音频设置
	主音量滑块.value_changed.connect(_on_主音量_changed)
	音乐音量滑块.value_changed.connect(_on_音乐音量_changed)
	音效音量滑块.value_changed.connect(_on_音效音量_changed)

	# 操作设置
	鼠标灵敏度滑块.value_changed.connect(_on_鼠标灵敏度_changed)
	屏幕震动开关.toggled.connect(_on_屏幕震动_changed)

	# 按钮
	返回按钮.pressed.connect(_on_返回按钮_pressed)
	应用按钮.pressed.connect(_on_应用按钮_pressed)
	恢复默认按钮.pressed.connect(_on_恢复默认按钮_pressed)

# ========== 设置数据管理 ==========
func _加载当前设置() -> void:
	"""从配置文件加载设置，如果不存在则使用默认值"""
	当前设置 = 加载设置()
	原始设置 = 当前设置.duplicate()

func _获取默认设置() -> Dictionary:
	"""返回默认设置值"""
	return {
		"伤害数字": true,
		"主音量": 80.0,
		"音乐音量": 70.0,
		"音效音量": 80.0,
		"鼠标灵敏度": 1.0,
		"屏幕震动": true
	}

func _更新UI显示() -> void:
	"""根据当前设置更新UI控件状态"""
	# 画面
	伤害数字开关.button_pressed = 当前设置["伤害数字"]

	# 音频
	主音量滑块.value = 当前设置["主音量"]
	音乐音量滑块.value = 当前设置["音乐音量"]
	音效音量滑块.value = 当前设置["音效音量"]
	_更新音量标签()

	# 操作
	鼠标灵敏度滑块.value = 当前设置["鼠标灵敏度"]
	屏幕震动开关.button_pressed = 当前设置["屏幕震动"]
	_更新灵敏度标签()

func _更新音量标签() -> void:
	"""更新音量数值显示"""
	主音量标签.text = "%d%%" % int(主音量滑块.value)
	音乐音量标签.text = "%d%%" % int(音乐音量滑块.value)
	音效音量标签.text = "%d%%" % int(音效音量滑块.value)

func _更新灵敏度标签() -> void:
	"""更新灵敏度数值显示"""
	鼠标灵敏度标签.text = "%.1f" % 鼠标灵敏度滑块.value

func _标记设置已修改() -> void:
	"""标记设置已被修改，启用应用按钮"""
	设置已修改 = true
	应用按钮.disabled = false

# ========== 信号回调 ==========
func _on_伤害数字_changed(toggled: bool) -> void:
	当前设置["伤害数字"] = toggled
	_标记设置已修改()
	print("显示伤害数字: ", toggled)

func _on_主音量_changed(value: float) -> void:
	当前设置["主音量"] = value
	主音量标签.text = "%d%%" % int(value)
	_标记设置已修改()

func _on_音乐音量_changed(value: float) -> void:
	当前设置["音乐音量"] = value
	音乐音量标签.text = "%d%%" % int(value)
	_标记设置已修改()

func _on_音效音量_changed(value: float) -> void:
	当前设置["音效音量"] = value
	音效音量标签.text = "%d%%" % int(value)
	_标记设置已修改()

func _on_鼠标灵敏度_changed(value: float) -> void:
	当前设置["鼠标灵敏度"] = value
	鼠标灵敏度标签.text = "%.1f" % value
	_标记设置已修改()

func _on_屏幕震动_changed(toggled: bool) -> void:
	当前设置["屏幕震动"] = toggled
	_标记设置已修改()
	print("屏幕震动: ", toggled)

# ========== 按钮回调 ==========
func _on_返回按钮_pressed() -> void:
	print("返回按钮点击，取消设置")
	if 设置已修改:
		# TODO: 显示确认对话框"设置未保存，是否放弃？"
		pass
	settings_canceled.emit()
	# 返回主菜单
	get_tree().change_scene_to_file("res://场景/主菜单.tscn")

func _on_应用按钮_pressed() -> void:
	print("应用设置")
	_保存设置到文件()
	原始设置 = 当前设置.duplicate()
	设置已修改 = false
	应用按钮.disabled = true
	settings_applied.emit()

func _on_恢复默认按钮_pressed() -> void:
	print("恢复默认设置")
	当前设置 = _获取默认设置()
	_更新UI显示()
	_标记设置已修改()

func _保存设置到文件() -> void:
	"""将设置保存到用户配置文件"""
	var config := ConfigFile.new()

	for key in 当前设置.keys():
		config.set_value("settings", key, 当前设置[key])

	var 文件路径: String = "user://settings.cfg"
	var 完整路径: String = ProjectSettings.globalize_path(文件路径)
	print("[设置] 正在保存到: ", 完整路径)

	var err := config.save(文件路径)
	if err != OK:
		push_error("[设置] 保存失败，错误码: " + str(err))
	else:
		print("[设置] 保存成功！实际路径: ", OS.get_user_data_dir(), "/settings.cfg")

# ========== 公共接口 ==========
static func 加载设置() -> Dictionary:
	"""静态方法：从配置文件加载设置，如果不存在则返回默认值"""
	var config := ConfigFile.new()
	var 文件路径: String = "user://settings.cfg"
	var err := config.load(文件路径)

	if err != OK:
		print("[设置] 未找到配置文件，使用默认设置。路径: ", OS.get_user_data_dir(), "/settings.cfg")
		return {
			"伤害数字": true,
			"主音量": 80.0,
			"音乐音量": 70.0,
			"音效音量": 80.0,
			"鼠标灵敏度": 1.0,
			"屏幕震动": true
		}

	print("[设置] 成功加载配置文件: ", OS.get_user_data_dir(), "/settings.cfg")
	var 设置: Dictionary = {}
	设置["伤害数字"] = config.get_value("settings", "伤害数字", true)
	设置["主音量"] = config.get_value("settings", "主音量", 80.0)
	设置["音乐音量"] = config.get_value("settings", "音乐音量", 70.0)
	设置["音效音量"] = config.get_value("settings", "音效音量", 80.0)
	设置["鼠标灵敏度"] = config.get_value("settings", "鼠标灵敏度", 1.0)
	设置["屏幕震动"] = config.get_value("settings", "屏幕震动", true)

	return 设置

# ========== 游戏启动时调用 ==========
static func 应用启动设置() -> void:
	"""游戏启动时应用窗口设置"""
	# 固定分辨率 1920x1080，禁止调整窗口
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(Vector2i(1920, 1080))
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, true)
	print("[启动] 应用固定分辨率: 1920x1080，窗口调整已禁用")
