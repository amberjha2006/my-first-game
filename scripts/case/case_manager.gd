extends Node

# Case Manager for CASE: THE HOLLOW VILLAGE
# This system manages the deterministic case data
# All case information is stored in memory only

var current_case: Dictionary = {}

# Initialize with case 1 by default
func _ready():
    load_case(1)

# Load a specific case
func load_case(case_id: int) -> void:
    match case_id:
        1:
            current_case = {
                "case_id": 1,
                "title": "The Stolen Hollow Eye",
                "culprit": "Mira",
                "method": "smuggled the artifact out",
                "motive": "profit",
                "clues": [
                    "Torn Cloth",
                    "Strange Bottle"
                ]
            }
        2:
            current_case = {
                "case_id": 2,
                "title": "The Hollow Eye Heist",
                "culprit": "Rowan",
                "method": "used a fake key",
                "motive": "personal gain",
                "clues": [
                    "Broken Key",
                    "Old Footprint"
                ]
            }
        3:
            current_case = {
                "case_id": 3,
                "title": "The Hollow Eye Mystery",
                "culprit": "Vale",
                "method": "used an ancient ritual",
                "motive": "knowledge",
                "clues": [
                    "Ancient Mark",
                    "Hidden Ledger"
                ]
            }
        _:
            # Default to case 1 if invalid case_id
            current_case = {
                "case_id": 1,
                "title": "The Stolen Hollow Eye",
                "culprit": "Mira",
                "method": "smuggled the artifact out",
                "motive": "profit",
                "clues": [
                    "Torn Cloth",
                    "Strange Bottle"
                ]
            }

# Get the current case data
func get_current_case() -> Dictionary:
    return current_case.duplicate()

# Get the culprit for the current case
func get_culprit() -> String:
    return current_case.get("culprit", "")

# Get the method for the current case
func get_method() -> String:
    return current_case.get("method", "")

# Get the motive for the current case
func get_motive() -> String:
    return current_case.get("motive", "")

# Get the clues for the current case
func get_clues() -> Array:
    return current_case.get("clues", []).duplicate()