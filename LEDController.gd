extends Control


onready var color_buttons = [
	get_node("CenterContainer/Panel/VBoxContainer/HBoxContainer3/Button1"),
	get_node("CenterContainer/Panel/VBoxContainer/HBoxContainer3/Button2"),
	get_node("CenterContainer/Panel/VBoxContainer/HBoxContainer3/Button3"),
	get_node("CenterContainer/Panel/VBoxContainer/HBoxContainer3/Button4"),
	get_node("CenterContainer/Panel/VBoxContainer/HBoxContainer3/Button5"),
	get_node("CenterContainer/Panel/VBoxContainer/HBoxContainer3/Button6")
]

onready var effect_selector = get_node("CenterContainer/Panel/VBoxContainer/OptionButton")
onready var intensity_slider = get_node("CenterContainer/Panel/VBoxContainer/HSlider")
onready var turn_off_check = get_node("CenterContainer/Panel/VBoxContainer/CheckButton")
onready var loop_effects_check = get_node("CenterContainer/Panel/VBoxContainer/CheckBox2")
onready var glow_effect_check = get_node("CenterContainer/Panel/VBoxContainer/CheckBox3")
onready var serial_controller = get_node("SerialController")

var last_command = ""


func _ready() -> void:
	for button in color_buttons:
		button.connect("pressed", self, "_on_color_selected", [button.text])

	effect_selector.connect("item_selected", self, "_on_effect_changed")
	intensity_slider.connect("value_changed", self, "_on_intensity_changed")
	turn_off_check.connect("toggled", self, "_on_toggle_off")
	loop_effects_check.connect("toggled", self, "_on_loop_toggled")
	glow_effect_check.connect("toggled", self, "_on_glow_toggled")

	serial_controller.OpenPort()


func _on_color_selected(color):
	_send_to_led_controller(color)
	last_command = color
	effect_selector.selected = -1
	loop_effects_check.pressed = false

func _on_effect_changed(index):
	var character = ["g", "h", "i", "j"]
	_send_to_led_controller(character[index])
	last_command = character[index]
	loop_effects_check.pressed = false


func _on_intensity_changed(value):
	_send_to_led_controller(str(value))

func _on_toggle_off(enabled):
	if enabled:
		_send_to_led_controller("0")
	else:
		_send_to_led_controller(last_command)

func _on_loop_toggled(enabled):
	if enabled:
		_send_to_led_controller("l")
	else:
		_send_to_led_controller(last_command)

func _on_glow_toggled(enabled):
	if enabled:
		_send_to_led_controller("s")
	else:
		_send_to_led_controller(last_command)

func _send_to_led_controller(character):
	serial_controller.SendCharacter(character)
