extends CharacterBody3D

@export var npc_id: String = "npc"
@export var npc_name: String = "NPC"
@export var npc_role: String = "Villager"
@export var interaction_radius: float = 2.5

@onready var body: MeshInstance3D = $Body
@onready var head: MeshInstance3D = $Head
@onready var name_label: Label3D = $NameLabel

var personality: String = "neutral"
var goals: Array = []
var knowledge: Array = []
var secrets: Array = []
var memory: Array = []
var relationships: Dictionary = {}
var trust: float = 0.5
var suspicion: float = 0.5


func _ready() -> void:
    name_label.text = npc_name

    var coll_shape: Shape3D = $CollisionShape3D.shape
    if coll_shape is CapsuleShape3D:
        coll_shape.radius = 0.3
        coll_shape.height = 1.0

    var interaction_shape: Shape3D = $InteractionArea/CollisionShape3D.shape
    if interaction_shape is SphereShape3D:
        interaction_shape.radius = interaction_radius


func add_memory(memory_text: String) -> void:
    memory.append(memory_text)

    if memory.size() > 10:
        memory.remove_at(0)


func add_knowledge(knowledge_text: String) -> void:
    knowledge.append(knowledge_text)


func get_agent_state() -> Dictionary:
    return {
        "npc_id": npc_id,
        "npc_name": npc_name,
        "npc_role": npc_role,
        "personality": personality,
        "goals": goals.duplicate(),
        "knowledge": knowledge.duplicate(),
        "secrets": secrets.duplicate(),
        "memory": memory.duplicate(),
        "relationships": relationships.duplicate(),
        "trust": trust,
        "suspicion": suspicion
    }


signal interaction_requested(npc)

func on_player_interact() -> void:
    interaction_requested.emit(self)
