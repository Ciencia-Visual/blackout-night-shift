extends Node

# UI Elements
@export var north_panel_button : Button
@export var generator_button : Button

@export var time_label : Label
@export var security_label : Label
@export var energy_label : Label
@export var alert_panel : Control

@export var northpanelpopup_popup: Control
@export var generator_popup : Control
@export var religamento_popup  : Control

#@export var slot_label = $Popups/GeneratorPopup/MainVBox/CircuitRow/SlotLabel

var elapsed_time := 0.0
var energy := 100.0
var energy_timer := 0.0

var argus_message_2 := false
var argus_message_3 := false
var argus_message_4 := false
var argus_message_5 := false

var north_panel_fault_triggered := false
var north_panel_blink=false

var protocol_2_triggered = false
var generator_blink = false

var religamento_ativo=false

var night_finished = false


func _ready():
	alert_panel.hide()
	energy_label.text = "Energia: %d%%" % energy
	time_label.text = "Hora: 00:00"
	set_north_panel_status("online")
	set_generator_status("online")
	update_security_monitor(
	"ARGUS AI
	STATUS:
	Nenhum movimento detectado."
		)
	northpanelpopup_popup.protocolo_concluido.connect(_on_maintenance_concluido)
	generator_popup.gerador_reparado.connect(_on_generator_reparado)
	generator_popup.peca_errada.connect(_on_peca_errada)
	
	#print(generator_popup)
	#print(generator_popup.get_script())
	

func set_north_panel_status(status: String):
	match status: 
		"online": 
			north_panel_button.text = "🟢 PAINEL NORTE\nONLINE" 
			north_panel_button.add_theme_color_override("font_color", Color.GREEN) 
		"fault":
			north_panel_button.text = "🔴 PAINEL NORTE\nFALHA"
			north_panel_button.add_theme_color_override("font_color", Color.RED)
		"restored":
			north_panel_button.text = "🟢 PAINEL NORTE\nRESTAURADO" # ✔️
			north_panel_button.add_theme_color_override("font_color", Color.GREEN)
			


func set_generator_status(status):
	if status == "online":
		generator_button.text = "🟢 GERADOR\nONLINE"
		generator_button.add_theme_color_override("font_color", Color.GREEN)
	elif status == "fault":
		generator_button.text = "🔴 GERADOR\nFALHA"
		generator_button.add_theme_color_override("font_color", Color.RED)
	elif status == "restored":
		generator_button.text = "🟢 GERADOR\nRESTAURADO"
		generator_button.add_theme_color_override("font_color", Color.GREEN)
		
		
func update_clock(delta):
	elapsed_time += delta
	var total_seconds := int(elapsed_time)
	var start_hour := 22
	@warning_ignore("integer_division")
	var hours : int = (start_hour + (total_seconds / 60)) % 24
	@warning_ignore("integer_division")
	var minutes : int = total_seconds % 60
	time_label.text = "Hora: %02d:%02d" % [hours, minutes]
	return {
		"hours": hours,
		"minutes": minutes
	}


func _process(delta):
	energy_timer += delta
	
	# Diminuição da energia
	if energy_timer >= 5:
		energy_timer = 0.0
		energy -= 1.0
		if north_panel_blink:
			energy -= 3.0
		if generator_blink:
			energy -= 3.0
		energy_label.text = "Energia: %d%%" % energy
		
	# Update Clock
	var current_time = update_clock(delta)
	var hours = current_time["hours"]
	var minutes = current_time["minutes"]
	
	check_night_events(hours, minutes)
	
	if north_panel_blink:
		@warning_ignore("integer_division")
		if int(Time.get_ticks_msec() / 300) % 2 == 0:
			north_panel_button.add_theme_color_override("font_color", Color.RED)
		else:
			north_panel_button.add_theme_color_override("font_color", "#dfdfdf00")
	else:
		north_panel_button.add_theme_color_override("font_color", Color.GREEN)
	if generator_blink:
		@warning_ignore("integer_division")
		if int(Time.get_ticks_msec() / 300.0) % 2 == 0:
			generator_button.add_theme_color_override("font_color", Color.RED)
		else:
			generator_button.add_theme_color_override("font_color", "#dfdfdf00")
	else:
		generator_button.add_theme_color_override("font_color", Color.GREEN)


func check_night_events(hours, minutes):
	if hours == 22 and minutes == 3 and !north_panel_fault_triggered:
		north_panel_fault_triggered = true
		show_alert()
		update_security_monitor(
			"ARGUS AI
			STATUS:
			Movimento detectado.
			Distância: 100 m"
		)
		set_north_panel_status("fault")
		north_panel_blink=true
	if hours == 22 and minutes == 10 and !argus_message_2:
		argus_message_2 = true
		update_security_monitor(
        "ARGUS AI
		STATUS:
		Assinatura térmica confirmada.
		Origem desconhecida.
		Distância: 70 m"
  		  )
	if hours == 22 and minutes == 15 and !protocol_2_triggered:
		protocol_2_triggered = true
		set_generator_status("fault")
		generator_blink = true
		show_alert()
	if hours == 22 and minutes == 20 and !argus_message_3:
		argus_message_3 = true
		update_security_monitor(
        "ARGUS AI
		STATUS:
		Trajetória confirmada.
		Objeto em aproximação.
		Distância: 45 m"
		)
	if hours == 22 and minutes == 30 and !argus_message_4:
		argus_message_4 = true
		update_security_monitor(
        "ARGUS AI
		⚠️ CONTATO VISUAL
		Entidade não identificada.
		Distância: 20 m"
		)
	if hours == 22 and minutes == 40 and !argus_message_5:
		argus_message_5 = true
		update_security_monitor(
        "ARGUS AI
		⚠️ ALERTA MÁXIMO
		Ameaça confirmada.
		Distância: 5 m"
	)
	if hours == 22 and minutes == 45 and !religamento_ativo:
		religamento_ativo = true
		religamento_popup.iniciar_protocolo()
		update_security_monitor(
		"ARGUS AI,
		⚠️ PROTOCOLO 03\nDisjuntor D-17 desarmado.\nAguardando dissipação da corrente residual."
		)
	if hours == 22 and minutes == 15 and !protocol_2_triggered:
		protocol_2_triggered = true
		set_generator_status("fault")
		generator_blink = true
		update_security_monitor(
			"ARGUS AI,
		⚠️ PROTOCOLO 03\nDisjuntor D-17 desarmado.\nAguardando dissipação da corrente residual."
		)
	if hours == 23 and minutes == 20 and !night_finished:
		night_finished = true
		finish_night()


func finish_night():
	update_security_monitor(
		"ARGUS AI
		Turno encerrado.
		Todos os protocolos foram concluídos.
		Bom trabalho, Operador."
		)
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/night_complete.tscn")


func show_alert():
	alert_panel.show()
	await get_tree().create_timer(6.0).timeout
	alert_panel.hide()
	
	
func update_security_monitor(message):
	security_label.text = message
	

func _on_north_panel_button_pressed():
	if north_panel_blink:
		northpanelpopup_popup.visible = true

func _on_generator_button_pressed() -> void:
	if generator_blink:
		generator_popup.visible = true

func _on_maintenance_concluido():
	set_north_panel_status("restored")
	north_panel_blink = false
	await get_tree().create_timer(1.5).timeout
	set_generator_status("online")
	
func _on_generator_reparado():
	generator_blink = false
	set_generator_status("restored")
	await get_tree().create_timer(1.5).timeout
	set_generator_status("online")
	
	
func _on_peca_errada():
	energy -= 5
	energy_label.text = "Energia: %d%%" % energy
