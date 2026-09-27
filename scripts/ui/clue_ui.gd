extends CanvasLayer

# UI Elements
@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/VBoxContainer/TitleLabel
@onready var description_label: Label = $Panel/VBoxContainer/DescriptionLabel
@onready var location_label: Label = $Panel/VBoxContainer/LocationLabel
@onready var suspect_label: Label = $Panel/VBoxContainer/SuspectLabel
@onready var close_button: Button = $Panel/VBoxContainer/CloseButton

func _ready():
    # Hide the panel initially
    panel.visible = false
    close_button.pressed.connect(_on_close_button_pressed)

func show_clue_info(clue_data):
    # Set the UI text
    title_label.text = clue_data["clue_name"]
    description_label.text = clue_data["clue_description"]
    location_label.text = "Location: " + clue_data["location"]
    suspect_label.text = "Related Suspect: " + clue_data["related_suspect"]

    # Show the panel
    panel.visible = true

func _on_close_button_pressed():
    # Hide the panel when close button is pressed
    panel.visible = false

func _input(event):
    # Close the panel when Escape is pressed
    if event.is_action_pressed("ui_cancel") and panel.visible:
        panel.visible = false