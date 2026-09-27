extends Node3D

func _ready() -> void:
    # Use existing AIClient node if available
    var ai_client = get_node_or_null("AIClient")
    if ai_client:
        if not ai_client.dialogue_response.is_connected(_on_dialogue_response):
            ai_client.dialogue_response.connect(_on_dialogue_response)

    # Use existing DialogueUI node if available
    var dialogue_ui = get_node_or_null("DialogueUI")
    if dialogue_ui:
        if not dialogue_ui.dialogue_closed.is_connected(_on_dialogue_closed):
            dialogue_ui.dialogue_closed.connect(_on_dialogue_closed)

    _setup_npc_interactions()

func _setup_npc_interactions() -> void:
    var npc_container = get_node_or_null("World/NPCs")
    if not npc_container:
        return
    for npc in npc_container.get_children():
        if npc.has_signal("interaction_requested"):
            if not npc.interaction_requested.is_connected(_on_npc_interaction_requested):
                npc.interaction_requested.connect(_on_npc_interaction_requested)

func _on_npc_interaction_requested(npc: Node) -> void:
    var dialogue_ui = get_node_or_null("DialogueUI")
    if dialogue_ui:
        dialogue_ui.start_dialogue(npc)

func _on_dialogue_closed() -> void:
    # Restore player control (handled by movement script)
    pass

func _on_dialogue_response(success: bool, reply: String, npc_id: String) -> void:
    var dialogue_ui = get_node_or_null("DialogueUI")
    if dialogue_ui:
        dialogue_ui.on_dialogue_response(success, reply, npc_id)