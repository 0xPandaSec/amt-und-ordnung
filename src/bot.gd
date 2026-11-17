extends RefCounted
## Graukasten-Gegner: sitzende Figur aus Primitiven, Blick zur Tischmitte.

const Kit := preload("res://src/scene_kit.gd")


static func build(parent: Node3D, pos: Vector3, yaw_deg: float, look: Dictionary,
		back: Material) -> Node3D:
	var root := Node3D.new()
	root.name = "Bot"
	parent.add_child(root)
	root.position = pos
	root.rotation_degrees.y = yaw_deg

	var shirt: Color = look.get("shirt", Color("6a5a46"))
	var skin: Color = look.get("skin", Color("d3a883"))
	var hair_col: Color = look.get("hair", Color("3a2a20"))
	var shirt_m := Kit.mat(shirt, 0.92)
	var skin_m := Kit.mat(skin, 0.72)
	var hair_m := Kit.mat(hair_col, 0.88)
	var trouser_m := Kit.mat(Color("2b2d31"), 0.95)
	var shoe_m := Kit.mat(Color("1b1a18"), 0.7)
	var collar_m := Kit.mat(Color("e8e2d0"), 0.9)

	# Beine, sitzend
	for s in [-1.0, 1.0]:
		Kit.limb(root, Vector3(0.115 * s, 0.50, 0.06), Vector3(0.135 * s, 0.46, -0.28), 0.135, trouser_m)
		Kit.limb(root, Vector3(0.135 * s, 0.46, -0.30), Vector3(0.135 * s, 0.05, -0.33), 0.115, trouser_m)
		Kit.box(root, Vector3(0.10, 0.06, 0.21), Vector3(0.135 * s, 0.03, -0.38), shoe_m)

	# Becken und Oberkörper
	Kit.box(root, Vector3(0.31, 0.19, 0.27), Vector3(0, 0.53, 0.04), trouser_m)
	var torso := Kit.box(root, Vector3(0.36, 0.44, 0.25), Vector3(0, 0.78, 0.02),
			shirt_m, Vector3(-6, 0, 0))
	torso.name = "Torso"
	Kit.box(root, Vector3(0.40, 0.13, 0.25), Vector3(0, 0.965, 0.0), shirt_m, Vector3(-5, 0, 0))
	Kit.box(root, Vector3(0.135, 0.10, 0.04), Vector3(0, 0.945, -0.114), collar_m, Vector3(-7, 0, 0))
	Kit.box(root, Vector3(0.055, 0.19, 0.022), Vector3(0, 0.855, -0.134),
			Kit.mat(look.get("tie", Color("8f2f2b")), 0.6), Vector3(-6, 0, 0))
	Kit.cyl(root, 0.052, 0.10, Vector3(0, 1.03, -0.01), skin_m, Vector3.ZERO, -1.0, 12)

	# Arme, auf dem Tisch abgelegt
	for s in [-1.0, 1.0]:
		Kit.limb(root, Vector3(0.172 * s, 0.952, 0.0), Vector3(0.255 * s, 0.815, -0.17),
				0.092, shirt_m)
		Kit.limb(root, Vector3(0.255 * s, 0.815, -0.17), Vector3(0.222 * s, 0.795, -0.30),
				0.080, shirt_m)
		Kit.sphere(root, 0.042, Vector3(0.222 * s, 0.792, -0.335), skin_m, Vector3(1.0, 0.85, 1.15))

	# Kopf als eigener Drehpunkt (für die Idle-Animation)
	var head := Node3D.new()
	head.name = "Head"
	root.add_child(head)
	head.position = Vector3(0, 1.02, -0.005)

	Kit.sphere(head, 0.105, Vector3(0, 0.112, -0.005), skin_m, Vector3(1.0, 1.1, 1.05))
	Kit.sphere(head, 0.028, Vector3(0, 0.098, -0.108), skin_m, Vector3(1.0, 0.9, 1.25))
	for s in [-1.0, 1.0]:
		Kit.sphere(head, 0.026, Vector3(0.101 * s, 0.118, 0.008), skin_m, Vector3(0.7, 1.0, 1.0))
		Kit.sphere(head, 0.0135, Vector3(0.037 * s, 0.132, -0.098), Kit.mat(Color("241d18"), 0.4))
		Kit.box(head, Vector3(0.046, 0.011, 0.014), Vector3(0.038 * s, 0.160, -0.098),
				hair_m, Vector3(0, 0, 7.0 * s))
	Kit.sphere(head, 0.107, Vector3(0, 0.146, 0.012), hair_m, Vector3(1.0, 0.62, 1.02))

	if look.get("glasses", false):
		var frame := Kit.mat(Color("2a2622"), 0.35, 0.5)
		for s in [-1.0, 1.0]:
			Kit.torus(head, 0.027, 0.034, Vector3(0.037 * s, 0.132, -0.112), frame,
					Vector3(90, 0, 0))
		Kit.box(head, Vector3(0.024, 0.008, 0.008), Vector3(0, 0.132, -0.112), frame)

	if look.get("beard", false):
		Kit.box(head, Vector3(0.078, 0.020, 0.030), Vector3(0, 0.062, -0.096), hair_m,
				Vector3(0, 0, 3))
		Kit.box(head, Vector3(0.030, 0.026, 0.020), Vector3(0, 0.040, -0.090), hair_m)

	if look.get("hat", false):
		var hat_m := Kit.mat(look.get("hat_color", Color("2c2620")), 0.78)
		Kit.cyl(head, 0.166, 0.016, Vector3(0, 0.196, 0.012), hat_m, Vector3.ZERO, -1.0, 28)
		Kit.cyl(head, 0.098, 0.105, Vector3(0, 0.256, 0.012), hat_m, Vector3.ZERO, 0.093, 28)

	# Kartenfächer: Rückseite zum Spieler
	for i in 5:
		var t := float(i) - 2.0
		Kit.quad(root, Vector2(Kit.CARD_W, Kit.CARD_H),
				Vector3(t * 0.031, 0.862, -0.302 - absf(t) * 0.004),
				back, Vector3(-26, 180, t * 7.0))

	return root
