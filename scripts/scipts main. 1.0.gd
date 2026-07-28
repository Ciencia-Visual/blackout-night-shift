extends Node

@onready var north_panel_button = $HUD/NorthPanelButton
@onready var time_label = $HUD/Header/Timelabel
@onready var option_a = $Popups/Maintenancepopup/MarginContainer/VBoxContainer/OptionA

@onready var option_b = $Popups/Maintenancepopup/MarginContainer/VBoxContainer/OptionB

@onready var result_label = $Popups/Maintenancepopup/MarginContainer/VBoxContainer/ResultLabel
var elapsed_time := 0.0
var energy := 100
var north_panel_fault_triggered := false
var argus_message_2 := false
var argus_message_3 := false
var argus_message_4 := false
var argus_message_5 := false
@onready var energy_label = $HUD/Header/EnergyLabel
@onready var alert_panel = $AlertPanel
var north_panel_blink=false
@onready var security_label = $HUD/SecurityMonitor/SecurityLabel



func _ready():
	alert_panel.hide()
	energy_label.text = "Energia: %d%%" % energy
	time_label.text = "Hora: 00:00"
	set_north_panel_status("online")
	update_security_monitor(
	"ARGUS AI
	STATUS:
	Nenhum movimento detectado."
		)
func set_north_panel_status(status: String):
	match status: 
		"online": 
			north_panel_button.text = "🟢 PAINEL NORTE\nONLINE" 
			north_panel_button.add_theme_color_override("font_color", Color.GREEN) 
			north_panel_button.disabled = false
		"fault":
			north_panel_button.text = "🔴 PAINEL NORTE\nFALHA"
			north_panel_button.add_theme_color_override("font_color", Color.RED)
		"restored":
			north_panel_button.text = "✔️ PAINEL NORTE\nRESTAURADO"
			north_panel_button.add_theme_color_override("font_color", Color.GREEN)
			north_panel_button.disabled = true

func update_clock(delta):
	elapsed_time += delta
	var total_seconds = int(elapsed_time)
	var start_hour = 22
	var hours = (start_hour + (total_seconds / 60)) % 24
	var minutes = total_seconds % 60
	time_label.text = "Hora: %02d:%02d" % [hours, minutes]
	return {
		"hours": hours,
		"minutes": minutes
	}

func _process(delta):
	var current_time = update_clock(delta)
	if north_panel_blink:
		if int(Time.get_ticks_msec() / 300) % 2 == 0:
			north_panel_button.visible = true
		else:
			north_panel_button.visible = false
	else:
		north_panel_button.visible = true
	var hours = current_time["hours"]
	var minutes = current_time["minutes"]
	check_night_events(hours, minutes)




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
func show_alert():
	alert_panel.show()
	await get_tree().create_timer(6.0).timeout
	alert_panel.hide()
	
func update_security_monitor(message):
	security_label.text = message



func _on_north_panel_button_pressed():
	$Popups/Maintenancepopup.visible = true


func _on_confirm_button_pressed():

	if option_a.button_pressed:

		result_label.text = "✅ PROTOCOLO EXECUTADO COM SUCESSO"
		set_north_panel_status("restored")
		north_panel_blink=false
		await get_tree().create_timer(1.2).timeout

		$Popups/Maintenancepopup.hide()

		option_a.button_pressed = false
		option_b.button_pressed = false
		result_label.text = ""

	elif option_b.button_pressed:

		result_label.text = "❌ PROCEDIMENTO INVÁLIDO"
		set_north_panel_status("fault")
		energy -= 5
		energy_label.text = "Energia: %d%%" % energy
	else:

		result_label.text = "⚠️ Selecione uma opção."
