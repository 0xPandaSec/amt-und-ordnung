extends Node3D
## Einstiegspunkt: baut Keller, Tisch, Gegner und die eigene Hand.
##
## Steuerung:  Rechte Maustaste halten = umsehen
##             Pfeiltasten / Q E       = umsehen
##             Maus auf einer Karte    = Karte hebt sich
##             Esc                     = beenden
##
## Screenshot-Modus (ohne Fensterinteraktion):
##   godot --path . -- --screenshot --hover=2 --yaw=0 --pitch=-7
##   godot --path . -- --screenshot --out=res://out/game/shot.png

const Kit := preload("res://src/scene_kit.gd")
const Room := preload("res://src/room.gd")
const Bot := preload("res://src/bot.gd")
const Hand := preload("res://src/hand.gd")

const HAND_CARDS: Array[String] = [
	"widerspruch", "bauantrag", "formfehler", "akteneinsicht", "laermprotokoll",
]

const LOOK_SENS := 0.22

var rig: Node3D
var camera: Camera3D
var hand
var bots: Array[Node3D] = []
var clock := 0.0
var hint_label: Label
var hint_layer: CanvasLayer

var yaw := 0.0
var pitch := -7.0
var dragging := false

var shot := false
var shot_frames := 0
var shot_path := "res://out/game/screenshot.png"
var shot_done := false
var forced_hover := -1

var selftest := false
var selftest_frames := 0
var show_hud := false
var smoke := false
var smoke_frames := 0


func _ready() -> void:
	_parse_args()
	_build_environment()
	_build_world()
	_pose_camera()
	_build_hud()
	if shot and not show_hud:
		hint_layer.visible = false
	if shot:
		hand.forced = forced_hover


func _parse_args() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg == "--screenshot":
			shot = true
		elif arg == "--selftest":
			selftest = true
		elif arg == "--hud":
			show_hud = true
		elif arg == "--smoke":
			smoke = true
		elif arg.begins_with("--hover="):
			forced_hover = int(arg.get_slice("=", 1))
		elif arg.begins_with("--yaw="):
			yaw = float(arg.get_slice("=", 1))
		elif arg.begins_with("--pitch="):
			pitch = float(arg.get_slice("=", 1))
		elif arg.begins_with("--out="):
			shot_path = arg.get_slice("=", 1)


# --------------------------------------------------------------- Umgebung
func _build_environment() -> void:
	var we := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.02, 0.018, 0.016)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.40, 0.38, 0.34)
	env.ambient_light_energy = 0.15
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.tonemap_exposure = 0.92
	env.ssao_enabled = true
	env.ssao_radius = 0.55
	env.ssao_intensity = 1.6
	env.glow_enabled = true
	env.glow_intensity = 0.22
	env.glow_bloom = 0.04
	env.glow_hdr_threshold = 1.15
	env.fog_enabled = true
	env.fog_light_color = Color(0.10, 0.09, 0.075)
	env.fog_density = 0.014
	env.fog_sky_affect = 0.0
	we.environment = env
	add_child(we)


# ------------------------------------------------------------------ Welt
func _build_world() -> void:
	var back: Texture2D = load("res://assets/faces/_back.png")
	var discard_faces: Array = [
		load("res://assets/faces/formfehler.png"),
		load("res://assets/faces/vorgang-vertagen.png"),
		load("res://assets/faces/akteneinsicht.png"),
	]
	Room.build(self, back, discard_faces)

	rig = Node3D.new()
	rig.name = "PlayerRig"
	add_child(rig)
	rig.position = Vector3(0.0, 1.17, 1.26)

	camera = Camera3D.new()
	camera.name = "Camera"
	camera.fov = 62.0
	camera.near = 0.02
	camera.far = 60.0
	var attrs := CameraAttributesPractical.new()
	attrs.dof_blur_far_enabled = true
	attrs.dof_blur_far_distance = 2.6
	attrs.dof_blur_far_transition = 2.2
	attrs.dof_blur_amount = 0.04
	camera.attributes = attrs
	rig.add_child(camera)

	# Aufhelllicht für die Handkarten, damit sie nicht im Schatten liegen
	Kit.omni(camera, Vector3(0, 0.03, 0.02), Color(1.0, 0.94, 0.84), 0.25, 1.6, false)

	hand = Hand.new()
	hand.name = "Hand"
	camera.add_child(hand)
	hand.position = Vector3(0.0, -0.086, -0.395)
	hand.build(HAND_CARDS)

	var looks := [
		{"shirt": Color("8a6a34"), "hat": true, "hair": Color("2b2119"), "tie": Color("55303f")},
		{"shirt": Color("2f4a44"), "glasses": true, "beard": true, "hair": Color("4a3a2c")},
		{"shirt": Color("55303f"), "hair": Color("241c18"), "tie": Color("2f4a44")},
	]
	var back_mat := Kit.card_mat(back, 0.02, Color(0.64, 0.64, 0.64))
	for i in Room.SEATS.size():
		var seat: Vector3 = Room.SEATS[i]
		var b := Bot.build(self, seat, Room.seat_yaw(seat), looks[i], back_mat)
		bots.append(b)


func _pose_camera() -> void:
	if rig == null or camera == null:
		return
	rig.rotation_degrees.y = yaw
	camera.rotation_degrees.x = pitch


func _build_hud() -> void:
	var layer := CanvasLayer.new()
	hint_layer = layer
	add_child(layer)
	hint_label = Label.new()
	hint_label.text = "Rechte Maustaste halten — umsehen          Maus auf einer Karte — Karte anheben"
	hint_label.add_theme_font_size_override("font_size", 16)
	hint_label.add_theme_color_override("font_color", Color(0.86, 0.83, 0.76))
	hint_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.85))
	hint_label.add_theme_constant_override("shadow_offset_x", 1)
	hint_label.add_theme_constant_override("shadow_offset_y", 2)
	hint_label.position = Vector2(30, 844)
	layer.add_child(hint_label)


# ---------------------------------------------------------------- Ablauf
func _process(delta: float) -> void:
	clock += delta
	_animate_bots()
	if hint_label != null:
		var fade := 1.0
		if clock > 9.0:
			fade = clampf(1.0 - (clock - 9.0) / 2.5, 0.0, 1.0)
		hint_label.modulate.a = fade * 0.9
	if selftest and not shot:
		selftest_frames += 1
		if selftest_frames == 30:
			_run_selftest()
		return
	if shot:
		shot_frames += 1
		if shot_frames > 45 and not shot_done:
			shot_done = true
			_capture()
		return
	_keyboard_look(delta)
	if smoke:
		smoke_frames += 1
		if smoke_frames == 120:
			print("Smoke-Test: 120 Frames, keine Fehler")
			get_tree().quit()


func _keyboard_look(delta: float) -> void:
	var turn := 0.0
	if Input.is_physical_key_pressed(KEY_LEFT) or Input.is_physical_key_pressed(KEY_Q):
		turn += 1.0
	if Input.is_physical_key_pressed(KEY_RIGHT) or Input.is_physical_key_pressed(KEY_E):
		turn -= 1.0
	var tilt := 0.0
	if Input.is_physical_key_pressed(KEY_UP):
		tilt += 1.0
	if Input.is_physical_key_pressed(KEY_DOWN):
		tilt -= 1.0
	if turn != 0.0 or tilt != 0.0:
		yaw += turn * 78.0 * delta
		pitch = clampf(pitch + tilt * 60.0 * delta, -72.0, 66.0)
		_pose_camera()


func _animate_bots() -> void:
	for i in bots.size():
		var b := bots[i]
		var head := b.get_node_or_null("Head")
		if head != null:
			var ph := clock * 0.55 + float(i) * 2.1
			head.rotation_degrees.y = sin(ph) * 5.5
			head.rotation_degrees.x = sin(ph * 0.73 + 1.0) * 2.5
		var torso := b.get_node_or_null("Torso")
		if torso != null:
			torso.scale = Vector3(1.0, 1.0 + sin(clock * 1.35 + float(i)) * 0.009, 1.0)


func _unhandled_input(event: InputEvent) -> void:
	if shot:
		return

	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if dragging:
			dragging = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			get_tree().quit()
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed and not dragging:
				dragging = true
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			elif not event.pressed and dragging:
				dragging = false
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			hand.play_hovered()
	elif event is InputEventMouseMotion and dragging:
		yaw -= event.relative.x * LOOK_SENS
		pitch = clampf(pitch - event.relative.y * LOOK_SENS, -72.0, 66.0)
		_pose_camera()


func _run_selftest() -> void:
	var ok := 0
	var n: int = hand.cards.size()
	for i in n:
		var c: Node3D = hand.cards[i]
		var sp: Vector2 = camera.unproject_position(c.global_position)
		var idx: int = hand.pick_at(sp)
		print("Karte %d @ %s -> getroffen: %d" % [i, sp, idx])
		if idx == i:
			ok += 1
	print("Hover-Test: %d von %d Karten korrekt getroffen" % [ok, n])
	get_tree().quit()


func _capture() -> void:
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	var abs_path := ProjectSettings.globalize_path(shot_path)
	DirAccess.make_dir_recursive_absolute(abs_path.get_base_dir())
	img.save_png(abs_path)
	print("Screenshot: ", abs_path)
	get_tree().quit()
