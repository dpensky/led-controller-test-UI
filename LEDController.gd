extends Control


onready var color_buttons = [
	get_node("CenterContainer/HBoxContainer/Panel/VBoxContainer/HBoxContainer3/Button1"),
	get_node("CenterContainer/HBoxContainer/Panel/VBoxContainer/HBoxContainer3/Button2"),
	get_node("CenterContainer/HBoxContainer/Panel/VBoxContainer/HBoxContainer3/Button3"),
	get_node("CenterContainer/HBoxContainer/Panel/VBoxContainer/HBoxContainer3/Button4"),
	get_node("CenterContainer/HBoxContainer/Panel/VBoxContainer/HBoxContainer3/Button5"),
	get_node("CenterContainer/HBoxContainer/Panel/VBoxContainer/HBoxContainer3/Button6")
]

onready var effect_selector = get_node("CenterContainer/HBoxContainer/Panel/VBoxContainer/OptionButton")
onready var intensity_slider = get_node("CenterContainer/HBoxContainer/Panel/VBoxContainer/HSlider")
onready var turn_off_button = get_node("CenterContainer/HBoxContainer/Panel/VBoxContainer/Button")
onready var loop_effects_check = get_node("CenterContainer/HBoxContainer/Panel/VBoxContainer/CheckBox2")
onready var glow_effect_check = get_node("CenterContainer/HBoxContainer/Panel/VBoxContainer/CheckBox3")
onready var serial_controller = get_node("SerialController")

onready var config_panel = get_node("CenterContainer/HBoxContainer/Panel2")
onready var config_port = get_node("CenterContainer/HBoxContainer/Panel2/VBoxContainer/OptionButton")
onready var config_baund = get_node("CenterContainer/HBoxContainer/Panel2/VBoxContainer/LineEdit")

onready var log_label = get_node("Label")

var last_color = ""
var last_effect = ""
var last_command = ""


func _ready() -> void:
	for button in color_buttons:
		button.connect("pressed", self, "_on_color_selected", [button.text])

	effect_selector.selected = -1
	effect_selector.text = "Select an effect"
	effect_selector.connect("item_selected", self, "_on_effect_changed")

	intensity_slider.value = 9
	intensity_slider.connect("value_changed", self, "_on_intensity_changed")

	turn_off_button.connect("pressed", self, "_on_turnoff_pressed")

	loop_effects_check.pressed = false
	loop_effects_check.connect("toggled", self, "_on_loop_toggled")

	glow_effect_check.pressed = false
	glow_effect_check.connect("toggled", self, "_on_glow_toggled")

	config_panel.hide()
	var ports = Array(serial_controller.GetAllPorts())
	for port in ports:
		config_port.add_item(port)
	var index = ports.find(serial_controller.PortName)
	if index != -1:
		config_port.selected = index
	
	config_baund.text = str(serial_controller.BaudRate)

	serial_controller.connect("StatusChanged", self, "on_serial_status_changed")
	serial_controller.OpenPort()


func _on_color_selected(color):
	_send_to_led_controller(color)
	last_command = "color"
	last_color = color
	last_effect = ""

func _on_effect_changed(index):
	var character = ["g", "h", "i", "j"]
	_send_to_led_controller(character[index])
	last_command = "effect"
	last_effect = character[index]
	last_color = ""

func _on_intensity_changed(value):
	_send_to_led_controller(str(value))

func _on_turnoff_pressed():
	glow_effect_check.pressed = false
	loop_effects_check.pressed = false
	_send_to_led_controller("0")

func _on_loop_toggled(enabled):
	if enabled:
		_send_to_led_controller("l")

func _on_glow_toggled(enabled):
	if enabled:
		_send_to_led_controller("s")
	else:
		if last_command == "color":
			_send_to_led_controller(last_color)
		elif last_command == "effect":
			_send_to_led_controller(last_effect)

func _send_to_led_controller(character):
	serial_controller.WriteData(character)

func toggle_config_visibility() -> void:
	config_panel.visible = not config_panel.visible
	$CenterContainer/HBoxContainer/Button.text = "<" if config_panel.visible else ">"

func apply_config() -> void:
	var changed = false
	var new_port = config_port.text
	var new_bound = int(config_baund.text)
	if new_port != serial_controller.PortName:
		changed = true
	if new_bound != serial_controller.BaudRate:
		changed = true
	if changed:
		serial_controller.ClosePort()
		yield(get_tree().create_timer(1), "timeout")
		serial_controller.PortName = new_port
		serial_controller.BaudRate = new_bound
		serial_controller.OpenPort()

func on_serial_status_changed(message: String) -> void:
	log_label.text = message
