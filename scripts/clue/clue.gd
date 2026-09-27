extends Area3D

@export var clue_id: int = 0
@export var clue_name: String = "Clue"
@export var clue_description: String = "A physical clue"
@export var location: String = "Unknown"
@export var related_suspect: String = ""

var discovered: bool = false

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var label: Label3D = $Label3D

func _ready() -> void:
    # Setup interaction area
    var interaction_area = Area3D.new()
    interaction_area.body_entered.connect(_on_body_entered)
    add_child(interaction_area)

    # Setup interaction collision shape
    var interaction_shape = CollisionShape3D.new()
    interaction_shape.shape = SphereShape3D.new()
    interaction_shape.shape.radius = 1.0
    interaction_area.add_child(interaction_shape)

func _on_body_entered(body) -> void:
    if body.name == "Player":
        # Show interaction prompt
        var ui = get_node("/root/Main/InteractionUI/Label")
        if ui:
            ui.text = "Press E to inspect: " + clue_name

func on_player_interact() -> void:
    if not discovered:
        discovered = true
        var evidence_manager = get_node("/root/Main/EvidenceManager")
        if evidence_manager:
            evidence_manager.discover_clue({
                "clue_id": clue_id,
                "clue_name": clue_name,
                "clue_description": clue_description,
                "location": location,
                "related_suspect": related_suspect
            })

        # Show clue information in UI
        var clue_ui = get_node("/root/Main/ClueUI")
        if clue_ui:
            clue_ui.show_clue_info({
                "clue_name": clue_name,
                "clue_description": clue_description,
                "location": location,
                "related_suspect": related_suspect
            })

        # Show discovery notification
        var ui = get_node("/root/Main/InteractionUI/Label")
        if ui:
            ui.text = "Clue discovered: " + clue_name
            await get_tree().create_timer(3.0).timeout
            ui.text = ""