# GDScript API 速查表 (Godot 4.6)

> 本文档包含常用 GDScript API 的快速参考，用于生成准确的代码。

---

## 常用节点类

### Node2D - 2D 节点基类
```gdscript
extends Node2D

# 位置、旋转、缩放
position: Vector2          # 相对于父节点的位置
global_position: Vector2   # 全局位置
rotation: float            # 弧度
rotation_degrees: float    # 角度
scale: Vector2

# 常用方法
look_at(target: Vector2) -> void
move_local_x(delta: float) -> void
move_local_y(delta: float) -> void
rotate(radians: float) -> void
to_local(global_point: Vector2) -> Vector2
to_global(local_point: Vector2) -> Vector2
```

### CharacterBody2D - 角色控制
```gdscript
extends CharacterBody2D

# 内置变量
velocity: Vector2

# 核心方法
move_and_slide() -> bool                      # 滑动移动
move_and_collide(motion: Vector2) -> KinematicCollision2D

# 碰撞检测辅助
is_on_floor() -> bool
is_on_ceiling() -> bool
is_on_wall() -> bool

# 平台器常用
const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0

func _physics_process(delta: float) -> void:
    # 重力
    if not is_on_floor():
        velocity += get_gravity() * delta

    # 跳跃
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    # 水平移动
    var direction := Input.get_axis("move_left", "move_right")
    if direction:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
```

### Area2D - 触发区域
```gdscript
extends Area2D

# 信号
signal body_entered(body: Node2D)
signal body_exited(body: Node2D)
signal area_entered(area: Area2D)
signal area_exited(area: Area2D)

# 常用方法
get_overlapping_bodies() -> Array[Node2D]
get_overlapping_areas() -> Array[Area2D]
overlaps_body(body: Node) -> bool
overlaps_area(area: Area2D) -> bool
```

### Sprite2D - 精灵显示
```gdscript
extends Sprite2D

# 属性
texture: Texture2D
flip_h: bool      # 水平翻转
flip_v: bool      # 垂直翻转
modulate: Color   # 颜色调制
self_modulate: Color

# 动画常用
hframes: int      # 水平帧数
vframes: int      # 垂直帧数
frame: int        # 当前帧
frame_coords: Vector2i  # 帧坐标
```

### AnimationPlayer - 动画控制
```gdscript
extends AnimationPlayer

# 播放控制
play(name: String, custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false)
stop(keep_state: bool = false)
pause()

# 状态查询
is_playing() -> bool
current_animation: String
current_animation_position: float
current_animation_length: float

# 动画事件
animation_finished.connect(func(anim_name: String): pass)
```

---

## 向量数学 (Vector2)

```gdscript
# 创建
var v := Vector2(x, y)
var up := Vector2.UP        # (0, -1)
var down := Vector2.DOWN    # (0, 1)
var left := Vector2.LEFT    # (-1, 0)
var right := Vector2.RIGHT  # (1, 0)
var one := Vector2.ONE      # (1, 1)
var zero := Vector2.ZERO    # (0, 0)

# 常用属性
v.x, v.y           # 分量
v.length()         # 长度
v.length_squared() # 长度平方（更快）
v.normalized()     # 单位向量
v.angle()          # 弧度角度

# 常用方法
v.distance_to(other: Vector2) -> float
v.distance_squared_to(other: Vector2) -> float
v.direction_to(other: Vector2) -> Vector2  # 单位方向向量
v.dot(other: Vector2) -> float
v.lerp(to: Vector2, weight: float) -> Vector2
v.move_toward(to: Vector2, delta: float) -> Vector2
v.rotated(angle: float) -> Vector2
v.snapped(step: Vector2) -> Vector2

# 运算
v1 + v2, v1 - v2, v1 * scalar, v1 / scalar
```

---

## 输入处理

```gdscript
# 按键检测
Input.is_action_pressed(action: StringName) -> bool      # 按住
Input.is_action_just_pressed(action: StringName) -> bool # 刚按下
Input.is_action_just_released(action: StringName) -> bool # 刚释放

# 轴输入
Input.get_axis(negative_action: StringName, positive_action: StringName) -> float
# 例如: Input.get_axis("move_left", "move_right") 返回 -1, 0, 或 1

# 向量输入
Input.get_vector(negative_x: StringName, positive_x: StringName,
                 negative_y: StringName, positive_y: StringName) -> Vector2
# 例如: Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

# 鼠标
Input.get_mouse_position() -> Vector2  # 视口坐标
Input.is_mouse_button_pressed(button: MouseButton) -> bool
Input.set_mouse_mode(mode: MouseMode)

# 常用 MouseMode
Input.MOUSE_MODE_VISIBLE
Input.MOUSE_MODE_HIDDEN
Input.MOUSE_MODE_CAPTURED  # 锁定鼠标到窗口中心
```

---

## 场景树操作

```gdscript
# 获取节点
$NodeName                    # 简写，等价于 get_node("NodeName")
%UniqueNodeName             # 使用唯一名（Godot 4 特性）
get_node(path: NodePath) -> Node
get_node_or_null(path: NodePath) -> Node
find_child(pattern: String, recursive: bool = true, owned: bool = true) -> Node

# 节点关系
get_parent() -> Node
get_children(recursive: bool = false) -> Array[Node]
get_child(index: int, include_internal: bool = false) -> Node
get_child_count() -> int

# 场景树
get_tree() -> SceneTree
get_tree().current_scene: Node
get_tree().root: Window  # 根视口
get_tree().paused: bool

# 添加/删除
add_child(node: Node, force_readable_name: bool = false, internal: InternalMode = 0)
remove_child(node: Node)
queue_free()              # 延迟删除（推荐）
free()                    # 立即删除（慎用）

# 实例化场景
const SCENE = preload("res://path/to/scene.tscn")
var instance = SCENE.instantiate()
add_child(instance)
```

---

## 资源加载

```gdscript
# preload - 编译时加载，路径必须是常量
const MY_SCENE = preload("res://scene.tscn")
const MY_TEXTURE = preload("res://sprite.png")

# load - 运行时加载，路径可以是变量
var path := "res://level" + str(level_num) + ".tscn"
var scene = load(path)

# 加载并实例化
var packed_scene: PackedScene = load("res://enemy.tscn")
var enemy: Node2D = packed_scene.instantiate()
```

---

## 随机数

```gdscript
# 全局随机
randf() -> float              # 0.0 到 1.0
randf_range(from: float, to: float) -> float
randi() -> int                # 随机整数
randi_range(from: int, to: int) -> int
randi() % 20                  # 0 到 19

# RandomNumberGenerator 类（可种子化）
var rng := RandomNumberGenerator.new()
rng.randomize()               # 随机种子
rng.seed = 12345              # 固定种子
var num := rng.randf_range(0.0, 100.0)

# 从数组随机选择
var items := ["sword", "shield", "potion"]
var item := items[randi() % items.size()]
# 或使用自定义工具函数
func rand_choice(arr: Array):
    return arr[randi() % arr.size()]
```

---

## 常用数学函数

```gdscript
# 限制/插值
clamp(value: float, min: float, max: float) -> float
clampi(value: int, min: int, max: int) -> int
lerp(from: float, to: float, weight: float) -> float  # 线性插值
lerpf(from: float, to: float, weight: float) -> float
move_toward(from: float, to: float, delta: float) -> float

# 角度
deg_to_rad(deg: float) -> float
rad_to_deg(rad: float) -> float
wrapf(value: float, min: float, max: float) -> float

# 距离
abs(x), absf(x), absi(x)
sign(x), signf(x), signi(x)
sqrt(x), pow(base, exp)
ceil(x), floor(x), round(x), snapped(x, step)

# 2D 工具
global_position.distance_to(target) < 100.0
global_position.direction_to(target).normalized()
```

---

## 信号系统

```gdscript
# 定义信号
signal health_changed(new_health: int, max_health: int)
signal died
signal item_picked_up(item: ItemResource)

# 发射信号
health_changed.emit(health, max_health)

# 连接信号（接收方）
func _ready() -> void:
    player.health_changed.connect(_on_player_health_changed)
    player.died.connect(_on_player_died, CONNECT_ONE_SHOT)  # 只触发一次

    # lambda 连接
    button.pressed.connect(func(): print("clicked"))

# 断开连接
player.health_changed.disconnect(_on_player_health_changed)

# 连接选项（ConnectFlags）
CONNECT_ONE_SHOT      # 只触发一次后自动断开
CONNECT_DEFERRED      # 延迟到空闲帧执行
CONNECT_PERSIST       # 场景切换后保持连接
CONNECT_REFERENCE_COUNTED  # 引用计数
```

---

## Timer 节点

```gdscript
extends Timer

# 属性
wait_time: float      # 等待时间
one_shot: bool        # 是否只触发一次
autostart: bool       # 自动启动
paused: bool

# 方法
start(time_sec: float = -1)  # time_sec 覆盖 wait_time
stop()

# 信号
timeout.connect(func(): print("timer done"))

# 常用模式 - 射击冷却
@onready var shoot_timer: Timer = $ShootTimer

func _ready() -> void:
    shoot_timer.wait_time = 0.5  # 500ms 冷却
    shoot_timer.one_shot = true

func shoot() -> void:
    if shoot_timer.is_stopped():
        _fire_bullet()
        shoot_timer.start()
```

---

## RayCast2D - 射线检测

```gdscript
extends RayCast2D

# 属性
target_position: Vector2   # 射线方向/长度
collide_with_bodies: bool
collide_with_areas: bool
collision_mask: int

# 方法
force_raycast_update() -> void  # 立即更新
is_colliding() -> bool
get_collider() -> Object
get_collision_point() -> Vector2
get_collision_normal() -> Vector2

# 使用示例
target_position = Vector2.RIGHT * 100
force_raycast_update()
if is_colliding():
    var collider = get_collider()
```

---

## 颜色 (Color)

```gdscript
# 创建
var c := Color.red
var c := Color(1.0, 0.0, 0.0)           # RGB
var c := Color(1.0, 0.0, 0.0, 0.5)      # RGBA
var c := Color.html("#ff0000")
var c := Color.html("ff00007f")         # 带透明度

# 常量
Color.WHITE, Color.BLACK, Color.RED, Color.GREEN, Color.BLUE
Color.TRANSPARENT

# 操作
c.lerp(other: Color, weight: float) -> Color
c.darkened(amount: float) -> Color
c.lightened(amount: float) -> Color

# 用于 modulate
sprite.modulate = Color.red
sprite.modulate.a = 0.5  # 半透明
```

---

## 常见错误避免

| 错误 | 正确 |
|------|------|
| `position.x += 1` | `position += Vector2.RIGHT` |
| `rotation = 90` | `rotation_degrees = 90` 或 `rotation = deg_to_rad(90)` |
| `if velocity == 0:` | `if velocity == Vector2.ZERO:` |
| `free()` | `queue_free()`（更安全） |
| `load("path")` | `preload("path")`（如果路径是常量） |
| `get_parent().add_child(x)` | `get_tree().current_scene.add_child(x)`（避免警告） |

---

## 完整 RPG 玩家模板

```gdscript
extends CharacterBody2D
class_name Player

# 信号
signal health_changed(new_health: int, max_health: int)
signal died

# 导出变量
@export var speed: float = 200.0
@export var max_health: int = 100

# 内部变量
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var health: int = max_health

func _ready() -> void:
    health = max_health

func _physics_process(delta: float) -> void:
    _handle_input()
    _update_animation()
    move_and_slide()

func _handle_input() -> void:
    var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    velocity = direction * speed

func _update_animation() -> void:
    if velocity == Vector2.ZERO:
        animation_player.play("idle")
    else:
        sprite.flip_h = velocity.x < 0
        animation_player.play("walk")

func take_damage(amount: int) -> void:
    health = clampi(health - amount, 0, max_health)
    health_changed.emit(health, max_health)

    if health <= 0:
        died.emit()
        queue_free()

func heal(amount: int) -> void:
    health = clampi(health + amount, 0, max_health)
    health_changed.emit(health, max_health)
```

---

## Java vs GDScript 概念速查

> 为 Java 开发者提供的快速概念映射

### 核心概念对照

| Java 概念 | GDScript 等价 | 备注 |
|-----------|---------------|------|
| `class MyClass` | `class_name MyClass` | GDScript 中 extends 和 class_name 分开 |
| 构造函数 `MyClass()` | `_ready()` | 节点进入场景树时调用 |
| `this` | `self` | 显式使用较少 |
| `null` | `null` | 相同 |
| `final` | `const` | 常量定义 |
| `private` | `_` 前缀 | 命名约定，非强制 |
| `extends` | `extends` | 相同关键字 |
| `@Override` | 无需注解 | 直接重写父类方法 |

### 类型系统对比

```java
// Java
private int health = 100;
private Player player;
private List<String> items = new ArrayList<>();

public void takeDamage(int amount) { }
public Vector2 getPosition() { return position; }
```

```gdscript
# GDScript
var health: int = 100
var player: Player
var items: Array[String] = []

func take_damage(amount: int) -> void:
    pass

func get_position() -> Vector2:
    return position
```

### 集合类型对比

| Java | GDScript | 说明 |
|------|----------|------|
| `ArrayList<T>` | `Array[T]` | 动态数组 |
| `HashMap<K,V>` | `Dictionary` | 键值对 |
| `HashSet<T>` | 无原生支持 | 可用 `Array` + 手动去重 |

```gdscript
# Array（类似 Java ArrayList）
var items: Array[String] = ["sword", "shield"]
items.append("potion")  # 类似 add()
items.remove_at(0)      # 类似 remove(index)

# Dictionary（类似 Java HashMap）
var stats: Dictionary = {"health": 100, "mana": 50}
print(stats["health"])  # 访问方式类似
stats["level"] = 1      # 直接赋值，自动添加键
```

### 控制流对比

| Java | GDScript |
|------|----------|
| `if (x == y)` | `if x == y:` |
| `for (int i=0; i<n; i++)` | `for i in range(n):` |
| `for (Item item : items)` | `for item in items:` |
| `while (condition)` | `while condition:` |
| `switch/case` | `match` |

```gdscript
# match 示例（类似 switch，但更强大）
match state:
    State.IDLE:
        play_idle()
    State.WALK:
        play_walk()
    _:
        print("未知状态")  # default 情况
```

### 事件/信号系统对比

```java
// Java - 传统回调接口
interface HealthListener {
    void onHealthChanged(int newHealth);
}

class Player {
    private List<HealthListener> listeners = new ArrayList<>();

    public void addHealthListener(HealthListener l) {
        listeners.add(l);
    }

    public void takeDamage(int dmg) {
        health -= dmg;
        for (HealthListener l : listeners) {
            l.onHealthChanged(health);
        }
    }
}
```

```gdscript
# GDScript - Signal 系统（更简洁）
class_name Player
extends Node

signal health_changed(new_health: int)

func take_damage(dmg: int) -> void:
    health -= dmg
    health_changed.emit(health)  # 发射信号

# 连接信号（在另一个脚本中）
player.health_changed.connect(_on_player_health_changed)
```

### 常见陷阱提醒

| 陷阱 | Java 思维 | GDScript 实际 |
|------|-----------|---------------|
| 整数除法 | `3/2 = 1` | `3/2 = 1`（相同）但注意类型 |
| 字符串拼接 | `"HP:" + hp` | `"HP:%d" % hp` 或 `"HP:" + str(hp)` |
| 空检查 | `if (obj != null)` | `if obj != null:` 或 `if is_instance_valid(obj):` |
| 删除对象 | `obj = null` | `obj.queue_free()` + `obj = null` |
| 数组长度 | `array.length` | `array.size()` |

### 游戏循环概念

```java
// Java 游戏开发常见模式
public void update(float deltaTime) {
    // 每帧调用
}
```

```gdscript
# Godot 提供两个主要循环函数

func _process(delta: float) -> void:
    # 每帧调用，delta 是帧间隔时间（秒）
    # 用于 UI、动画、非物理相关更新
    pass

func _physics_process(delta: float) -> void:
    # 固定频率调用（默认 60fps），与物理同步
    # 用于移动、碰撞检测、游戏逻辑
    pass
```

### 节点树 vs 对象引用

```java
// Java - 直接对象引用
Player player = new Player();
player.takeDamage(10);
```

```gdscript
# GDScript - 节点树路径访问
@onready var player: Player = $"../Player"  # 相对路径
@onready var player: Player = get_node("/root/Main/Player")  # 绝对路径

# 或使用唯一的节点名（Godot 4 特性）
@onready var player: Player = %Player
```
