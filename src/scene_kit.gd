extends RefCounted
## Baukasten für den Graukasten: Primitive, Materialien, Lampen, Stühle.
## Wird per preload eingebunden (kein class_name, damit das Projekt ohne
## vorherigen Editor-Scan startet).

const CARD_W := 0.086
const CARD_H := 0.120


# ---------------------------------------------------------------- Materialien
static func mat(color: Color, roughness: float = 0.85, metallic: float = 0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = roughness
	m.metallic = metallic
	return m


static func card_mat(tex: Texture2D, glow: float = 0.07,
		tint: Color = Color(1, 1, 1)) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_texture = tex
	m.albedo_color = tint
	m.roughness = 0.58
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	# Karten sollen auch im Halbschatten lesbar bleiben.
	m.emission_enabled = glow > 0.001
	m.emission = Color(1.0, 1.0, 1.0)
	m.emission_texture = tex
	m.emission_energy_multiplier = glow
	return m


# -------------------------------------------------------------------- Meshes
static func box(parent: Node3D, size: Vector3, pos: Vector3, material: Material,
		rot: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mi.mesh = mesh
	mi.material_override = material
	parent.add_child(mi)
	mi.position = pos
	mi.rotation_degrees = rot
	return mi


static func quad(parent: Node3D, size: Vector2, pos: Vector3, material: Material,
		rot: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var mesh := QuadMesh.new()
	mesh.size = size
	mi.mesh = mesh
	mi.material_override = material
	parent.add_child(mi)
	mi.position = pos
	mi.rotation_degrees = rot
	return mi


static func cyl(parent: Node3D, radius: float, height: float, pos: Vector3, material: Material,
		rot: Vector3 = Vector3.ZERO, top_radius: float = -1.0, segments: int = 24) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.bottom_radius = radius
	mesh.top_radius = radius if top_radius < 0.0 else top_radius
	mesh.height = height
	mesh.radial_segments = segments
	mesh.rings = 1
	mi.mesh = mesh
	mi.material_override = material
	parent.add_child(mi)
	mi.position = pos
	mi.rotation_degrees = rot
	return mi


static func sphere(parent: Node3D, radius: float, pos: Vector3, material: Material,
		scale_v: Vector3 = Vector3.ONE) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh.radial_segments = 20
	mesh.rings = 10
	mi.mesh = mesh
	mi.material_override = material
	parent.add_child(mi)
	mi.position = pos
	mi.scale = scale_v
	return mi


static func torus(parent: Node3D, inner: float, outer: float, pos: Vector3, material: Material,
		rot: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var mesh := TorusMesh.new()
	mesh.inner_radius = inner
	mesh.outer_radius = outer
	mesh.rings = 28
	mesh.ring_segments = 12
	mi.mesh = mesh
	mi.material_override = material
	parent.add_child(mi)
	mi.position = pos
	mi.rotation_degrees = rot
	return mi


## Balken/Körperteil zwischen zwei Punkten (für Arme und Beine).
static func limb(parent: Node3D, a: Vector3, b: Vector3, thickness: float, material: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(thickness, thickness, a.distance_to(b))
	mi.mesh = mesh
	mi.material_override = material
	parent.add_child(mi)
	mi.position = (a + b) * 0.5
	mi.basis = Basis.looking_at((b - a).normalized(), Vector3.UP)
	return mi


# --------------------------------------------------------------------- Licht
static func omni(parent: Node3D, pos: Vector3, color: Color, energy: float, range_m: float,
		shadows: bool = false) -> OmniLight3D:
	var l := OmniLight3D.new()
	l.position = pos
	l.light_color = color
	l.light_energy = energy
	l.omni_range = range_m
	l.omni_attenuation = 1.4
	l.shadow_enabled = shadows
	l.light_size = 0.08
	parent.add_child(l)
	return l


# ------------------------------------------------------------------- Möbel
## Stuhl, standardmäßig mit Blick nach -Z (Lehne bei +Z).
static func chair(parent: Node3D, pos: Vector3, yaw_deg: float, wood: Material, dark: Material) -> Node3D:
	var root := Node3D.new()
	parent.add_child(root)
	root.position = pos
	root.rotation_degrees.y = yaw_deg

	box(root, Vector3(0.44, 0.05, 0.44), Vector3(0, 0.44, 0), wood)
	for sx in [-1.0, 1.0]:
		for sz in [-1.0, 1.0]:
			box(root, Vector3(0.045, 0.44, 0.045), Vector3(0.185 * sx, 0.22, 0.185 * sz), dark)
	box(root, Vector3(0.045, 0.52, 0.045), Vector3(-0.185, 0.71, 0.20), dark)
	box(root, Vector3(0.045, 0.52, 0.045), Vector3(0.185, 0.71, 0.20), dark)
	box(root, Vector3(0.40, 0.15, 0.035), Vector3(0, 0.88, 0.205), wood)
	box(root, Vector3(0.34, 0.07, 0.028), Vector3(0, 0.72, 0.205), wood)
	return root


## Kartenstapel: ein Papierblock plus Deckblatt.
static func card_stack(parent: Node3D, pos: Vector3, count: int, back: Material,
		yaw_deg: float = 0.0) -> void:
	var h := 0.0017 * float(count)
	box(parent, Vector3(CARD_W, h, CARD_H), pos + Vector3(0, h * 0.5, 0),
			mat(Color("ded7c6"), 0.9), Vector3(0, yaw_deg, 0))
	quad(parent, Vector2(CARD_W, CARD_H), pos + Vector3(0, h + 0.0009, 0), back,
			Vector3(-90, yaw_deg, 0))


## Einzelne Karte flach auf dem Tisch.
static func card_flat(parent: Node3D, pos: Vector3, yaw_deg: float, face: Material,
		edge: Material) -> void:
	box(parent, Vector3(CARD_W, 0.0012, CARD_H), pos + Vector3(0, 0.0006, 0),
			edge, Vector3(0, yaw_deg, 0))
	quad(parent, Vector2(CARD_W, CARD_H), pos + Vector3(0, 0.0014, 0), face,
			Vector3(-90, yaw_deg, 0))
