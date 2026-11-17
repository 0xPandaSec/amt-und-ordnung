extends Node3D
## Kartenfächer in der Hand. Karten heben sich, wenn der Zeiger darauf steht.

const Kit := preload("res://src/scene_kit.gd")

const SPREAD := 0.050
const HOVER_LIFT := 0.030
const HOVER_RAISE := 0.024

var cards: Array[MeshInstance3D] = []
var base_pos: Array[Vector3] = []
var base_rot: Array[Vector3] = []
var ids: Array[String] = []

var hover := -1
var forced := -1
var group_y := 0.0


func build(card_ids: Array) -> void:
	ids.clear()
	for id in card_ids:
		ids.append(str(id))

	var n := ids.size()
	for i in n:
		var t := float(i) - (float(n) - 1.0) * 0.5
		var mi := MeshInstance3D.new()
		var mesh := QuadMesh.new()
		mesh.size = Vector2(Kit.CARD_W, Kit.CARD_H)
		mi.mesh = mesh
		mi.material_override = Kit.card_mat(load("res://assets/faces/%s.png" % ids[i]))
		mi.name = "Card%d" % i
		add_child(mi)

		var p := Vector3(t * SPREAD, -absf(t) * 0.006, -absf(t) * 0.009)
		var r := Vector3(-11.0, 0.0, -t * 7.5)
		mi.position = p
		mi.rotation_degrees = r
		base_pos.append(p)
		base_rot.append(r)

		# Kartenkante, damit die Karte im Raum steht und nicht wie Papier auf dem Tisch wirkt
		var edge := MeshInstance3D.new()
		var edge_mesh := BoxMesh.new()
		edge_mesh.size = Vector3(Kit.CARD_W, Kit.CARD_H, 0.002)
		edge.mesh = edge_mesh
		edge.material_override = Kit.mat(Color("efe9d8"), 0.9)
		edge.position = Vector3(0, 0, -0.0012)
		mi.add_child(edge)

		var area := Area3D.new()
		area.collision_layer = 2
		area.collision_mask = 0
		area.monitoring = false
		area.set_meta("card", i)
		var shape := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = Vector3(Kit.CARD_W * 0.92, Kit.CARD_H * 0.92, 0.02)
		shape.shape = box
		area.add_child(shape)
		mi.add_child(area)

		cards.append(mi)


func _process(delta: float) -> void:
	var target := forced
	if target < 0 and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		target = _pick()
	hover = target

	var rise := 1.0 if hover >= 0 else 0.0
	group_y = lerpf(group_y, rise, 1.0 - exp(-9.0 * delta))
	var easing := 1.0 - exp(-15.0 * delta)

	for i in cards.size():
		var c := cards[i]
		var up := 0.0
		var lift := 0.0
		var tilt := 0.0
		var grow := 1.0
		if i == hover:
			up = HOVER_RAISE
			lift = HOVER_LIFT
			tilt = -5.0
			grow = 1.05

		var goal := base_pos[i] + Vector3(0, up + group_y * 0.016 - 0.010, lift)
		c.position = c.position.lerp(goal, easing)
		c.rotation_degrees = c.rotation_degrees.lerp(base_rot[i] + Vector3(tilt, 0, 0), easing)
		c.scale = c.scale.lerp(Vector3.ONE * grow, easing)


func _pick() -> int:
	return pick_at(get_viewport().get_mouse_position())


## Trifft die Karte unter einer Bildschirmposition (Viewport-Pixel).
func pick_at(screen_pos: Vector2) -> int:
	var cam := get_viewport().get_camera_3d()
	if cam == null:
		return -1
	var from := cam.project_ray_origin(screen_pos)
	var to := from + cam.project_ray_normal(screen_pos) * 2.0
	var q := PhysicsRayQueryParameters3D.create(from, to, 2)
	q.collide_with_areas = true
	q.collide_with_bodies = false
	var hit := get_world_3d().direct_space_state.intersect_ray(q)
	if hit.is_empty():
		return -1
	var col = hit.get("collider")
	if col != null and col.has_meta("card"):
		return int(col.get_meta("card"))
	return -1


func play_hovered() -> void:
	if hover >= 0 and hover < ids.size():
		print("Karte gespielt: ", ids[hover])
