extends RefCounted
## Baut den Kellerraum: Hülle, Lampe, Möbel, Tisch, Kartenstapel, Staub.

const Kit := preload("res://src/scene_kit.gd")

const W := 5.4
const H := 2.7
const D := 6.2

const TABLE_H := 0.77
const TABLE_R := 0.74

## Sitzplätze der Gegner (Weltkoordinaten, Tischmitte = Ursprung).
const SEATS: Array[Vector3] = [
	Vector3(0.0, 0.0, -1.12),
	Vector3(-1.00, 0.0, -0.68),
	Vector3(1.00, 0.0, -0.68),
]
const PLAYER_SEAT := Vector3(0.0, 0.0, 1.60)


static func seat_yaw(pos: Vector3) -> float:
	# Stuhl schaut nach -Z; wir wollen, dass -Z zur Tischmitte zeigt.
	return rad_to_deg(atan2(pos.x, pos.z))


static func build(parent: Node3D, back_tex: Texture2D, discard_faces: Array) -> void:
	var wood := Kit.mat(Color("5a3d22"), 0.72)
	var wood_dark := Kit.mat(Color("3f2b18"), 0.78)
	_shell(parent)
	_lamp(parent)
	_furniture(parent)
	_table(parent, wood, wood_dark)
	_chairs(parent, wood, wood_dark)
	_piles(parent, Kit.card_mat(back_tex), discard_faces)
	_dust(parent)


# ---------------------------------------------------------------------- Hülle
static func _shell(parent: Node3D) -> void:
	var floor_m := Kit.mat(Color("3b3731"), 0.96)
	var wall_m := Kit.mat(Color("6b6254"), 0.95)
	var wall_low := Kit.mat(Color("4b443a"), 0.9)
	var ceil_m := Kit.mat(Color("242220"), 1.0)

	Kit.box(parent, Vector3(W, 0.3, D), Vector3(0, -0.15, 0), floor_m)
	Kit.box(parent, Vector3(W, 0.2, D), Vector3(0, H + 0.1, 0), ceil_m)
	Kit.box(parent, Vector3(W, H, 0.2), Vector3(0, H * 0.5, -D * 0.5), wall_m)
	Kit.box(parent, Vector3(W, H, 0.2), Vector3(0, H * 0.5, D * 0.5), wall_m)
	Kit.box(parent, Vector3(0.2, H, D), Vector3(-W * 0.5, H * 0.5, 0), wall_m)
	Kit.box(parent, Vector3(0.2, H, D), Vector3(W * 0.5, H * 0.5, 0), wall_m)

	# Sockelleisten
	var ix := W * 0.5 - 0.09
	var iz := D * 0.5 - 0.09
	Kit.box(parent, Vector3(W - 0.3, 0.11, 0.035), Vector3(0, 0.055, -iz - 0.015), wall_low)
	Kit.box(parent, Vector3(W - 0.3, 0.11, 0.035), Vector3(0, 0.055, iz + 0.015), wall_low)
	Kit.box(parent, Vector3(0.035, 0.11, D - 0.3), Vector3(-ix - 0.015, 0.055, 0), wall_low)
	Kit.box(parent, Vector3(0.035, 0.11, D - 0.3), Vector3(ix + 0.015, 0.055, 0), wall_low)

	# Teppich
	Kit.box(parent, Vector3(2.95, 0.012, 2.65), Vector3(0, 0.006, 0.05),
			Kit.mat(Color("452724"), 0.98))
	Kit.box(parent, Vector3(2.55, 0.014, 2.25), Vector3(0, 0.007, 0.05),
			Kit.mat(Color("57312c"), 0.98))

	# Deckenbalken
	Kit.box(parent, Vector3(W - 0.4, 0.17, 0.21), Vector3(0, H - 0.085, -1.75), wall_low)
	Kit.box(parent, Vector3(W - 0.4, 0.17, 0.21), Vector3(0, H - 0.085, 1.45), wall_low)

	# Rohre an der linken Wand
	var copper := Kit.mat(Color("6f5340"), 0.45, 0.55)
	Kit.cyl(parent, 0.052, D - 0.3, Vector3(-2.35, 2.36, 0), copper, Vector3(90, 0, 0), -1.0, 16)
	Kit.cyl(parent, 0.034, D - 0.3, Vector3(-2.19, 2.49, 0), copper, Vector3(90, 0, 0), -1.0, 16)
	Kit.box(parent, Vector3(0.24, 0.06, 0.09), Vector3(-2.27, 2.42, -1.9), copper)
	Kit.torus(parent, 0.062, 0.085, Vector3(-2.27, 2.42, 0.4), copper, Vector3(90, 0, 0))


# ---------------------------------------------------------------------- Lampe
static func _lamp(parent: Node3D) -> void:
	var lamp := Node3D.new()
	lamp.position = Vector3(0, 0, -0.15)
	parent.add_child(lamp)

	var cord := Kit.mat(Color("17150f"), 0.9)
	var shade := Kit.mat(Color("2b3a33"), 0.35, 0.25)
	var brass := Kit.mat(Color("8a6a3a"), 0.4, 0.7)

	Kit.cyl(lamp, 0.008, 0.92, Vector3(0, 2.25, 0), cord, Vector3.ZERO, -1.0, 8)
	Kit.cyl(lamp, 0.052, 0.07, Vector3(0, 2.0, 0), brass, Vector3.ZERO, -1.0, 16)
	Kit.cyl(lamp, 0.30, 0.22, Vector3(0, 1.86, 0), shade, Vector3.ZERO, 0.05, 32)
	Kit.torus(lamp, 0.288, 0.302, Vector3(0, 1.752, 0), shade)

	var bulb_m := StandardMaterial3D.new()
	bulb_m.albedo_color = Color("fff3da")
	bulb_m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	bulb_m.emission_enabled = true
	bulb_m.emission = Color("ffd49a")
	bulb_m.emission_energy_multiplier = 7.0
	Kit.sphere(lamp, 0.052, Vector3(0, 1.715, 0), bulb_m)

	Kit.omni(lamp, Vector3(0, 1.69, 0), Color(1.0, 0.88, 0.7), 2.0, 7.5, true)

	# Zweite, schwache Funzel an der rechten Wand
	var bulb2 := Kit.sphere(parent, 0.038, Vector3(2.42, 2.03, 1.55), bulb_m)
	bulb2.scale = Vector3.ONE
	Kit.cyl(parent, 0.006, 0.55, Vector3(2.42, 2.32, 1.55), cord, Vector3.ZERO, -1.0, 6)
	Kit.omni(parent, Vector3(2.42, 2.0, 1.55), Color(1.0, 0.83, 0.6), 1.1, 4.2, false)

	# Kühles Gegenlicht, damit die Figuren sich vom Hintergrund lösen
	Kit.omni(parent, Vector3(0, 2.15, -2.55), Color(0.52, 0.62, 0.9), 1.9, 5.5, false)


# ------------------------------------------------------------------- Möbel
static func _furniture(parent: Node3D) -> void:
	var metal := Kit.mat(Color("39463f"), 0.5, 0.35)
	var metal_dark := Kit.mat(Color("2a332e"), 0.55, 0.3)
	var cardboard := Kit.mat(Color("8e6a41"), 0.95)
	var cardboard2 := Kit.mat(Color("a07c4d"), 0.95)
	var paper := Kit.mat(Color("ded5bf"), 0.9)
	var wood := Kit.mat(Color("5b3f27"), 0.7)

	# Tür an der Stirnwand
	Kit.box(parent, Vector3(1.04, 2.08, 0.06), Vector3(-1.55, 1.04, -2.97), wood)
	Kit.box(parent, Vector3(1.18, 0.09, 0.10), Vector3(-1.55, 2.12, -2.96), Kit.mat(Color("3a2a1a"), 0.8))
	Kit.box(parent, Vector3(0.09, 2.12, 0.10), Vector3(-2.10, 1.06, -2.96), Kit.mat(Color("3a2a1a"), 0.8))
	Kit.box(parent, Vector3(0.09, 2.12, 0.10), Vector3(-1.00, 1.06, -2.96), Kit.mat(Color("3a2a1a"), 0.8))
	Kit.sphere(parent, 0.035, Vector3(-1.12, 1.02, -2.92), Kit.mat(Color("8a6a3a"), 0.35, 0.75))

	# Aktenschrank
	Kit.box(parent, Vector3(0.95, 1.42, 0.55), Vector3(1.52, 0.71, -2.67), metal)
	for i in 3:
		var y := 0.26 + float(i) * 0.44
		Kit.box(parent, Vector3(0.86, 0.40, 0.035), Vector3(1.52, y, -2.385), metal_dark)
		Kit.box(parent, Vector3(0.26, 0.032, 0.04), Vector3(1.52, y + 0.10, -2.365),
				Kit.mat(Color("b9b3a2"), 0.4, 0.5))
		Kit.box(parent, Vector3(0.12, 0.045, 0.012), Vector3(1.52, y + 0.02, -2.362), paper)

	# Kartons oben drauf
	Kit.box(parent, Vector3(0.52, 0.36, 0.44), Vector3(1.46, 1.60, -2.66), cardboard, Vector3(0, 9, 0))
	Kit.box(parent, Vector3(0.40, 0.30, 0.34), Vector3(1.54, 1.93, -2.68), cardboard2, Vector3(0, -14, 0))
	Kit.box(parent, Vector3(0.20, 0.02, 0.24), Vector3(1.46, 1.787, -2.66), paper, Vector3(0, 9, 0))

	# Kistenstapel links hinten
	Kit.box(parent, Vector3(0.55, 0.40, 0.48), Vector3(-2.05, 0.20, -2.55), cardboard, Vector3(0, -8, 0))
	Kit.box(parent, Vector3(0.46, 0.34, 0.40), Vector3(-2.10, 0.57, -2.52), cardboard2, Vector3(0, 12, 0))

	# Regal an der linken Wand
	for shelf_y in [1.30, 1.74]:
		Kit.box(parent, Vector3(0.32, 0.035, 1.05), Vector3(-2.44, shelf_y, -0.35), wood)
		for bz in [-0.80, 0.10]:
			Kit.box(parent, Vector3(0.022, 0.20, 0.045), Vector3(-2.585, shelf_y - 0.115, bz),
					Kit.mat(Color("33302a"), 0.7))
			Kit.box(parent, Vector3(0.30, 0.024, 0.045), Vector3(-2.44, shelf_y - 0.026, bz),
					Kit.mat(Color("33302a"), 0.7))

	Kit.box(parent, Vector3(0.24, 0.10, 0.30), Vector3(-2.44, 1.37, -0.62), paper, Vector3(0, 6, 0))
	Kit.box(parent, Vector3(0.22, 0.07, 0.26), Vector3(-2.45, 1.355, -0.58), paper, Vector3(0, -4, 0))
	Kit.cyl(parent, 0.05, 0.13, Vector3(-2.44, 1.385, 0.05), Kit.mat(Color("5d6f7a"), 0.25))
	Kit.cyl(parent, 0.042, 0.035, Vector3(-2.44, 1.468, 0.05), Kit.mat(Color("2f3a40"), 0.3))
	Kit.box(parent, Vector3(0.02, 0.26, 0.32), Vector3(-2.52, 1.87, -0.45),
			Kit.mat(Color("7a4436"), 0.8), Vector3(0, 0, 4))

	# Heizkörper
	Kit.box(parent, Vector3(0.11, 0.56, 1.30), Vector3(-2.52, 0.62, 1.15), metal_dark)
	for i in 10:
		var z := 0.55 + float(i) * 0.135
		Kit.box(parent, Vector3(0.14, 0.50, 0.055), Vector3(-2.52, 0.62, z), metal)

	# Schwarzes Brett an der rechten Wand
	Kit.box(parent, Vector3(0.05, 0.68, 0.88), Vector3(2.56, 1.46, -0.45),
			Kit.mat(Color("4a3a26"), 0.8))
	var pin := Vector3(2.53, 0, 0)
	var sheets := [
		{"p": Vector3(pin.x, 1.58, -0.68), "rot": 4.0},
		{"p": Vector3(pin.x, 1.44, -0.40), "rot": -7.0},
		{"p": Vector3(pin.x, 1.62, -0.26), "rot": 11.0},
	]
	for s in sheets:
		Kit.quad(parent, Vector2(0.20, 0.28), s["p"], paper,
				Vector3(0, -90, s["rot"]))
		Kit.quad(parent, Vector2(0.13, 0.022), Vector3(pin.x - 0.002, s["p"].y + 0.10, s["p"].z),
				Kit.mat(Color("9c3128"), 0.7), Vector3(0, -90, s["rot"]))

	# Wanduhr an der Stirnwand
	var brass := Kit.mat(Color("8a6a3a"), 0.4, 0.7)
	var clock_face := Kit.mat(Color("e6dfcb"), 0.85)
	var clock_ink := Kit.mat(Color("232019"), 0.6)
	Kit.torus(parent, 0.150, 0.174, Vector3(0, 2.02, -2.972), brass, Vector3(90, 0, 0))
	Kit.cyl(parent, 0.150, 0.018, Vector3(0, 2.02, -2.982), clock_face,
			Vector3(90, 0, 0), -1.0, 40)
	for i in 12:
		var a := TAU * float(i) / 12.0
		Kit.box(parent, Vector3(0.007, 0.014, 0.004),
				Vector3(sin(a) * 0.128, 2.02 + cos(a) * 0.128, -2.968), clock_ink,
				Vector3(0, 0, -rad_to_deg(a)))
	var hour_hand := Node3D.new()
	hour_hand.position = Vector3(0, 2.02, -2.966)
	hour_hand.rotation_degrees.z = -52.0
	parent.add_child(hour_hand)
	Kit.box(hour_hand, Vector3(0.011, 0.082, 0.004), Vector3(0, 0.034, 0), clock_ink)
	var minute_hand := Node3D.new()
	minute_hand.position = Vector3(0, 2.02, -2.962)
	minute_hand.rotation_degrees.z = 58.0
	parent.add_child(minute_hand)
	Kit.box(minute_hand, Vector3(0.008, 0.115, 0.004), Vector3(0, 0.052, 0), clock_ink)

	# Kalender neben der Uhr
	Kit.quad(parent, Vector2(0.30, 0.42), Vector3(0.82, 1.84, -2.968), paper, Vector3.ZERO)
	Kit.quad(parent, Vector2(0.30, 0.075), Vector3(0.82, 2.01, -2.966),
			Kit.mat(Color("9c3128"), 0.8), Vector3.ZERO)
	for row in 3:
		for col in 4:
			Kit.box(parent, Vector3(0.048, 0.048, 0.004),
					Vector3(0.72 + float(col) * 0.066, 1.90 - float(row) * 0.068, -2.965),
					Kit.mat(Color("cdc5ad"), 0.9))


# --------------------------------------------------------------------- Tisch
static func _table(parent: Node3D, wood: Material, dark: Material) -> void:
	var top_m := Kit.mat(Color("2b1d14"), 0.95)
	Kit.cyl(parent, TABLE_R, 0.05, Vector3(0, TABLE_H - 0.025, 0), top_m,
			Vector3.ZERO, -1.0, 48)
	Kit.torus(parent, TABLE_R - 0.02, TABLE_R + 0.022, Vector3(0, TABLE_H - 0.03, 0), dark)
	Kit.cyl(parent, 0.095, 0.70, Vector3(0, 0.36, 0), dark, Vector3.ZERO, -1.0, 20)
	Kit.box(parent, Vector3(0.86, 0.07, 0.15), Vector3(0, 0.035, 0), dark)
	Kit.box(parent, Vector3(0.15, 0.07, 0.86), Vector3(0, 0.035, 0), dark)
	Kit.cyl(parent, 0.20, 0.05, Vector3(0, 0.055, 0), dark, Vector3.ZERO, -1.0, 24)

	# Kaffeetasse
	var mug := Kit.mat(Color("d9d1bd"), 0.35)
	Kit.cyl(parent, 0.043, 0.10, Vector3(0.40, TABLE_H + 0.05, 0.36), mug, Vector3.ZERO, -1.0, 20)
	Kit.cyl(parent, 0.036, 0.008, Vector3(0.40, TABLE_H + 0.096, 0.36),
			Kit.mat(Color("2a1a12"), 0.25), Vector3.ZERO, -1.0, 20)
	Kit.torus(parent, 0.020, 0.031, Vector3(0.445, TABLE_H + 0.055, 0.36), mug, Vector3(0, 0, 90))

	# Stift und loses Papier
	Kit.cyl(parent, 0.0045, 0.16, Vector3(-0.22, TABLE_H + 0.005, 0.40),
			Kit.mat(Color("c9a227"), 0.5), Vector3(0, 16, 90), -1.0, 8)
	Kit.box(parent, Vector3(0.21, 0.0016, 0.297), Vector3(0.06, TABLE_H + 0.002, 0.20),
			Kit.mat(Color("e2dac6"), 0.92), Vector3(0, -13, 0))
	Kit.box(parent, Vector3(0.21, 0.0016, 0.297), Vector3(0.02, TABLE_H + 0.004, 0.24),
			Kit.mat(Color("d6cdb7"), 0.92), Vector3(0, 8, 0))


# --------------------------------------------------------------- Kartenstapel
static func _piles(parent: Node3D, back: Material, discard_faces: Array) -> void:
	Kit.card_stack(parent, Vector3(-0.60, TABLE_H + 0.001, -0.10), 26, back, 7.0)
	Kit.card_stack(parent, Vector3(-0.585, TABLE_H + 0.046, -0.095), 1, back, -3.0)

	var edge := Kit.mat(Color("ded7c6"), 0.9)
	var drops := [
		{"p": Vector3(0.575, TABLE_H + 0.001, -0.04), "yaw": 26.0, "face": 0},
		{"p": Vector3(0.615, TABLE_H + 0.0026, -0.10), "yaw": -12.0, "face": 1},
		{"p": Vector3(0.590, TABLE_H + 0.0042, -0.075), "yaw": 5.0, "face": 2},
	]
	for d in drops:
		var face: Texture2D = discard_faces[int(d["face"]) % discard_faces.size()]
		Kit.card_flat(parent, d["p"], d["yaw"], Kit.card_mat(face), edge)


# ---------------------------------------------------------------------- Staub
static func _dust(parent: Node3D) -> void:
	var p := GPUParticles3D.new()
	p.amount = 150
	p.lifetime = 16.0
	p.preprocess = 10.0
	p.local_coords = false
	p.position = Vector3(0, 1.45, -0.2)
	p.visibility_aabb = AABB(Vector3(-3.4, -2.0, -3.6), Vector3(6.8, 4.0, 7.2))

	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	pm.emission_box_extents = Vector3(2.3, 1.05, 2.6)
	pm.direction = Vector3(0, 1, 0)
	pm.spread = 90.0
	pm.initial_velocity_min = 0.006
	pm.initial_velocity_max = 0.045
	pm.gravity = Vector3(0, -0.004, 0)
	pm.scale_min = 0.4
	pm.scale_max = 1.4
	pm.color = Color(1.0, 0.93, 0.78, 0.5)
	p.process_material = pm

	var quad := QuadMesh.new()
	quad.size = Vector2(0.007, 0.007)
	var m := StandardMaterial3D.new()
	m.albedo_color = Color(1, 1, 1, 1)
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	m.vertex_color_use_as_albedo = true
	m.disable_receive_shadows = true
	quad.material = m
	p.draw_pass_1 = quad
	parent.add_child(p)


# -------------------------------------------------------------------- Stühle
static func _chairs(parent: Node3D, wood: Material, dark: Material) -> void:
	Kit.chair(parent, PLAYER_SEAT, 0.0, wood, dark)
	for seat in SEATS:
		Kit.chair(parent, seat, seat_yaw(seat), wood, dark)
