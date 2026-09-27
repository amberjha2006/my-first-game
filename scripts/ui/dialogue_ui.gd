extends CanvasLayer

# UI Elements
@onready var panel: Panel = $Panel
@onready var npc_name_label: Label = $Panel/VBoxContainer/NPCNameLabel
@onready var conversation_log: RichTextLabel = $Panel/VBoxContainer/ConversationLog
@onready var question_input: LineEdit = $Panel/VBoxContainer/QuestionInput
@onready var ask_button: Button = $Panel/VBoxContainer/ButtonRow/AskButton
@onready var close_button: Button = $Panel/VBoxContainer/ButtonRow/CloseButton

# Signals
signal dialogue_closed()

# Current NPC
var current_npc: Node = null

func _ready():
    # Hide the panel initially
    panel.visible = false
    ask_button.pressed.connect(_on_ask_button_pressed)
    close_button.pressed.connect(_on_close_button_pressed)

func start_dialogue(npc: Node) -> void:
    current_npc = npc
    npc_name_label.text = npc.npc_name
    conversation_log.text = ""
    question_input.text = ""
    panel.visible = true
    question_input.grab_focus()

func add_message(sender: String, message: String) -> void:
    conversation_log.append_text("[b]" + sender + ":[/b] " + message + "\n")

func _on_ask_button_pressed() -> void:
    var question = question_input.text.strip_edges()
    if question.length() == 0:
        return

    # Add player question to log
    add_message("You", question)
    question_input.text = ""
    ask_button.disabled = true

    # Get NPC state and case context
    var npc_state = current_npc.get_agent_state()
    var case_context = get_node("/root/Main/CaseManager").get_current_case()
    var discovered_clues = get_node("/root/Main/EvidenceManager").get_discovered_clues()

    # Send to AI client
    var ai_client = get_node("/root/Main/AIClient")
    if ai_client:
        ai_client.request_npc_dialogue(
            current_npc.npc_id,
            question,
            npc_state,
            case_context,
            discovered_clues
        )

func _on_close_button_pressed() -> void:
    panel.visible = false
    current_npc = null
    emit_signal("dialogue_closed")

func _input(event):
    # Close the dialogue when Escape is pressed
    if event.is_action_pressed("ui_cancel") and panel.visible:
        _on_close_button_pressed()

func on_dialogue_response(success: bool, reply: String, npc_id: String) -> void:
    if not panel.visible or current_npc.npc_id != npc_id:
        return

    if success:
        add_message(current_npc.npc_name, reply)
    else:
        add_message("System", "Unable to reach the village investigation server.")

    ask_button.disabled = false
    question_input.grab_focus()