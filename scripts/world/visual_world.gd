extends Node3D

var materials: Dictionary = {}

func _ready() -> void:
    _create_materials()
    _style_existing_world()
    _decorate_buildings()
    _create_roads()
    _create_trees()
    _create_rocks()
    _create_lanterns()
    _decorate_shrine()
    _create_village_square()
    _create_signs()


func _create_materials() -> void:
    materials["ground"] = _mat(Color("#26352b"))
    materials["road"] = _mat(Color("#51483b"))
    materials["wood"] = _mat(Color("#5b3824"))
    materials["roof"] = _mat(Color("#3a2730"))
    materials["stone"] = _mat(Color("#55565b"))
    materials["stone_light"] = _mat(Color("#77777a"))
    materials["grass"] = _mat(Color("#314b35"))
    materials["leaf"] = _mat(Color("#183b2b"))
    materials["leaf2"] = _mat(Color("#28533a"))
    materials["metal"] = _mat(Color("#30343b"))
    materials["glass"] = _mat(Color("#6b8992"))
    materials["gold"] = _mat(Color("#b58b38"))
    materials["red"] = _mat(Color("#7b3030"))
    materials["blue"] = _mat(Color("#304f78"))
    materials["merchant"] = _mat(Color("#70416d"))
    materials["black"] = _mat(Color("#181a20"))
    materials["fire"] = _emissive_mat(Color("#ff8a3d"))
    materials["eye"] = _emissive_mat(Color("#75d9ff"))


func _mat(color: Color) -> StandardMaterial3D:
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = 0.85
    return material


func _emissive_mat(color: Color) -> StandardMaterial3D:
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    material.emission_enabled = true
    material.emission = color
    material.emission_energy_multiplier = 2.5
    return material


func _style_existing_world() -> void:
    var ground = get_node_or_null("Ground/MeshInstance3D")
    if ground:
        ground.material_override = materials["ground"]

    var square = get_node_or_null("VillageSquare/SquareGround/SquareMesh")
    if square:
        square.material_override = materials["stone"]

    var road = get_node_or_null("Roads/Road1/Mesh")
    if road:
        road.material_override = materials["road"]

    _style_building("Shrine", materials["stone"])
    _style_building("Inn", materials["wood"])
    _style_building("MerchantShop", materials["merchant"])
    _style_building("Blacksmith", materials["metal"])
    _style_building("Farm", materials["grass"])
    _style_building("ForestEdge", materials["wood"])


func _style_building(building_name: String, material: Material) -> void:
    var mesh = get_node_or_null(building_name + "/Base/Mesh")
    if mesh:
        mesh.material_override = material


func _decorate_buildings() -> void:
    _house_details("Inn", Vector3(-10, 0, 0), "INN", materials["wood"], materials["roof"])
    _house_details("MerchantShop", Vector3(0, 0, 10), "MERCHANT", materials["merchant"], materials["roof"])
    _house_details("Blacksmith", Vector3(0, 0, -10), "BLACKSMITH", materials["metal"], materials["roof"])
    _house_details("Farm", Vector3(15, 0, 15), "FARM", materials["grass"], materials["roof"])
    _house_details("ForestEdge", Vector3(-15, 0, -15), "FOREST", materials["wood"], materials["roof"])


func _house_details(name: String, pos: Vector3, title: String, wall_mat: Material, roof_mat: Material) -> void:
    var parent = get_node_or_null(name)
    if not parent:
        return

    var roof = MeshInstance3D.new()
    var roof_mesh = CylinderMesh.new()
    roof_mesh.top_radius = 0.0
    roof_mesh.bottom_radius = 3.0
    roof_mesh.height = 1.8
    roof_mesh.radial_segments = 4
    roof.mesh = roof_mesh
    roof.material_override = roof_mat
    roof.position = Vector3(0, 2.0, 0)
    roof.rotation_degrees.y = 45
    parent.add_child(roof)

    var door = MeshInstance3D.new()
    var door_mesh = BoxMesh.new()
    door_mesh.size = Vector3(0.8, 1.4, 0.12)
    door.mesh = door_mesh
    door.material_override = materials["wood"]
    door.position = Vector3(0, 0.0, 2.06)
    parent.add_child(door)

    for x in [-1.2, 1.2]:
        var window = MeshInstance3D.new()
        var window_mesh = BoxMesh.new()
        window_mesh.size = Vector3(0.7, 0.65, 0.1)
        window.mesh = window_mesh
        window.material_override = materials["glass"]
        window.position = Vector3(x, 0.65, 2.06)
        parent.add_child(window)

    var sign = Label3D.new()
    sign.text = title
    sign.font_size = 32
    sign.modulate = Color("#f2d9a6")
    sign.outline_size = 8
    sign.position = Vector3(0, 2.9, 2.05)
    sign.billboard = BaseMaterial3D.BILLBOARD_ENABLED
    parent.add_child(sign)


func _create_roads() -> void:
    _road(Vector3(0, 0.02, 5), Vector3(10, 0.08, 2))
    _road(Vector3(0, 0.02, -5), Vector3(10, 0.08, 2))
    _road(Vector3(5, 0.02, 0), Vector3(2, 0.08, 10))
    _road(Vector3(-5, 0.02, 0), Vector3(2, 0.08, 10))
    _road(Vector3(7.5, 0.02, 7.5), Vector3(2, 0.08, 11))
    _road(Vector3(-7.5, 0.02, -7.5), Vector3(2, 0.08, 11))


func _road(pos: Vector3, size: Vector3) -> void:
    var road = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = size
    road.mesh = mesh
    road.material_override = materials["road"]
    road.position = pos
    add_child(road)


func _create_trees() -> void:
    var positions = [
        Vector3(22, 0, 4),
        Vector3(23, 0, 10),
        Vector3(22, 0, 20),
        Vector3(8, 0, 23),
        Vector3(-5, 0, 23),
        Vector3(-20, 0, 18),
        Vector3(-23, 0, 5),
        Vector3(-23, 0, -8),
        Vector3(-22, 0, -20),
        Vector3(-5, 0, -22),
        Vector3(8, 0, -22),
        Vector3(22, 0, -15)
    ]

    for pos in positions:
        _tree(pos)


func _tree(pos: Vector3) -> void:
    var trunk = MeshInstance3D.new()
    var trunk_mesh = CylinderMesh.new()
    trunk_mesh.top_radius = 0.18
    trunk_mesh.bottom_radius = 0.28
    trunk_mesh.height = 1.8
    trunk.mesh = trunk_mesh
    trunk.material_override = materials["wood"]
    trunk.position = pos + Vector3(0, 0.9, 0)
    add_child(trunk)

    var crown = MeshInstance3D.new()
    var crown_mesh = CylinderMesh.new()
    crown_mesh.top_radius = 0.05
    crown_mesh.bottom_radius = 1.25
    crown_mesh.height = 2.8
    crown_mesh.radial_segments = 8
    crown.mesh = crown_mesh
    crown.material_override = materials["leaf"]
    crown.position = pos + Vector3(0, 2.8, 0)
    add_child(crown)

    var crown2 = MeshInstance3D.new()
    var crown2_mesh = CylinderMesh.new()
    crown2_mesh.top_radius = 0.05
    crown2_mesh.bottom_radius = 0.9
    crown2_mesh.height = 2.1
    crown2_mesh.radial_segments = 8
    crown2.mesh = crown2_mesh
    crown2.material_override = materials["leaf2"]
    crown2.position = pos + Vector3(0, 4.1, 0)
    add_child(crown2)


func _create_rocks() -> void:
    var positions = [
        Vector3(4, 0.2, 3),
        Vector3(-4, 0.2, 4),
        Vector3(5, 0.2, -3),
        Vector3(-5, 0.2, -4),
        Vector3(13, 0.2, 5),
        Vector3(-13, 0.2, 6),
        Vector3(6, 0.2, 13),
        Vector3(-6, 0.2, -13)
    ]

    for pos in positions:
        var rock = MeshInstance3D.new()
        var mesh = SphereMesh.new()
        mesh.radius = 0.45
        mesh.height = 0.7
        rock.mesh = mesh
        rock.material_override = materials["stone_light"]
        rock.position = pos
        rock.scale = Vector3(1.3, 0.65, 1.0)
        add_child(rock)


func _create_lanterns() -> void:
    var positions = [
        Vector3(3, 0, 3),
        Vector3(-3, 0, 3),
        Vector3(3, 0, -3),
        Vector3(-3, 0, -3),
        Vector3(8, 0, 2),
        Vector3(-8, 0, 2),
        Vector3(2, 0, 8),
        Vector3(-2, 0, -8)
    ]

    for pos in positions:
        _lantern(pos)


func _lantern(pos: Vector3) -> void:
    var pole = MeshInstance3D.new()
    var pole_mesh = CylinderMesh.new()
    pole_mesh.top_radius = 0.06
    pole_mesh.bottom_radius = 0.08
    pole_mesh.height = 1.8
    pole.mesh = pole_mesh
    pole.material_override = materials["metal"]
    pole.position = pos + Vector3(0, 0.9, 0)
    add_child(pole)

    var light = OmniLight3D.new()
    light.light_color = Color("#ffb35c")
    light.light_energy = 1.5
    light.omni_range = 6.0
    light.position = pos + Vector3(0, 1.8, 0)
    add_child(light)

    var glow = MeshInstance3D.new()
    var glow_mesh = SphereMesh.new()
    glow_mesh.radius = 0.16
    glow_mesh.height = 0.32
    glow.mesh = glow_mesh
    glow.material_override = materials["fire"]
    glow.position = pos + Vector3(0, 1.8, 0)
    add_child(glow)


func _decorate_shrine() -> void:
    var shrine = get_node_or_null("Shrine")
    if not shrine:
        return

    var platform = MeshInstance3D.new()
    var platform_mesh = CylinderMesh.new()
    platform_mesh.top_radius = 3.2
    platform_mesh.bottom_radius = 3.2
    platform_mesh.height = 0.35
    platform.mesh = platform_mesh
    platform.material_override = materials["stone_light"]
    platform.position = Vector3(0, 0.2, 0)
    shrine.add_child(platform)

    for x in [-2.2, 2.2]:
        for z in [-1.6, 1.6]:
            var pillar = MeshInstance3D.new()
            var pillar_mesh = CylinderMesh.new()
            pillar_mesh.top_radius = 0.22
            pillar_mesh.bottom_radius = 0.28
            pillar_mesh.height = 2.8
            pillar.mesh = pillar_mesh
            pillar.material_override = materials["stone_light"]
            pillar.position = Vector3(x, 1.55, z)
            shrine.add_child(pillar)

    var eye = MeshInstance3D.new()
    var eye_mesh = SphereMesh.new()
    eye_mesh.radius = 0.55
    eye_mesh.height = 1.1
    eye.mesh = eye_mesh
    eye.material_override = materials["eye"]
    eye.position = Vector3(0, 2.0, 0)
    shrine.add_child(eye)

    var eye_light = OmniLight3D.new()
    eye_light.light_color = Color("#65d9ff")
    eye_light.light_energy = 2.0
    eye_light.omni_range = 7.0
    eye_light.position = Vector3(0, 2.0, 0)
    shrine.add_child(eye_light)

    var shrine_label = Label3D.new()
    shrine_label.text = "THE HOLLOW SHRINE"
    shrine_label.font_size = 36
    shrine_label.modulate = Color("#b8d9e8")
    shrine_label.outline_size = 10
    shrine_label.position = Vector3(0, 4.3, 0)
    shrine_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
    shrine.add_child(shrine_label)


func _create_village_square() -> void:
    var center = MeshInstance3D.new()
    var center_mesh = CylinderMesh.new()
    center_mesh.top_radius = 1.5
    center_mesh.bottom_radius = 1.7
    center_mesh.height = 0.5
    center.mesh = center_mesh
    center.material_override = materials["stone_light"]
    center.position = Vector3(0, 0.25, 0)
    add_child(center)

    var fire = MeshInstance3D.new()
    var fire_mesh = SphereMesh.new()
    fire_mesh.radius = 0.35
    fire_mesh.height = 0.7
    fire.mesh = fire_mesh
    fire.material_override = materials["fire"]
    fire.position = Vector3(0, 0.85, 0)
    add_child(fire)

    var light = OmniLight3D.new()
    light.light_color = Color("#ff9345")
    light.light_energy = 1.8
    light.omni_range = 8.0
    light.position = Vector3(0, 1, 0)
    add_child(light)


func _create_signs() -> void:
    _sign(Vector3(0, 2.8, 6), "VILLAGE SQUARE")
    _sign(Vector3(12, 2.8, 1.5), "SHRINE")
    _sign(Vector3(-12, 2.8, 1.5), "INN")


func _sign(pos: Vector3, text_value: String) -> void:
    var label = Label3D.new()
    label.text = text_value
    label.font_size = 28
    label.modulate = Color("#d9c49a")
    label.outline_size = 7
    label.position = pos
    label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
    add_child(label)

