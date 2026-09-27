extends Node

# Evidence Manager for CASE: THE HOLLOW VILLAGE
# This system tracks discovered clues without determining guilt
# All evidence is stored in memory only

var discovered_clues: Array = []

# Add a clue to the evidence collection
func discover_clue(clue_data: Dictionary) -> void:
    if not is_clue_discovered(clue_data["clue_id"]):
        discovered_clues.append(clue_data)

# Check if a clue has already been discovered
func is_clue_discovered(clue_id: int) -> bool:
    for clue in discovered_clues:
        if clue["clue_id"] == clue_id:
            return true
    return false

# Get all discovered clues
func get_discovered_clues() -> Array:
    return discovered_clues

# Clear all discovered clues
func clear_discovered_clues() -> void:
    discovered_clues.clear()
